if not (game:IsLoaded()) then repeat task.wait() until game:IsLoaded() end

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
	return selected_player
end

local CMD_TYPE = {
	STRING = 1,
	NUMBER = 2,
	PLAYER = 3,
	CMD = 4,
	NONE = 5,
}

local cmd_table = {}

local function Services()
	local servs = {
		Players = game:GetService("Players"),
		Workspace = game:getService("Workspace"),
	}
	return servs
end

cmd_table[#cmd_table+1] = {
	names = {"speed", "ws"},
	desc = "Changes your walkspeed",
	ctype = {CMD_TYPE.NUMBER},
	load = function(args)
		local character = Services().Workspace:FindFirstChild(Services().Players.LocalPlayer.Name)
		if character then
			character.Humanoid.WalkSpeed = args[1]
		end
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"jumppower", "jp"},
	desc = "Changes your jumppower",
	ctype = {CMD_TYPE.NUMBER},
	load = function(args)
		local character = Services().Workspace:FindFirstChild(Services().Players.LocalPlayer.Name)
		if character then
			character.Humanoid.JumpPower = args[1]
		end
	end,
}

local function RunCommand (input)
	local cache = {
		str_split1 = string.split(input, " "),
		str_split2 = string.split(table.concat(string.split(input, " "), " ", 2), " "),
		cmd_table = cmd_table,
	}
	
	local command = cache.str_split1[1]
	
	for i,v in ipairs (cache.cmd_table) do
		
		for i = 1, #v.names,1 do
			if v.names[i] == command then
				command = v
			end
		end
		
	end
	
	local args = {}
	
	if typeof(command) == "table" then
		
		local num_args = #command.ctype
		
		for i = 1, num_args, 1 do
			
			if command.ctype[i] == CMD_TYPE.STRING then
				args[i] = tostring(cache.str_split2[i])
			elseif command.ctype[i] == CMD_TYPE.NUMBER then
				args[i] = tonumber(cache.str_split2[i])
			elseif command.ctype[i] == CMD_TYPE.PLAYER then
				args[i] = GetCommandPlayer(cache.str_split2[i])
			end
			
		end
		
		command.load(args)
	end
	
end
