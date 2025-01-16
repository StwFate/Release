if game:IsLoaded() then else game.Loaded:Wait() end

print("Game has Loaded")

local Players = game.Players
local Player = Players.LocalPlayer

coroutine.wrap(function()
    local MainPlayer = Players:WaitForChild("zyx20392", math.huge)
    local AltPlayer = Players:WaitForChild("4223adqe", math.huge)
    
    local Replicated = game:GetService("ReplicatedStorage")
    local Enable1v1 = true;
    
    local RankedLobby = 15424972165
    local Ranked1v1 = 15486406772
    
    local function isPlayersInside()
        for _, player in next, Players:GetPlayers() do
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                local partSize = Vector3.new(45, 12, 29)
                local partCFrame = CFrame.new(44.8548622, 19.807827, -55.8496513, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                local partMin = partCFrame.Position - (partSize / 2)
                local partMax = partCFrame.Position + (partSize / 2)
                local hrpPos = hrp.Position
    
                if (hrpPos.X >= partMin.X and hrpPos.X <= partMax.X)
                    and (hrpPos.Y >= partMin.Y and hrpPos.Y <= partMax.Y)
                    and (hrpPos.Z >= partMin.Z and hrpPos.Z <= partMax.Z) then
                    return true
                end
            end
        end
        return false
    end
    
    local function Enter1v1()
        coroutine.wrap(function()
            game:GetService("RunService").RenderStepped:Connect(function()
                local part = workspace:WaitForChild("Thrown"):WaitForChild("joinParts"):WaitForChild("1v1")
                if Enable1v1 and not isPlayersInside() then
                    part.Size = Vector3.new(200,200,200)
                else
                    part.Size = Vector3.new(0,0,0)
                end
            end)
        end)()
    end

    if game.PlaceId == RankedLobby then
        Enter1v1()
        print("In Ranked Lobby")
    end
    
    if game.PlaceId == Ranked1v1 and Player == AltPlayer then
        while task.wait(0.5) do
            if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
            end
        end
        print("In Ranked 1v1")
    end
end)()

queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/StwFate/Release/refs/heads/main/AltAndMain2.lua"))()]])
