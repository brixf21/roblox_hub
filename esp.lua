-- Guardar como: esp.lua
local ESP = {}
ESP.Enabled = true
ESP.ShowAllies = true   -- Control independiente de aliados
ESP.ShowEnemies = true  -- Control independiente de enemigos

local highlights = {}

function ESP.Update(players, localPlayer)
    if not ESP.Enabled then 
        for _, hl in pairs(highlights) do hl.Enabled = false end
        return 
    end

    for _, player in ipairs(players:GetPlayers()) do
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if head and hum and hum.Health > 0 then
            local hl = highlights[player.UserId]
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "HeadESP"
                hl.Adornee = head
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillTransparency = 0.5 -- Evita error de FillOpacity
                hl.Parent = head
                highlights[player.UserId] = hl
            end

            -- Lógica de filtrado modular por equipo
            local isAlly = (player.Team == localPlayer.Team)
            if isAlly then
                hl.Enabled = ESP.ShowAllies
                hl.FillColor = Color3.new(0, 1, 0) -- Verde para aliados
            else
                hl.Enabled = ESP.ShowEnemies
                hl.FillColor = Color3.new(1, 0, 0) -- Rojo para enemigos
            end
            hl.OutlineColor = hl.FillColor
        elseif highlights[player.UserId] then
            highlights[player.UserId].Enabled = false
        end
    end
end

function ESP.Cleanup()
    for _, hl in pairs(highlights) do if hl then hl:Destroy() end end
    table.clear(highlights)
end

return ESP
