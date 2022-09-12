local COMMANDS_LINK = "https://raw.githubusercontent.com/setcvar/stunning-pancake/main/commands"

local function getbody(link:string)
    return request({Url = tostring(link), Method = "GET"}).Body
end

local LOCALPLAYER = game.Players.LocalPlayer
local PLAYERS = game.Players
local CHARACTER = game.Players.LocalPlayer.Character


local function alreadyontable (t, value)
    for key, val in pairs (t) do
        if val == value or key == value then return true else return false end
    end
end

local function findplayer (playername: string): table
	local obj: table = {}

	
	-- check to see if its $random which means select a random player
	-- using $ for the rare cases the player has 'random' in their name
	local plrnm: string = string.gsub(playername, '%*', '', 1)
	if plrnm == 'random' then
		-- get all players
		local getplayers = PLAYERS:GetPlayers()
		-- use math.random to select a random index starting from 1 to the length of getplayers
		local random_index = math.random(1,#getplayers)
		local player = getplayers[random_index]
		table.insert (obj, player)
		plrnm = nil
		return obj
	end

	-- if everyone then just return every name and instance
	if playername == 'all' then
		for index, value in ipairs (PLAYERS:GetPlayers()) do
			table.insert (obj, value)
		end
		return obj
	end
	
	-- if others then return everyone except you
	if playername == 'others' then
		for index, value in ipairs (PLAYERS:GetPlayers()) do
			-- continue makes this one be skipped
			if value == LOCALPLAYER then
				continue
			end
			table.insert (obj, value)
		end
		return obj
	end

	if playername == 'me' then
		table.insert (obj, LOCALPLAYER)
		return obj
	end

	-- find the player and return it
	for index, value in ipairs (PLAYERS:GetPlayers()) do
		if string.lower (value.Name):match ("^" .. string.lower (playername)) then
			if not alreadyontable (obj, value) then
                table.insert (obj, value)
            end
		end
	end

	for index, value in ipairs (PLAYERS:GetPlayers()) do
		if string.lower (value.DisplayName):match ("^" .. string.lower(playername)) or
		string.lower(value.Character.Humanoid.DisplayName):match("^" .. string.lower(playername)) then
			if not alreadyontable(obj, value) then
                table.insert (obj,value)
            end
		end
	end
	
	return obj
end

local function run(command:string, arguments)
	command = string.lower(command)
	arguments = string.lower(arguments)
    local args = {vars = {
		LOCALPLAYER = game.Players.LocalPlayer,
		PLAYERS = game.Players,
		CHARACTER = game.Players.LocalPlayer.Character,
	}}
    local player = string.split(arguments, " ")
    local COMMANDS_BODY = request({Url = COMMANDS_LINK, Method = "GET"}).Body

    local lines = string.split (COMMANDS_BODY, "\n")

    for key, value in pairs (lines) do
        local split = string.split(value, " ")
        local cmd = split[1]
        local link = split[2]
        local reqplr = split[3]

		if cmd == command then
			if reqplr == "true" then
				args.playerobjects = findplayer(player[1])
				args.text = table.concat(player,' ', 2)
			elseif reqplr == "false" then
				args.text = table.concat(player, ' ')
			end
	
			if link then
				local body = request({Url = link, Method = "GET"}).Body
				local e = loadstring(body)()
				e.func(args)
			end
		end
		cmd = nil
		link = nil
		reqplr = nil
		split = nil
    end

	player = nil
	lines = nil
	COMMANDS_BODY = nil
end