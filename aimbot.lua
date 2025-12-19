local Aimbot = {}
Aimbot.Enabled = true
Aimbot.WallCheck = true
Aimbot.FOV = 150
Aimbot.Strength = 0.5

local Camera = workspace.CurrentCamera
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

function Aimbot.GetTarget(players, localPlayer)
    if not Aimbot.Enabled then return nil end
    
    local target = nil
    local minScreenDist = math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Team ~= localPlayer.Team then
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            local humanoid = char and char:FindFirstChild("Humanoid")
            
            if head and humanoid and humanoid.Health > 0 then
                local sPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local mouseDist = (Vector2.new(sPos.X, sPos.Y) - center).Magnitude
                    
                    if mouseDist <= Aimbot.FOV then
                        if Aimbot.WallCheck then
                            rayParams.FilterDescendantsInstances = {localPlayer.Character, Camera}
                            local res = workspace:Raycast(Camera.CFrame.Position, head.Position - Camera.CFrame.Position, rayParams)
                            if res and not res.Instance:IsDescendantOf(char) then 
                                continue 
                            end
                        end
                        
                        if mouseDist < minScreenDist then
                            minScreenDist = mouseDist
                            target = head
                        end
                    end
                end
            end
        end
    end
    
    return target
end

function Aimbot.Apply(target)
    if not target or not Aimbot.Enabled then return end
    
    local targetPos = target.Position
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
    
    Camera.CFrame = currentCFrame:Lerp(targetCFrame, Aimbot.Strength)
end

return Aimbot
