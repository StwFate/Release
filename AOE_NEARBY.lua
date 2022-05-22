```Lua
local Client = game.Players.LocalPlayer; local Clients = game.Players
local ReplicatedStorage = game:GetService("ReplicatedStorage")

function Hit(Target, Part, Debounce, Debounce2)

	local return_teleport = Client.Character.HumanoidRootPart.CFrame
	local return_value
	local time = tick();
    
	local DebounceArgs = {}

	DebounceArgs[1] = "\240\159\154\168"
	DebounceArgs[2] = time
	DebounceArgs[3] = Client.Character:FindFirstChildOfClass("Tool")
	DebounceArgs[4] = "43TRFWJ"
	DebounceArgs[5] = "Normal"
	DebounceArgs[6] = time - 0
	DebounceArgs[7] = true

	return_value = ReplicatedStorage.Events["XMHH.1"]:InvokeServer(unpack(DebounceArgs))

	wait(Debounce)

		Client.Character.HumanoidRootPart.CFrame = Target["HumanoidRootPart"].CFrame + Vector3.new(0,3,0)

		wait(Debounce2)
        for _,v in next, Clients:GetChildren() do if v ~= Client and v.Character then if v.Character:FindFirstChildOfClass("Humanoid") then
            if (Client.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude < 15 then

		local HitArgs = {}

		HitArgs[1] = "\240\159\154\168"
		HitArgs[2] = time
		HitArgs[3] = Client.Character:FindFirstChildOfClass("Tool")
		HitArgs[4] = "2389ZFX33"
		HitArgs[5] = return_value
		HitArgs[6] = false
		HitArgs[7] = Client.Character["Right Arm"]
		HitArgs[8] = v.Character[Part]
		HitArgs[9] = v.Character
		HitArgs[10] = Client.Character["Right Arm"].Position
		HitArgs[11] = v.Character[Part].Position
		ReplicatedStorage.Events["XMHH2.1"]:FireServer(unpack(HitArgs)) ReplicatedStorage.Events["XMHH2.1"]:FireServer(unpack(HitArgs)) 
		ReplicatedStorage.Events["XMHH2.1"]:FireServer(unpack(HitArgs)) ReplicatedStorage.Events["XMHH2.1"]:FireServer(unpack(HitArgs))
    end
end
end
end

		Client.Character.HumanoidRootPart.CFrame = return_teleport

end

function Get(String)
    local Found
    local strl = String:lower()

        for i,v in next, Clients:GetChildren() do
            if v.Name:lower():sub(1, #String) == String:lower() or v.DisplayName:lower():sub(1, #String) == String:lower() then
                Found = v.Character
            end
		end

    return Found  
end

local configs = {
    Bat = {0.1, 0.15},
    Fists = {0.03, 0.08},
    Axe = {0.5, 0.15},
    Chainsaw = {0, 0.1}
}

function GetDebounce2(Target)
    local hrp = Target.HumanoidRootPart
    local hrp2 = Client.Character.HumanoidRootPart
    local debounce = 0.1
    
    local mag = (hrp.Position - hrp2.Position).magnitude
    
    if mag/5275 < 0.2 then
        debounce = mag/5275 + 0.85 + mag/tick()

    else

        debounce = 0.2 - mag/52750
    end

    return debounce
end

local Target = Get("name")
Hit(Target, "Head", 0.15, GetDebounce2(Target))

-- supports Area Of Effect If Players Are NearBy Does Damage To Them
```
