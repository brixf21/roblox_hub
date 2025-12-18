local Aimbot = {}
Aimbot.Enabled = true -- Función de activación maestra
Aimbot.WallCheck = true
Aimbot.FOV = 150
Aimbot.Strength = 0.5

local Camera = workspace.CurrentCamera
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

function Aimbot.GetTarget(players, localPlayer)
    if not Aimbot.Enabled then return nil end -- Si está desactivado, no busca objetivos
    
    local target = nil
    local minXYZ = math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Team ~= localPlayer.Team then
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            if head and char.Humanoid.Health > 0 then
                local sPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mouseDist = (Vector2.new(sPos.X, sPos.Y) - center).Magnitude
                    if mouseDist <= Aimbot.FOV then
                        if Aimbot.WallCheck then
                            rayParams.FilterDescendantsInstances = {localPlayer.Character, Camera}
                            local res = workspace:Raycast(Camera.CFrame.Position, head.Position - Camera.CFrame.Position, rayParams)
                            if res and not res.Instance:IsDescendantOf(char) then continue end
                        end
                        local distXYZ = (head.Position - Camera.CFrame.Position).Magnitude
                        if distXYZ < minXYZ then
                            minXYZ = distXYZ
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
