-- Guardar como: aimbot.lua
local Aimbot = {}
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Parámetros de Raycast para el Wallcheck
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

_G.Aimbot_Enabled = true
_G.Wallcheck_Enabled = true -- Por defecto activado (solo apunta si los ve)
_G.Aim_Strength = 0.5 -- 0.1 (suave) a 1 (instantáneo)
_G.FOV_Radius = 150
_G.Is_Aiming = false

function Aimbot.isVisible(targetChar)
    local head = targetChar:FindFirstChild("Head")
    if not head then return false end
    
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = workspace:Raycast(Camera.CFrame.Position, head.Position - Camera.CFrame.Position, rayParams)
    
    if result and result.Instance:IsDescendantOf(targetChar) then
        return true
    end
    return result == nil
end

function Aimbot.GetTarget()
    local target = nil
    local shortestDist = math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChild("Humanoid")

            if head and hum and hum.Health > 0 then
                -- Comprobar Wallcheck si está activo
                if _G.Wallcheck_Enabled and not Aimbot.isVisible(char) then continue end
                
                local sPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mouseDist = (Vector2.new(sPos.X, sPos.Y) - center).Magnitude
                    if mouseDist <= _G.FOV_Radius then
                        local distXYZ = (head.Position - Camera.CFrame.Position).Magnitude
                        if distXYZ < shortestDist then
                            shortestDist = distXYZ
                            target = head
                        end
                    end
                end
            end
        end
    end
    return target
end

return Aimbot
