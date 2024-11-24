-- > W.I.P AUTOFARM < --
-- > BY SOLAR.VENS < --

local Settings = {
    Speed = 200; -- Less Is Faster
    KillDistance = 15; -- Kill Distance in XZ Axis
    Height = 133
}

-- > SERVICES 

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Replicated = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

-- > LOCAL

local Speaker = Players.LocalPlayer
local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- > GAME 

local Titans = workspace:WaitForChild("Titans", math.huge)
local Assets = Replicated:WaitForChild("Assets")
local Remotes = Assets:WaitForChild("Remotes")

local GET = Remotes:WaitForChild("GET")
local POST = Remotes:WaitForChild("POST")

-- > FUNCTIONS

local function GetNearTitan(NearEren)
    local MaxDist = math.huge; local Closest = nil;
    local NextDistance = nil; if NearEren then NextDistance = Vector3.new(-2061, 0, 823) end
    for _, Titan in next, Titans:GetChildren() do
        local HRP = Titan:FindFirstChild("HumanoidRootPart")
        if HRP and Root then
            local Distance = ((NextDistance or Root.Position) - HRP.Position).Magnitude
            local Dead = Titan:GetAttribute("Dead")
            if Distance < MaxDist and not Dead then
                MaxDist = Distance
                Closest = Titan
            end
        end
    end
    return Closest
end

local function ReloadBlades()
    local Arguments = {
        [1] = "Blades"; [2] = "Full_Reload"; [3] = "Right"
    }

    GET:InvokeServer(unpack(Arguments))

    Arguments[3] = "Left";

    GET:InvokeServer(unpack(Arguments))
end

local function HitTitan(Titan, TrueHitPart)
    local Hitboxes = Titan.Hitboxes.Hit
    local HitPart = Hitboxes.Nape

    local Arguments = {
        [1] = "Attacks"; [2] = "Slash"; [3] = true;
    }

    POST:FireServer(unpack(Arguments))

    Arguments = {
        [1] = "Hitboxes"; [2] = "Register"; [3] = TrueHitPart or HitPart; [4] = math.random(2300,2600)/10; [5] = math.random(100,250)/1000
    }
    print(Arguments[4], Arguments[5])

    GET:InvokeServer(unpack(Arguments))
end

local function GetDistanceXZ(Pos, Pos2)
    local NewPos, NewPos2 = Vector3.new(Pos.X, 0, Pos.Z), Vector3.new(Pos2.X, 0, Pos2.Z)
    return (NewPos - NewPos2).Magnitude
end

local function CheckBlade()
    local Blade = Character:WaitForChild("Rig_"..Character.Name):WaitForChild("RightHand"):WaitForChild("Blade_1")
    if Blade.Transparency == 1 then
        ReloadBlades()
    end
end

local function RefillBlades()
    local Arguments = {
        [1] = "Blades"; [2] = "Full_Reload"; [3] = "Right"; [4] = Delete2:WaitForChild("Reloads"):WaitForChild("GasTanks"):WaitForChild("Refill")
    }

    GET:InvokeServer(unpack(Arguments))

    Arguments[3] = "Left";

    GET:InvokeServer(unpack(Arguments))
end

local function FloatPlayer()
    local Float = Instance.new('Part')
	Float.Name = "4a92ag83fka52W9Ejw4eASf75iAWe2f34F"
	Float.Parent = Character
	Float.Transparency = 1
	Float.Size = Vector3.new(2,0.2,1.5)
	Float.Anchored = true
    coroutine.wrap(function()
        RunService.Heartbeat:Connect(function()
            Float.CFrame = Root.CFrame * CFrame.new(0, -3, 0)
        end)
    end)()
end

local function Retry()
    GET:InvokeServer("Functions", "Retry", "Add")
end

local function CreateForce()
    local Attachment = Instance.new("Attachment", Root)
    Attachment.Name = "RootAttach"

    local BodyPos = Instance.new("LinearVelocity")
    BodyPos.Attachment0 = Attachment
    BodyPos.MaxForce = math.huge
    BodyPos.Parent = Root
    BodyPos.Name = "Movement"

    return BodyPos
end

local function OpenFreeChest()
    local Arguments = {
        [1] = "S_Rewards"; [2] = "Chest"; [3] = "Free";
    }

    GET:InvokeServer(unpack(Arguments))
end

local function FloorVector(Vector)
    return Vector3.new(math.floor(Vector.X), math.floor(Vector.Y), math.floor(Vector.Z))
end

-- > RUNNING

CoreGui:WaitForChild("RobloxPromptGui"):WaitForChild("promptOverlay").ChildAdded:Connect(function()
    while task.wait(1) do
        TeleportService:Teleport(game.PlaceId, Speaker)
    end
end)

local function NormalMission()
    if #Titans:GetChildren() > 0 then else Titans.ChildAdded:Wait() end
    task.wait(1.5)  -- Wait for Mission to Load

    local BodyPos = CreateForce(); -- Creates Linear Vector Force

    local Delete1 = workspace:WaitForChild("Climbable")
    local Delete2 = workspace:WaitForChild("Unclimbable")

    coroutine.wrap(function() -- New Thread to Delete Unnecessary Parts
        for _, Part in next, Delete1:GetDescendants() do if Part:IsA("Part") or Part:IsA("MeshPart") then Part.CanCollide = false end end
        for _, Part in next, Delete2:GetDescendants() do if Part:IsA("Part") or Part:IsA("MeshPart") then Part.CanCollide = false end end

        Delete1.DescendantAdded:Connect(function(Part) if Part:IsA("Part") or Part:IsA("MeshPart") then Part.CanCollide = false end end)
        Delete2.DescendantAdded:Connect(function(Part) if Part:IsA("Part") or Part:IsA("MeshPart") then Part.CanCollide = false end end)
        
        while task.wait(2) do CheckBlade() end
    end)()

    --FloatPlayer(); -- Make Tween Unglitchy

    while task.wait() do
        local Titan = GetNearTitan()
        if Titan then
            local LastTick = tick()
            repeat
                local Dead = Titan:GetAttribute("Dead")
                local TrueDistance = GetDistanceXZ(Root.Position, Titan.Hitboxes.Hit.Nape.Position)
                
                local NextBodyPos = Titan.Hitboxes.Hit.Nape.Position + Vector3.new(0, Settings.Height, 0)
                local Direction = (NextBodyPos - Root.Position).Unit

                if TrueDistance < 12 then
                    BodyPos.VectorVelocity = Vector3.new(0, 0, 0)
                else
                    BodyPos.VectorVelocity = Direction * Settings.Speed
                end

                if TrueDistance < Settings.KillDistance and tick() - LastTick > 0.54 then
                    HitTitan(Titan)
                    LastTick = tick()
                end

            task.wait() until not Titan.Parent or Dead
        else
            print("Mission Done")
            break;
        end
    end

    BodyPos.Enabled = false;

    coroutine.wrap(function()
        while task.wait(0.5) do
            Retry()
        end
    end)()
end

local function RaidMission()
    task.wait(6) -- Wait for Mission to Load

    local BodyPos = CreateForce(); -- Creates Linear Vector Force

    local Delete1 = workspace:WaitForChild("Climbable")
    local Delete2 = workspace:WaitForChild("Unclimbable")

    coroutine.wrap(function() -- New Thread to Delete Unnecessary Parts
        for _, Part in next, Delete1:GetDescendants() do if Part:IsA("Part") or Part:IsA("MeshPart") then Part.CanCollide = false end end
        for _, Part in next, Delete2:GetDescendants() do if Part:IsA("Part") or Part:IsA("MeshPart") then Part.CanCollide = false end end

        Delete1.DescendantAdded:Connect(function(Part) if Part:IsA("Part") or Part:IsA("MeshPart") then Part.CanCollide = false end end)
        Delete2.DescendantAdded:Connect(function(Part) if Part:IsA("Part") or Part:IsA("MeshPart") then Part.CanCollide = false end end)
        
        while task.wait(2) do CheckBlade() end
    end)()

    --FloatPlayer(); -- Make Tween Unglitchy

    local AttackTitan = nil;

    while task.wait() do
        local Titan = GetNearTitan(true)

        AttackTitan = Titans:FindFirstChild("Attack_Titan")
        if AttackTitan then
            print("Attack Titan Protected: Time for BOSS")
            break;
        end

        if Titan then
            local LastTick = tick()
            repeat
                local Dead = Titan:GetAttribute("Dead")
                local TrueDistance = GetDistanceXZ(Root.Position, Titan.Hitboxes.Hit.Nape.Position)
                
                local NextBodyPos = Titan.Hitboxes.Hit.Nape.Position + Vector3.new(0, Settings.Height, 0)
                local Direction = (NextBodyPos - Root.Position).Unit

                if TrueDistance < 12 then
                    BodyPos.VectorVelocity = Vector3.new(0, 0, 0)
                else
                    BodyPos.VectorVelocity = Direction * Settings.Speed
                end

                if TrueDistance < Settings.KillDistance and tick() - LastTick > 0.54 then
                    HitTitan(Titan)
                    LastTick = tick()
                end

            task.wait() until not Titan.Parent or Dead
        end
    end

    -- > ATTACK TITAN (REPEATING LOOP)
    local LastTick = tick()
    repeat
        AttackTitan = Titans:FindFirstChild("Attack_Titan")
        if AttackTitan then
            local TrueDistance = GetDistanceXZ(Root.Position, AttackTitan.Hitboxes.Hit.Nape.Position)
            
            local NextBodyPos = AttackTitan.Hitboxes.Hit.Nape.Position + Vector3.new(0, Settings.Height + 60, 0)
            local Direction = (NextBodyPos - Root.Position).Unit

            if TrueDistance < 12 then
                BodyPos.VectorVelocity = Vector3.new(0, 0, 0)
            else
                BodyPos.VectorVelocity = Direction * Settings.Speed
            end

            if TrueDistance < Settings.KillDistance and tick() - LastTick > 0.54 then
                HitTitan(AttackTitan, AttackTitan.Marker.Adornee)
                LastTick = tick()
            end
        end
    task.wait() until not AttackTitan.Parent

    BodyPos.Enabled = false;
    
    coroutine.wrap(function()
        while task.wait(0.25) do
            OpenFreeChest();
        end
    end)()
     task.wait(1)

    coroutine.wrap(function()
        while task.wait(0.5) do
            Retry()
        end
    end)()
end

queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/StwFate/Release/refs/heads/main/BlahBlahBlah2.lua"))()]])
RaidMission()
