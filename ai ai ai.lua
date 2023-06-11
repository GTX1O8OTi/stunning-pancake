if not (game:IsLoaded()) then repeat task.wait() until game:IsLoaded() end

local error = erroruiconsole or error
local warn = warnuiconsole or warn
local print = printuiconsole or print

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = gethui() or game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local TextBox = Instance.new("TextBox")
TextBox.Parent = ScreenGui
TextBox.Size = UDim2.fromScale(0.25,0.076)
TextBox.Position = UDim2.fromScale(0.5,0.759)
TextBox.AnchorPoint = Vector2.new(0.5,0.5)
TextBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
TextBox.PlaceholderText = "hello :)"
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.TextSize = 20
TextBox.FontFace.Weight = Enum.FontWeight.Bold
TextBox.Text = ""

local UICorner = Instance.new("UICorner")
UICorner.Parent = TextBox
UICorner.CornerRadius = UDim.new(0.2,0)

local UIStroke = Instance.new("UIStroke")
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = TextBox
UIStroke.Color = Color3.fromRGB(38,255,0)
UIStroke.LineJoinMode = Enum.LineJoinMode.Round
UIStroke.Thickness = 1

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundTransparency = 1
Frame.AutomaticSize = Enum.AutomaticSize.XY
Frame.Size = UDim2.fromScale(0,0.9)
Frame.Position = UDim2.fromScale(0.75,0.03)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Frame
UIListLayout.Padding = UDim.new(0.01,0)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

local function Notify (text)
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Parent = Frame
	TextLabel.AutomaticSize = Enum.AutomaticSize.XY
	TextLabel.BackgroundColor3 = Color3.fromRGB(47,47,47)
	TextLabel.Size = UDim2.fromScale(0.6,0.08)
	TextLabel.FontFace.Weight = Enum.FontWeight.Bold
	TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
	TextLabel.RichText = true
	TextLabel.Text = text
	TextLabel.BackgroundTransparency = 1

	local UICorner = Instance.new("UICorner")
	UICorner.Parent = TextLabel
	UICorner.CornerRadius = UDim.new (0.1,0)

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Parent = TextLabel
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.LineJoinMode = Enum.LineJoinMode.Round
	UIStroke.Color = Color3.fromRGB(255,255,255)
	UIStroke.Thickness = 2
	
	local Tween = game:GetService("TweenService")
	local info = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false,0)
	local tween = Tween:Create(TextLabel, info, {BackgroundTransparency = 0})
	tween:Play()
	tween.Completed:Wait()
	game:GetService("Debris"):AddItem(TextLabel, 1)
end

local function GetCommandPlayer (Text)
	local SpecialUseCases = {"all","me", "random", "others"}
	local selected_player = {}
	
	local Players = game:GetService("Players"):GetPlayers()
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
	BOOL = 7,
}

local cmd_table = {}

local coroutines = {}
local CoroutineManager = {}

function CoroutineManager:Create(name, func): thread
	if coroutines[name] then coroutine.close(coroutines[name]) end
	local c = coroutine.create(func)
	coroutines[name] = c
	return c
end

function CoroutineManager:Start(cor: string | thread)
	if typeof(cor) == "thread" then
		coroutine.resume(cor)
	else
		coroutine.resume(coroutines[cor])
	end
end

function CoroutineManager:Close(cor: string | thread)
	if typeof(cor) == "thread" then
		coroutine.close(cor)
	else
		coroutine.close(coroutines[cor])
	end
end

function CoroutineManager:Yield(cor: string | thread)
	if typeof(cor) == "thread" then
		coroutine.yield(cor)
		
	else
		coroutine.yield(coroutines[cor])
	end
end

function CoroutineManager:Status(cor: string | thread)
	if typeof(cor) == "thread" then
		return coroutine.status(cor)
	else
		return coroutine.status(coroutines[cor])
	end
end

local Services = {
	Players = game:GetService("Players"),
	Workspace = game:GetService("Workspace"),
	Teleport = game:GetService("TeleportService"),
	RunS = game:GetService("RunService"),
	Http = game:GetService("HttpService"),
	RepStorage = game:GetService("ReplicatedStorage"),
	UIS = game:GetService("UserInputService"),
}

local function GetCharacter(): Model?
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
		if #Services.Workspace:GetDescendants() > 2000 then
			print("This will lag alot")
		end
		local function forloop()
			
			local function MakeSelectionBox(object)
				local box = Instance.new("SelectionBox")
				box:SetAttribute("cf", 1)
				box.Parent = object
				box.LineThickness = 0.015
				box.Adornee = object
				if object.Transparency > 0 then
					box.Color3 = Color3.fromRGB(255,201,252)
				else
					box.Color3 = Color3.fromRGB(201,248,255)
				end
			end
			
			for _, v in ipairs (Services.Workspace:GetDescendants()) do
				if not v:IsA("BasePart") then continue end
				MakeSelectionBox(v)
			end
			
			Services.Workspace.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("BasePart") then
					MakeSelectionBox(descendant)
				end
			end)
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
		local c = CoroutineManager:Create("unhitboxloop", function()
			for _,v in ipairs (Services.Workspace:GetDescendants()) do
				if not v:IsA("BasePart") then continue end
				if (v and v:FindFirstChild("SelectionBox") and v.SelectionBox:GetAttribute("cf")) then
					v.SelectionBox:Destroy()
				end
			end
		end)
		CoroutineManager:Start(c)
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
		
		local c = CoroutineManager:Create("n1", function()
			for _,v in ipairs (cache.parts) do
				if not v:IsA("BasePart") then continue end
				if v.CanCollide == false then continue end
				v.CanCollide = false
				v:SetAttribute("cf", true)
			end
		end)
		CoroutineManager:Start(c)
		
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
	names = {"clip", "unnoclip"},
	desc = "Makes you clip into reality",
	ctype = {CMD_TYPE.NONE},
	load = function()
		CoroutineManager:Close("noclip")
		
		local c = CoroutineManager:Create("n2", function()
			for i,v in ipairs(Services.Players.LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") and v:GetAttribute("cf") and v.CanCollide == false then
					v.CanCollide = true
					v:SetAttribute("cf", nil)
				end
			end
		end)
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
		Services.Workspace.CurrentCamera.CameraSubject = Services.Players.LocalPlayer.Character.Humanoid
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"fov"},
	desc = "Changes your field of view",
	ctype = {CMD_TYPE.NUMBER},
	load = function(args)
		Services.Workspace.CurrentCamera.FieldOfView = args[1]
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"spam"},
	desc = "really?",
	ctype = {CMD_TYPE.NUMBER, CMD_TYPE.INF},
	load = function(args)
		
		local c = CoroutineManager:Create("spam", function()
			local text = table.concat(string.split(args[2], " "), " ", 2)
			while wait(args[1]) do
				Services.RepStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All")
			end
		end)
		
		CoroutineManager:Start(c)
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"unspam"},
	desc = "oh wow",
	ctype = {CMD_TYPE.NONE},
	load = function()
		CoroutineManager:Close("spam")
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"render"},
	desc = "Makes your game render or not",
	ctype = {CMD_TYPE.BOOL},
	load = function(args)
		Services.RunS:Set3dRenderingEnabled(args[1])
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"friendlog"},
	desc = "Notifies when a friend joins the server",
	ctype = {CMD_TYPE.NONE},
	load = function()
		local c = CoroutineManager:Create("friendlog", function()
			Services.Players.PlayerAdded:Connect(function(player)
				if player:IsFriendsWith(Services.Players.LocalPlayer.UserId) then
					Notify ("<font color='rgb(100,255,0)'>".. player.Name .. "</font> has joined the server")
				end
			end)
		end)
		CoroutineManager:Start(c)
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"unfriendlog"},
	desc = "Stops notifying when a friend join",
	ctype = {CMD_TYPE.NONE},
	load = function()
		CoroutineManager:Close("friendlog")
	end,
}

cmd_table[#cmd_table+1] = {
	names = {"notifypos", "notifyposition"},
	desc= "Notifies the position of a player",
	ctype = {CMD_TYPE.PLAYER},
	load = function(args)
		for _,v in ipairs(args) do
			Notify (tostring(v.Character.HumanoidRootPart.Position))
		end
	end,
}

local function RunCommand (input)
	if input == "" then return end
	local input = string.lower(input)
	local cache = {
		str_split1 = string.split(input, " "),
		str_split2 = string.split(table.concat(string.split(input, " "), " ", 2), " "),
		cmd_table = cmd_table,
	}
	
	local command = cache.str_split1[1]
	
	for _,v in ipairs (cache.cmd_table) do
		
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
			
			if not cache.str_split2[i] then return end
			
			if command.ctype[i] == CMD_TYPE.STRING then
				args[i] = tostring(cache.str_split2[i])
			elseif command.ctype[i] == CMD_TYPE.NUMBER then
				args[i] = tonumber(cache.str_split2[i])
			elseif command.ctype[i] == CMD_TYPE.PLAYER then
				args[i] = GetCommandPlayer(cache.str_split2[i])
			elseif command.ctype[i] == CMD_TYPE.INF then
				args[i] = table.concat(cache.str_split2, " ")
			elseif command.ctype[i] == CMD_TYPE.BOOL then
				if cache.str_split2[i] == "true" then
					args[i] = true
				elseif cache.str_split2[i] == "false" then
					args[i] = false
				end
			end
			
		end
		
		local c = CoroutineManager:Create(Services.Http:GenerateGUID(false), function()
			command.load(args)
		end)
		
		CoroutineManager:Start(c)
		
		Notify("Executed the command " .. "<b><font color = 'rgb(0,200,100)' weight='900'>".. command.names[1] .. "</font></b>")
		
	else
		Notify("Couldn't find the command " .. "<font color = 'rgb(0,200,255)'>" .. tostring(command) .. "</font>")
	end
	
end

local uis = Services.UIS
uis.InputBegan:Connect(function(input, e)
	if e then return end
	if input.KeyCode == Enum.KeyCode.RightBracket then
		TextBox:CaptureFocus()
		spawn(function()
			repeat TextBox.Text = "" until TextBox.Text == ""
		end)
	end
end)

TextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		RunCommand(TextBox.Text)
		TextBox.Text = ""
	end
end)
