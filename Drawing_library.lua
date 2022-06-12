if game.IsLoaded(game) == false then game.Loaded.Wait(game.Loaded) end
--#region settings
local settings = {
    line = {
        color = Color3.new(1,0,0),
        thickness = 1.5
    },
    text = {
        color = Color3.new(1,0,0),
        center = true,
        outline = true,
        outlinecolor = Color3.new(0,0,0),
        size = 1
    }
}

--#endregion

--#region variables
local clients = game:GetService("Players")
local client = clients.LocalPlayer
local mouse = client:GetMouse()

local camera = workspace.CurrentCamera
local cframe = CFrame.new;local insert = table.insert

local userinputservice = game:GetService("UserInputService")
local replicated = game:GetService("ReplicatedStorage")
local runservice = game:GetService("RunService")

--#region globals

local space = workspace
local pairs = pairs
local next = next
local pcall = pcall
local tostring = tostring
local tick = tick
local GV = getgenv() 
local mousemoverel = mousemoverel
local mouse1press = mouse1press
local mouse1release = mouse1release
--#endregion

--#region stuff
local drawing = Drawing.new
local v3new = Vector3.new
local v2new = Vector2.new
local cframe = CFrame.new
local wtvp = camera.WorldToViewportPoint

--#endregion

-- > DRAWING LIBRARY < --

local boxes = {}
local lines = {
    a = {},
    b = {},
    c = {},
    d = {},
    e = {},
    f = {},
    g = {},
    h = {},
}
local texts = {
    distance = {},
    health = {},
    tool = {},
}
--#endregion

--#region tables
local component = {}
local player_index = {}

--#endregion

--#region functions
function getSides(part,add, sub, character)
    local newCFrame = add or 0; local second = sub or 0
    local size = part.Size * v3new(1 + newCFrame, 1.5, 1)

    local cf = part.CFrame
    if character == client.Character then
        print(((cf * cframe(size.X, size.Y, 0)).Position - v3new(0,0.25,0)).Y)
    end
    return {
        top_right = (cf * cframe(-size.X, -size.Y, 0)).Position,
        bottom_right = (cf * cframe(-size.X, size.Y, 0)).Position- v3new(0,0.25,0),
        top_left = (cf * cframe(size.X, -size.Y, 0)).Position,
        bottom_left = (cf * cframe(size.X, size.Y, 0)).Position- v3new(0,0.25 + second,0),
    }
end



function getDistance(w, e)
    --[[
        w = part1; e = part2
        round = no decimals; normal = decimals
    ]]--

    return {
        round = math.floor((w.Position - e.Position).magnitude),
        normal = (w.Position - e.Position).magnitude
    }
end

function getChar(name, method)
    local char = nil
    if method == "Workspace" then
        for _,v in next, workspace:GetDescendants() do
            if v.Name == name then
                char = v
            end
        end
    elseif method == "Player" then
        if clients:FindFirstChild(name) then
            char = clients[name].Character or nil
        end
    end
    return char
end

function checkChar(character, health, special, extra)
    local hp = health or 0; local rt = false; local c = nil
    local h1 = nil; local h2 = nil; local part = extra or "HumanoidRootPart"
    if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild(part) then
        if character:FindFirstChildOfClass("Humanoid") or special then
            if character.Humanoid.Health > hp or hp == 0 then
                rt = true
                c = character
                h1 = character.HumanoidRootPart
                h2 = character.Humanoid
            end
        end
    end
    return rt
end

function component.draw(drawing, array)
    local item = Drawing.new(drawing)

    for _,v in next, array do
        item[_] = v
    end
    -- simple table array
    return item
end

function player_index.text(boolean, type)
    if boolean and not (GV.runservice_text) then
        print("run")
        GV.runservice_text = runservice.RenderStepped:Connect(function()
            for _,v in next, texts do
                if _ and v then
                    if checkChar(getChar(_, type), 0, false, "Head") then
                        local character = getChar(_, type)

                        local vector, onscreen = wtvp(camera, character.Head.Position + Vector3.new(0,((camera.CFrame).Position - character.HumanoidRootPart.Position).magnitude/100 + 2,0))

                        if onscreen then
                            v.Text = character.Name
                            v.Position = v2new(vector.X, vector.Y)
                            v.Visible = true
                        else
                            v.Visible = false
                        end
                    else
                        v.Visible = false
                    end
                end
            end
        end)
    elseif not boolean and (GV.runservice_text) then
        GV.runservice_text:Disconnect()
        GV.runservice_text = false
        for _,v in next, texts do
            v.Visible = false
        end
    end
end

function arithmetic(number, drawing)
    if number == 5.75 and drawing then
        drawing.Visible = false
    end
    return number
end

function player_index.esp(boolean, type)
    if boolean and not (GV.runservice_line) then
        print("run")
        GV.runservice_line = runservice.RenderStepped:Connect(function()
            for _,v in next, lines.a do
                if _ and v then
                    if checkChar(getChar(_, type), 0, false, "Head") then
                        local character = getChar(_, type)
                        local hrp = character.HumanoidRootPart
                        local vector, onscreen = wtvp(camera, character.HumanoidRootPart.Position)
                        local left, right = character["Left Arm"], character["Right Arm"]
                        local left2, right2 = character["Left Leg"], character["Right Leg"]

                        local a = getSides(character.HumanoidRootPart)

                        local v1, o1 = wtvp(camera, a.bottom_right)
                        local v2, o2 = wtvp(camera, a.bottom_left)
                        local v3, o3 = wtvp(camera, a.top_right)
                        local v4, o4 = wtvp(camera, a.top_left)
                        if onscreen then
                            v.To = v2new(v1.X, v1.Y) -- top
                            v.From = v2new(v2.X, v2.Y)
                            v.Visible = true
                        else
                            v.Visible = false
                        end
                    else
                        v.Visible = false
                    end
                end
            end
            for _,v in next, lines.b do
                if _ and v then
                    if checkChar(getChar(_, type), 0, false, "Head") then
                        local character = getChar(_, type)
                        local hrp = character.HumanoidRootPart
                        local vector, onscreen = wtvp(camera, character.HumanoidRootPart.Position)
                        local left, right = character["Left Arm"], character["Right Arm"]
                        local left2, right2 = character["Left Leg"], character["Right Leg"]

                        local a = getSides(character.HumanoidRootPart)

                        local v1, o1 = wtvp(camera, a.bottom_right)
                        local v2, o2 = wtvp(camera, a.bottom_left)
                        local v3, o3 = wtvp(camera, a.top_right)
                        local v4, o4 = wtvp(camera, a.top_left)
                        if onscreen then
                            v.To = v2new(v3.X, v3.Y) -- bottom
                            v.From = v2new(v4.X, v4.Y)
                            v.Visible = true
                        else
                            v.Visible = false
                        end
                    else
                        v.Visible = false
                    end
                end
            end
            for _,v in next, lines.c do
                if _ and v then
                    if checkChar(getChar(_, type), 0, false, "Head") then
                        local character = getChar(_, type)
                        local hrp = character.HumanoidRootPart
                        local vector, onscreen = wtvp(camera, character.HumanoidRootPart.Position)
                        local left, right = character["Left Arm"], character["Right Arm"]
                        local left2, right2 = character["Left Leg"], character["Right Leg"]

                        local a = getSides(character.HumanoidRootPart)

                        local v1, o1 = wtvp(camera, a.bottom_right) -- left
                        local v2, o2 = wtvp(camera, a.bottom_left)
                        local v3, o3 = wtvp(camera, a.top_right)
                        local v4, o4 = wtvp(camera, a.top_left)
                        if onscreen then
                            v.To = v2new(v4.X, v4.Y)
                            v.From = v2new(v2.X, v2.Y)
                            v.Visible = true
                        else
                            v.Visible = false
                        end
                    else
                        v.Visible = false
                    end
                end
            end
            for _,v in next, lines.d do
                if _ and v then
                    if checkChar(getChar(_, type), 0, false, "Head") then
                        local character = getChar(_, type)
                        local hrp = character.HumanoidRootPart
                        local vector, onscreen = wtvp(camera, character.HumanoidRootPart.Position)
                        local left, right = character["Left Arm"], character["Right Arm"]
                        local left2, right2 = character["Left Leg"], character["Right Leg"]

                        local a = getSides(character.HumanoidRootPart)

                        local v1, o1 = wtvp(camera, a.bottom_right) -- right
                        local v2, o2 = wtvp(camera, a.bottom_left)
                        local v3, o3 = wtvp(camera, a.top_right)
                        local v4, o4 = wtvp(camera, a.top_left)
                        if onscreen then
                            v.To = v2new(v3.X, v3.Y)
                            v.From = v2new(v1.X, v1.Y)
                            v.Visible = true
                        else
                            v.Visible = false
                        end
                    else
                        v.Visible = false
                    end
                end
            end
            for _,v in next, lines.e do
                if _ and v then
                    if checkChar(getChar(_, type), 0, false, "Head") and getChar(_, type):FindFirstChildOfClass("Humanoid") then
                        local character = getChar(_, type)
                        local hrp = character.HumanoidRootPart; local hum = character:FindFirstChildOfClass("Humanoid") or nil
                        local vector, onscreen = wtvp(camera, character.HumanoidRootPart.Position)
                        local left, right = character["Left Arm"], character["Right Arm"]
                        local left2, right2 = character["Left Leg"], character["Right Leg"]

                        local a = getSides(character.HumanoidRootPart, 0.2, arithmetic(((math.clamp(hum.Health, 0, hum.MaxHealth)/-hum.MaxHealth) + 1) * 5.75))

                        local v1, o1 = wtvp(camera, a.top_left)
                        local v2, o2 = wtvp(camera, a.bottom_left)
                        if onscreen and hum then
                            v.To = v2new(v2.X, v2.Y) -- healthbar
                            v.From = v2new(v1.X, (v1.Y))
                            v.Visible = true
                            v.Color = Color3.fromRGB(255 - 255 / (hum.MaxHealth / hum.Health), 255 / (hum.MaxHealth / hum.Health), 0)
                            arithmetic(((math.clamp(hum.Health, 0, hum.MaxHealth)/-hum.MaxHealth) + 1) * 5.75, v)
                        else
                            v.Visible = false
                        end
                    else
                        v.Visible = false
                    end
                end
            end
            for _,v in next, lines.f do
                if _ and v then
                    if checkChar(getChar(_, type), 0, false, "Head") then
                        local character = getChar(_, type)
                        local hrp = character.HumanoidRootPart; local hum = character:FindFirstChildOfClass("Humanoid") or nil
                        local vector, onscreen = wtvp(camera, character.HumanoidRootPart.Position)
                        local left, right = character["Left Arm"], character["Right Arm"]
                        local left2, right2 = character["Left Leg"], character["Right Leg"]

                        local a = getSides(character.HumanoidRootPart, 0.2)

                        local v1, o1 = wtvp(camera, a.bottom_left)
                        local v2, o2 = wtvp(camera, a.top_left)
                        if onscreen and hum then
                            v.To = v2new(v1.X, v1.Y) -- healthbar
                            v.From = v2new(v2.X, v2.Y)
                            v.Visible = true
                        else
                            v.Visible = false
                        end
                    else
                        v.Visible = false
                    end
                end
            end
        end)
    elseif not boolean and (GV.runservice_line) then
        GV.runservice_line:Disconnect()
        GV.runservice_line = false
        for _,v in next, lines do
            for _,v in next, v do
                v.Visible = false
            end
        end
    end
end

--#endregion

for _,v in next, clients:GetChildren() do
    if v~=client then
        texts[v.Name] = component.draw(
            "Text",
            {
                Center = settings.text.center,
                Outline = settings.text.outline,
                OutlineColor = settings.text.outlinecolor,
                Color = settings.text.color,
                Size = settings.text.size,
                Visible = false,
                ZIndex = 10
            })
        lines.a[v.Name] = component.draw(
            "Line",
            {
                Thickness = settings.line.thickness,
                Visible = false,
                Color = settings.line.color,
                ZIndex = 10
            })
        lines.b[v.Name] = component.draw(
            "Line",
            {
                Thickness = settings.line.thickness,
                Visible = false,
                Color = settings.line.color,
                ZIndex = 10
            })
        lines.c[v.Name] = component.draw(
            "Line",
            {
                Thickness = settings.line.thickness,
                Visible = false,
                Color = settings.line.color,
                ZIndex = 10
            })
        lines.d[v.Name] = component.draw(
            "Line",
            {
                Thickness = settings.line.thickness,
                Visible = false,
                Color = settings.line.color,
                ZIndex = 10
            })
        lines.e[v.Name] = component.draw(
            "Line",
            {
                Thickness = 2,
                Visible = false,
                ZIndex = 2
            })
        lines.f[v.Name] = component.draw(
            "Line",
            {
                Thickness = 3,
                Visible = false,
                Color = Color3.new(0.2,0.2,0.2),
                ZIndex = 1
            })
    end
end

local add_clients = clients.ChildAdded:Connect(function(retard)
    if retard and retard ~= client then
        if v~=client then
            texts[v.Name] = component.draw(
                "Text",
                {
                    Center = settings.text.center,
                    Outline = settings.text.outline,
                    OutlineColor = settings.text.outlinecolor,
                    Color = settings.text.color,
                    Size = settings.text.size,
                    Visible = false,
                    ZIndex = 10
                })
            lines.a[v.Name] = component.draw(
                "Line",
                {
                    Thickness = settings.line.thickness,
                    Visible = false,
                    Color = settings.line.color,
                    ZIndex = 10
                })
            lines.b[v.Name] = component.draw(
                "Line",
                {
                    Thickness = settings.line.thickness,
                    Visible = false,
                    Color = settings.line.color,
                    ZIndex = 10
                })
            lines.c[v.Name] = component.draw(
                "Line",
                {
                    Thickness = settings.line.thickness,
                    Visible = false,
                    Color = settings.line.color,
                    ZIndex = 10
                })
            lines.d[v.Name] = component.draw(
                "Line",
                {
                    Thickness = settings.line.thickness,
                    Visible = false,
                    Color = settings.line.color,
                    ZIndex = 10
                })
            lines.e[v.Name] = component.draw(
                "Line",
                {
                    Thickness = 2,
                    Visible = false,
                    ZIndex = 2
                })
            lines.f[v.Name] = component.draw(
                "Line",
                {
                    Thickness = 3,
                    Visible = false,
                    Color = Color3.new(0.2,0.2,0.2),
                    ZIndex = 1
                })
        end
    end
end)

player_index.esp(true, "Player")
wait(25)
player_index.esp(false, "Player")
add_clients:Disconnect()
