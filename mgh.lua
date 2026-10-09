-- ========================================================
-- MultiGame Hub | Dark Ninja Theme (Blue - Red - Black)
-- ========================================================

-- 1. Loading Screen & Progress Bar System
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local function ShowLoadingScreen()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MultiGameHub_Loader"
    ScreenGui.Parent = CoreGui
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 350, 0, 180)
    Frame.Position = UDim2.new(0.5, -175, 0.5, -90)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 10)
    
    local UIStroke = Instance.new("UIStroke", Frame)
    UIStroke.Color = Color3.fromRGB(220, 20, 60) -- Dark Crimson Red
    UIStroke.Thickness = 2

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.BackgroundTransparency = 1
    Title.Text = "MultiGame Hub"
    Title.TextColor3 = Color3.fromRGB(0, 150, 255) -- Ninja Blue
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Position = UDim2.new(0, 0, 0, 55)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Bypassing Security Systems..."
    SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    SubTitle.TextSize = 13
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Parent = Frame

    local BarBackground = Instance.new("Frame")
    BarBackground.Size = UDim2.new(0.85, 0, 0, 12)
    BarBackground.Position = UDim2.new(0.075, 0, 0, 110)
    BarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    BarBackground.BorderSizePixel = 0
    BarBackground.Parent = Frame
    Instance.new("UICorner", BarBackground).CornerRadius = UDim.new(0, 6)

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = BarBackground
    Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(0, 6)

    -- Animate Progress Bar
    TweenService:Create(ProgressBar, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(2.7)
    ScreenGui:Destroy()
end

-- รันหน้าโหลดก่อนเข้าสู่ UI หลัก
ShowLoadingScreen()

-- 2. Final Bypass System (Anti-Cheat & Network Bypass)
local function ExecuteFinalBypass()
    local raw_hook
    raw_hook = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() then
            if method == "FireServer" or method == "InvokeServer" then
                local name = string.lower(self.Name)
                if name:find("cheat") or name:find("ban") or name:find("detect") or name:find("anti") then
                    return nil
                end
            end
        end
        return raw_hook(self, ...)
    end)
    
    -- Disabling known Local Script Anti-Cheats safely
    for _, v in pairs(game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerScripts"):GetChildren()) do
        if v:IsA("LocalScript") and (v.Name:lower():find("anti") or v.Name:lower():find("cheat")) then
            v.Disabled = true
        end
    end
end
pcall(ExecuteFinalBypass)

-- 3. Load Rayfield Library with Dark Ninja Colors
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MultiGame Hub | Dark Ninja Edition",
   LoadingTitle = "MultiGame Hub Loading",
   LoadingSubtitle = "Dark Ninja Theme Initialized",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- 4. Variables & Settings Storage
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Settings = {
    -- ESP Settings
    BoxESP = false,
    SkeletonESP = false,
    HealthESP = false,
    RainbowESP = false,
    NameESP = false,
    DistanceESP = false,
    ESPTeamCheck = true,
    ESPWallCheck = false,
    ESPDistance = 1000,
    
    -- Aim Settings
    SilentAim = false,
    FOVCircle = false,
    FOVRadius = 100,
    TargetLine = false,
    AimTeamCheck = true,
    AimWallCheck = false,
    MaxAimDistance = 500,

    -- Misc Settings
    InfiniteAmmo = false,
    InfiniteStamina = false
}

-- Target Finding Helper
local function GetClosestTarget()
    local Closest = nil
    local MaxDist = Settings.FOVRadius
    local MousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                
                -- Team Check
                if Settings.AimTeamCheck and player.Team == LocalPlayer.Team then continue end

                local HRP = player.Character.HumanoidRootPart
                local Distance = (HRP.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                
                -- Max Distance Check
                if Distance > Settings.MaxAimDistance then continue end

                -- Wall Check
                if Settings.AimWallCheck then
                    local RayParam = RaycastParams.new()
                    RayParam.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                    RayParam.FilterType = Enum.RaycastFilterType.Exclude
                    local RayResult = workspace:Raycast(Camera.CFrame.Position, HRP.Position - Camera.CFrame.Position, RayParam)
                    if RayResult then continue end
                end

                -- FOV Distance Check
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)
                if OnScreen then
                    local Mag = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                    if Mag < MaxDist then
                        MaxDist = Mag
                        Closest = player.Character
                    end
                end
            end
        end
    end
    return Closest
end

-- ========================================================
-- UI TABS SETUP
-- ========================================================

local ESPTab = Window:CreateTab("ESP Systems", 4483362458)
local AimTab = Window:CreateTab("Silent Aim", 4483362458)
local MiscTab = Window:CreateTab("Player & Weapons", 4483362458)

-- --------------------------------------------------------
-- ESP CONTROLS
-- --------------------------------------------------------
ESPTab:CreateToggle({Name = "Box ESP (กรอบรอบตัว)", CurrentValue = false, Callback = function(v) Settings.BoxESP = v end})
ESPTab:CreateToggle({Name = "Skeleton ESP (โครงกระดูก)", CurrentValue = false, Callback = function(v) Settings.SkeletonESP = v end})
ESPTab:CreateToggle({Name = "Health ESP (หลอดเลือด)", CurrentValue = false, Callback = function(v) Settings.HealthESP = v end})
ESPTab:CreateToggle({Name = "Rainbow ESP (สีรุ้ง)", CurrentValue = false, Callback = function(v) Settings.RainbowESP = v end})
ESPTab:CreateToggle({Name = "Name ESP (ชื่อผู้เล่น)", CurrentValue = false, Callback = function(v) Settings.NameESP = v end})
ESPTab:CreateToggle({Name = "Distance ESP (ระยะทาง)", CurrentValue = false, Callback = function(v) Settings.DistanceESP = v end})
ESPTab:CreateToggle({Name = "Team Check (ซ่อนเพื่อน)", CurrentValue = true, Callback = function(v) Settings.ESPTeamCheck = v end})
ESPTab:CreateToggle({Name = "Wall Check (ซ่อนหลังกำแพง)", CurrentValue = false, Callback = function(v) Settings.ESPWallCheck = v end})
ESPTab:CreateSlider({
   Name = "ESP Distance (ระยะแสดงผล)", Range = {100, 5000}, Increment = 50, Suffix = "m", CurrentValue = 1000,
   Callback = function(v) Settings.ESPDistance = v end,
})

-- --------------------------------------------------------
-- AIM CONTROLS
-- --------------------------------------------------------
AimTab:CreateToggle({Name = "Silent Aim (ยิงเข้าเป้าไม่ล็อคกล้อง)", CurrentValue = false, Callback = function(v) Settings.SilentAim = v end})
AimTab:CreateToggle({Name = "FOV Circle (แสดงวงกลมเล็ง)", CurrentValue = false, Callback = function(v) Settings.FOVCircle = v end})
AimTab:CreateSlider({
   Name = "FOV Radius (ขนาดวงกลม)", Range = {30, 500}, Increment = 5, Suffix = "px", CurrentValue = 100,
   Callback = function(v) Settings.FOVRadius = v end,
})
AimTab:CreateToggle({Name = "Target Line (เส้นชี้เป้าสีแดง)", CurrentValue = false, Callback = function(v) Settings.TargetLine = v end})
AimTab:CreateToggle({Name = "Team Check (ไม่เล็งเพื่อน)", CurrentValue = true, Callback = function(v) Settings.AimTeamCheck = v end})
AimTab:CreateToggle({Name = "Wall Check (ไม่เล็งผ่านกำแพง)", CurrentValue = false, Callback = function(v) Settings.AimWallCheck = v end})
AimTab:CreateSlider({
   Name = "Max Aim Distance (ระยะเล็งสูงสุด)", Range = {50, 2000}, Increment = 50, Suffix = "m", CurrentValue = 500,
   Callback = function(v) Settings.MaxAimDistance = v end,
})

-- --------------------------------------------------------
-- MISC CONTROLS
-- --------------------------------------------------------
MiscTab:CreateToggle({
    Name = "Infinite Ammo (กระสุนไม่จำกัด)",
    CurrentValue = false,
    Callback = function(v)
        Settings.InfiniteAmmo = v
        if v then
            task.spawn(function()
                while Settings.InfiniteAmmo do
                    pcall(function()
                        local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if Tool then
                            for _, item in pairs(Tool:GetDescendants()) do
                                if item:IsA("IntValue") or item:IsA("NumberValue") then
                                    if item.Name:lower():find("ammo") or item.Name:lower():find("clip") then
                                        item.Value = 999
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

MiscTab:CreateToggle({
    Name = "Infinite Stamina (สตามิน่าไม่ลด)",
    CurrentValue = false,
    Callback = function(v)
        Settings.InfiniteStamina = v
        if v then
            task.spawn(function()
                while Settings.InfiniteStamina do
                    pcall(function()
                        if LocalPlayer.Character then
                            local Stamina = LocalPlayer.Character:FindFirstChild("Stamina") or LocalPlayer:FindFirstChild("Stamina")
                            if Stamina then
                                Stamina.Value = 100
                            end
                        end
                    end)
                    task.wait(0.2)
                end
            end)
        end
    end
})

-- ========================================================
-- DRAWING OVERLAYS (FOVCircle & Target Line & Silent Aim)
-- ========================================================

local FOVRing = Drawing.new("Circle")
FOVRing.Color = Color3.fromRGB(0, 150, 255)
FOVRing.Thickness = 1.5
FOVRing.NumSides = 60
FOVRing.Filled = false
FOVRing.Visible = false

local TracerLine = Drawing.new("Line")
TracerLine.Color = Color3.fromRGB(255, 0, 50) -- Red Target Line
TracerLine.Thickness = 2
TracerLine.Visible = false

-- Silent Aim Hook (Redirect Hit Points)
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, index)
    if not checkcaller() and Settings.SilentAim and index:lower() == "hit" then
        local target = GetClosestTarget()
        if target and target:FindFirstChild("Head") then
            return target.Head.CFrame
        end
    end
    return oldIndex(self, index)
end)

-- Main Render Loop
RunService.RenderStepped:Connect(function()
    local MousePos = UserInputService:GetMouseLocation()

    -- FOV Update
    FOVRing.Visible = Settings.FOVCircle
    FOVRing.Radius = Settings.FOVRadius
    FOVRing.Position = MousePos

    -- Target Line Update
    local Target = GetClosestTarget()
    local Character = LocalPlayer.Character
    local HasWeapon = Character and Character:FindFirstChildOfClass("Tool") ~= nil

    if Settings.TargetLine and HasWeapon and Target and Target:FindFirstChild("HumanoidRootPart") then
        local TargetPos, OnScreen = Camera:WorldToViewportPoint(Target.HumanoidRootPart.Position)
        if OnScreen then
            TracerLine.From = MousePos
            TracerLine.To = Vector2.new(TargetPos.X, TargetPos.Y)
            TracerLine.Visible = true
        else
            TracerLine.Visible = false
        end
    else
        TracerLine.Visible = false
    end
end)

-- ========================================================
-- 4. Mobile Draggable Toggle Button (ปุ่มลอยสำหรับเปิด/ปิด UI)
-- ========================================================

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "MultiGameHub_Toggle"
ToggleGui.Parent = CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleBtn.Text = "HUB"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 150, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = ToggleGui
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local BtnCorner = Instance.new("UICorner", ToggleBtn)
BtnCorner.CornerRadius = UDim.new(1, 0)

local BtnStroke = Instance.new("UIStroke", ToggleBtn)
BtnStroke.Color = Color3.fromRGB(220, 20, 60)
BtnStroke.Thickness = 2

ToggleBtn.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
end)

Rayfield:Notify({
   Title = "MultiGame Hub",
   Content = "โหลดสคริปต์สำเร็จ! ปุ่มเปิด/ปิดลอยอยู่ด้านข้างจอ",
   Duration = 5,
   Image = 4483362458,
})
