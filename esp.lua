local ESP = {}
ESP.Enabled = true
local highlights = {}

function ESP.Update(players, localPlayer)
    for _, player in ipairs(players:GetPlayers()) do
        local hl = highlights[player.UserId]
        local char = player.Character
        if char and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") then
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "HeadESP"
                hl.Adornee = char.Head
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillTransparency = 0.5 -- Uso obligatorio de FillTransparency
                hl.Parent = char.Head
                highlights[player.UserId] = hl
            end
            hl.Enabled = ESP.Enabled and char.Humanoid.Health > 0
            hl.FillColor = (player.Team == localPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
            hl.OutlineColor = hl.FillColor
        end
    end
end

function ESP.Cleanup()
    for _, hl in pairs(highlights) do if hl then hl:Destroy() end end
    table.clear(highlights)
end

return ESP
