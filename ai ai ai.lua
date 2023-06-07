local function GetCommandPlayer (Text)
	local SpecialUseCases = {"all","me", "random", "others"}
	local selected_player = {}
	local Players = game.Players:GetPlayers()
	local player = game:GetService("Players").LocalPlayer

	local cases = {
		["all"] = function() for k,v in pairs (Players) do selected_player[#selected_player+1] = v end end,
		["others"] = function() for k,v in pairs (Players) do if v.Name ~= player.Name then selected_player[#selected_player+1] = v end end end,
		["random"] = function() local number = math.random(1,#Players) selected_player[#selected_player+1] = Players[number] end,
		["me"] = function() selected_player[#selected_player+1] = player end,
	}

	local Split_Text = string.split(Text, " ")

	local hi = Split_Text[1]:lower()

	table.remove(Split_Text, 1) -- command, useless in this function
	local idk = string.gsub(hi, "%$", "")

	for _, yeet in next, SpecialUseCases do
		for k,func in pairs (cases) do
			if yeet == idk and k == idk then func() end
		end
	end

	for _, plr in pairs (Players) do
		local e = hi
		if string.lower (plr.Name):match("^"..string.lower(e)) or string.lower (plr.DisplayName):match("^"..string.lower(e)) or string.lower(plr.Character.Humanoid.DisplayName):match("^"..string.lower(e)) then
			selected_player[#selected_player+1] = plr
		end
	end

	if string.find(hi, ",") then
		local hi = hi:split(",")
		for k,v in pairs (hi) do
			selected_player[#selected_player+1] = GetCommandPlayer(v)[1]
		end
	end

	if DEBUG then
		print(selected_player)
	end

	return selected_player
end

local function RemoveCommands (_table)
	local MAX_ITERATIONS = #_table
	for i = 1, MAX_ITERATIONS do
		_table[i] = nil
	end
end

local function RequestCMDLinkBody()
	return request({Url = "https://raw.githubusercontent.com/setcvar/stunning-pancake/main/commands", Method = "GET"}).Body
end

local function CreateCmdTable(Name, Link, Req_player, Alias)
	local cmd_table = {}
	cmd_table.Name = Name
	cmd_table.Link = Link
	cmd_table.Req_player = Req_player
	cmd_table.Alias = Alias
	return cmd_table
end

local function GetCommand(input)
	local body = RequestCMDLinkBody()
	local lines = string.split (body, "\n")
	local MAX_ITERATIONS = #lines
	for i = 1, MAX_ITERATIONS do
		local current_line = string.split(lines[i], " ")

		if input then
			local alias = string.split(table.concat(current_line, " ", 4), " ")
			return CreateCmdTable (current_line[1],current_line[2], current_line[3], alias)

		else
			local current_line = string.split(lines[i], " ")

			local MAX_ITERATIONS = #current_line

			for i = 1, MAX_ITERATIONS do
				local alias = string.split(table.concat(current_line, " ", 4), " ")
				if alias[i] == input then
					return CreateCmdTable (current_line[1],current_line[2], current_line[3], alias)
				end
			end
		end
	end
end

local function RunCommand (input)
	local word = string.split(input, " ")
	local cmd = GetCommand(word[1])

	local arguments = {}
	if cmd.Req_player == "true" then
		arguments.playerobjects = GetCommandPlayer(word[2])
		arguments.text = table.concat(word, " ", 3)
	else
		arguments.text = table.concat(word, " ", 2)
	end

	local load = loadstring(cmd.Link)()
	load.func (arguments)
end
