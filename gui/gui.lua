local ScreenGui: ScreenGui = Instance.new ('ScreenGui', gethui() or game.CoreGui)
local Frame: Frame         = Instance.new ('Frame')
local Textbox: TextBox     = Instance.new ('TextBox')

ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB (98, 220, 184)
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new (0.295,0,0,35)
Frame.Position = UDim2.new (0.35, 0, 0.844, 0)

local TextBox: TextBox = Instance.new("TextBox")
TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new (0,0,0,0)
TextBox.Size = UDim2.new (1,0, 0, 33)
TextBox.PlaceholderText = "cmds"
TextBox.TextColor3 = Color3.fromRGB (255,255,255)
TextBox.Text = ""

return ScreenGui, Frame, TextBox