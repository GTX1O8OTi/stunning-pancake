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
	INF = 6,
}

local cmd_table = {}

local coroutines = {}
local CoroutineManager = {}

function CoroutineManager:Create(name, func)
	local c = coroutine.create(func)
	coroutines[name] = c
	return c
end

function CoroutineManager:Start(name)
	coroutine.resume(coroutines[name])
end

function CoroutineManager:Close(name)
	coroutine.close(coroutines[name])
end

function CoroutineManager:Yield(name)
	coroutine.yield(coroutines[name])
end

local Services = {
	Players = game:GetService("Players"),
	Workspace = game:GetService("Workspace"),
	Teleport = game:GetService("TeleportService"),
	RunS = game:GetService("RunService"),
}

local function GetCharacter()
	local character = Services.Players.LocalPlayer.Character or Services.Players.LocalPlayer.CharacterAdded:Wait()
	return character
end

cmd_table[#cmd_table+1] = {
	names = {"speed", "ws"},
	desc = "Changes your walkspeed",
	ctype = {CMD_TYPE.NUMBER},
	load = function(args)
		local character = Services.Workspace:FindFirstChild(Services.Players.LocalPlayer.Name)
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
		local character = Services.Workspace:FindFirstChild(Services.Players.LocalPlayer.Name)
		if character then
			character.Humanoid.JumpPower = args[1]
		end
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"print", "p"},
	desc = "",
	ctype = {CMD_TYPE.INF},
	load = function(args)
		print(args[1])
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"spin"},
	desc = "you spin",
	ctype = {CMD_TYPE.NUMBER},
	load = function(args)
		local cache = {RootPart = GetCharacter().HumanoidRootPart, Humanoid = GetCharacter().Humanoid}
		local spin_speed = args[1] or 5
		if cache.Humanoid.RigType == Enum.RigType.R15 then
			local av = Instance.new("AngularVelocity")
			av.AngularVelocity = Vector3.new(0, spin_speed, 0)
			av.Parent = cache.RootPart
			av.MaxTorque = Vector3.new(0, math.huge, 0)
			av.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
			av.Attachment0 = cache.RootPart.RootAttachment
			av:SetAttribute("cf", 1)
			
		else
			local bav = Instance.new("BodyAngularVelocity")
			bav.AngularVelocity = Vector3.new(0, spin_speed, 0)
			bav.MaxTorque = Vector3.new(0, math.huge, 0)
			bav.Parent = cache.RootPart
			bav:SetAttribute("cf", 1)
		end 
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"unspin"},
	desc = "no spin :(",
	ctype = {CMD_TYPE.NONE},
	load = function()
		local cache = {RootPart = GetCharacter().HumanoidRootPart}
		local spin = cache.RootPart:FindFirstChild("AngularVelocity") or cache.RootPart:FindFirstChild("BodyAngularVelocity")
		if spin:GetAttribute("cf") then
			spin:Destroy()
		end
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"rejoin", "rj"},
	desc = "rejoin game :)",
	ctype = {CMD_TYPE.NONE},
	load = function()
		Services.Players.LocalPlayer:Kick("You're banned for 99999 days")
		task.wait(0.3)
		if #Services.Players:GetPlayers() <= 1 then
			Services.Teleport:Teleport(game.PlaceId, Services.Players.LocalPlayer)
		else
			Services.Teleport:TeleportToPlaceInstance(game.PlaceId, game.JobId, Services.Players.LocalPlayer)
		end
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"hitbox"},
	desc = "You see stuff you shouldn't see lol",
	ctype = {CMD_TYPE.NONE},
	load = function()
		local cache = {parts = Services.Workspace:GetDescendants()}
		if #cache.parts > 2000 then
			print("This will lag alot")
		end
		local function forloop()
			for _, v in ipairs (cache.parts) do
				if not v:IsA("BasePart") then continue end
				local box = Instance.new("SelectionBox")
				box:SetAttribute("cf", 1)
				box.Parent = v
				box.LineThickness = 0.015
				box.Adornee = v
				if v.Transparency > 0 then
					box.Color3 = Color3.fromRGB(255,201,252)
				else
					box.Color3 = Color3.fromRGB(201,248,255)
				end
			end
		end
		
		local c = CoroutineManager:Create("hitboxloop", forloop)
		CoroutineManager:Start("hitboxloop")
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"unhitbox"},
	desc = "e",
	ctype = {CMD_TYPE.NONE},
	load = function()
		local cache = {parts = Services.Workspace:GetDescendants()}
		local function forloop()
			for _,v in ipairs (cache.parts) do
				if not v:IsA("BasePart") then continue end
				if v:GetAttribute("cf") then
					v:Destroy()
				end
			end
		end
		local c = CoroutineManager:Create("unhitboxloop", forloop)
		CoroutineManager:Start("hitboxloop")
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"cmds", "commands"},
	desc = "Prints commands",
	ctype = {CMD_TYPE.NONE},
	load = function()
		for i = 1, #cmd_table, 1 do
			local e = table.concat(cmd_table[i].names, " ")
			print(e)
		end
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"noclip", "nc"},
	desc = "Noclips you into the backrooms",
	ctype = {CMD_TYPE.NONE},
	load = function()
		local cache = {parts = Services.Players.LocalPlayer.Character:GetDescendants()}
		
		for _,v in ipairs (cache.parts) do
			if not v:IsA("BasePart") then continue end
			if v.CanCollide == false then continue end
			v.CanCollide = false
			v:SetAttribute("cf", true)
		end
		
		local function nc()
			Services.RunS.Stepped:Connect(function()
				for _,v in ipairs(Services.Players.LocalPlayer.Character:GetDescendants()) do
					if not v:IsA("BasePart") then continue end
					if v:GetAttribute("cf") then
						v.CanCollide = false
					end
				end
			end)
		end

		local c = CoroutineManager:Create("noclip", nc)
		CoroutineManager:Start(c)
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"goto", "to"},
	desc = "tp to others",
	ctype = {CMD_TYPE.PLAYER},
	load = function(args)
		for i = 1, #args do
			Services.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = args[i].Character.HumanoidRootPart.CFrame
		end
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"view"},
	desc = "Changes your camera to someone else",
	ctype = {CMD_TYPE.PLAYER},
	load = function(args)
		local player
		for i = 1, #args do
			Services.Workspace.CurrentCamera.CameraSubject = args[i].Character.Humanoid
			player = args[i]
		end
		
		local function yeet()
			player.Character.Humanoid.Died:Connect(function()
				Services.Workspace.CurrentCamera.CameraSubject = Services.Players.LocalPlayer.Character.Humanoid
			end)
		end
		
		local c = CoroutineManager:Create("view", yeet)
		CoroutineManager:Start(c)
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"unview"},
	desc = "Stops viewing someone else",
	ctype = {CMD_TYPE.NONE},
	load = function()
		CoroutineManager:Close("view")
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
			elseif command.ctype[i] == CMD_TYPE.INF then
				args[i] = table.concat(cache.str_split2, " ")
			end
			
		end
		
		local function run()
			command.load(args)
		end
		
		local c = CoroutineManager:Create("cmd_execution", run)
		CoroutineManager:Start("cmd_execution")
	end
	
end

local uis = game.UserInputService
uis.InputBegan:Connect(function(input, e)
	if e then return end
	
	if input.KeyCode == Enum.KeyCode.E then
		RunCommand("to me,others")
	end
end)
