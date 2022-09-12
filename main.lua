local COMMANDS_LINK = "https://raw.githubusercontent.com/setcvar/stunning-pancake/main/commands"

local function getbody(link:string)
    return request({Url = tostring(link), Method = "GET"}).Body
end

local LOCALPLAYER = game.Players.LocalPlayer
local PLAYERS = game.Players
local CHARACTER = game.Players.LocalPlayer.Character

function findplayer (playername: string): table
	local name: table = {}
	local obj: table = {}

	-- check to see if its $random which means select a random player
	-- using $ for the rare cases the player has 'random' in their name
	local plrnm: string = string.gsub(playername, '%$', '', 1)
	if plrnm == 'random' then
		-- get all players
		local getplayers = game.Players:GetPlayers()
		-- use math.random to select a random index starting from 1 to the length of getplayers
		local random_index = math.random(1,#getplayers)
		local player = getplayers[random_index]
		table.insert (name, player.Name)
		table.insert (obj, player)
		plrnm = nil
		return name, obj
	end

	local playernames = string.split (playername, ',')
	for key, player in pairs (game.Players:GetPlayers()) do
		for index, value in pairs (playernames) do
			if string.lower (player.Name):match ("^" .. string.lower(value)) or
			string.lower(player.Character.Humanoid.DisplayName):match("^" .. string.lower(value)) then
				table.insert (name, player.Name)
				table.insert (obj, player)
			end
		end
	end

	-- if everyone then just return every name and instance
	if playername == 'all' then
		for index, value in ipairs (game.Players:GetPlayers()) do
			table.insert (name, value.Name)
			table.insert (obj, value)
		end
		return name, obj
	end
	
	-- if others then return everyone except you
	if playername == 'others' then
		for index, value in ipairs (game.Players:GetPlayers()) do
			-- continue makes this one be skipped
			if value == game.Players.LocalPlayer then
				continue
			end
			table.insert (name, value.Name)
			table.insert (obj, value)
		end
		return name, obj
	end

	if playername == 'me' then
		table.insert (name, game.Players.LocalPlayer.Name)
		table.insert (obj, game.Players.LocalPlayer)
		return name, obj
	end

	-- find the player and return it
	for index, value in ipairs (game.Players:GetPlayers()) do
		if string.lower (value.Name):match ("^" .. string.lower (playername)) then
			table.insert (name, value.Name)
			table.insert (obj, value)
		end
	end

	for index, value in ipairs (game.Players:GetPlayers()) do
		if string.lower (value.DisplayName):match ("^" .. string.lower(playername)) or
		string.lower(value.Character.Humanoid.DisplayName):match("^" .. string.lower(playername)) then
			table.insert (name, value.Name)
			table.insert (obj,value)
		end
	end
	
	return name, obj
end

local function run(command:string, arguments)
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
				print(true)
				args.playernames,args.playerobjects = findplayer(player[1])
				args.text = table.concat(player,' ', 2)
			elseif reqplr == "false" then
				args.text = table.concat(player, ' ')
			end
	
			if link then
				local body = request({Url = link, Method = "GET"}).Body
				local e = loadstring(body)()
				--setfenv(e.func, getfenv(0))
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

run('print','hi :)')
