local Aimbot = {}
Aimbot.Enabled = true -- Función de activación maestra
Aimbot.WallCheck = true
Aimbot.FOV = 150
Aimbot.Strength = 0.5

local Camera = workspace.CurrentCamera
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

function Aimbot.GetTarget(players, localPlayer)
    if not Aimbot.Enabled then return nil end 
    
    local target = nil
    -- CAMBIO: Ahora iniciamos con el valor máximo del FOV para encontrar al más cercano al centro
    local minMouseDist = Aimbot.FOV 
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Team ~= localPlayer.Team then
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChild("Humanoid")

            -- Validar que el jugador esté vivo y tenga cabeza
            if head and hum and hum.Health > 0 then
                local sPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    -- Calcular distancia en PÍXELES desde el centro de la pantalla
                    local mouseDist = (Vector2.new(sPos.X, sPos.Y) - center).Magnitude
                    
                    -- CAMBIO: Priorizar al que esté más cerca del centro (menor mouseDist)
                    if mouseDist <= minMouseDist then
                        
                        -- Lógica de WallCheck (respetando tu estructura original)
                        if Aimbot.WallCheck then
                            rayParams.FilterDescendantsInstances = {localPlayer.Character, Camera}
                            local res = workspace:Raycast(Camera.CFrame.Position, head.Position - Camera.CFrame.Position, rayParams)
                            
                            -- Si el rayo golpea algo que no es parte del personaje enemigo, lo ignoramos
                            if res and not res.Instance:IsDescendantOf(char) then 
                                continue 
                            end
                        end

                        -- Actualizar el objetivo al que esté más cerca del centro de la pantalla
                        minMouseDist = mouseDist
                        target = head
                    end
                end
            end
        end
    end
    return target
end

return Aimbot
