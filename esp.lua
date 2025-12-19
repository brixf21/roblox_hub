-- Guardar como: esp.lua
local ESP = {}
ESP.Enabled = true
ESP.ShowAllies = true
ESP.ShowEnemies = true

local highlights = {} -- Caché de objetos activos

function ESP.Update(players, localPlayer)
    if not ESP.Enabled then 
        ESP.Cleanup() -- Si se apaga, limpiamos todo de una vez
        return 
    end

    for _, player in ipairs(players:GetPlayers()) do
        if player == localPlayer then continue end

        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChild("Humanoid")
        
        -- LÓGICA DE LIMPIEZA: Si murió o no hay personaje, eliminamos basura
        if not char or not head or not hum or hum.Health <= 0 then
            if highlights[player.UserId] then
                highlights[player.UserId]:Destroy()
                highlights[player.UserId] = nil -- Eliminamos de la caché
            end
            continue
        end

        -- FILTRO DE EQUIPO: Decidir si mostrar según la configuración
        local isAlly = (player.Team == localPlayer.Team)
        local shouldShow = (isAlly and ESP.ShowAllies) or (not isAlly and ESP.ShowEnemies)

        if shouldShow then
            local hl = highlights[player.UserId]
            if not hl then
                -- CREACIÓN: Solo si no existe ya uno para este jugador
                hl = Instance.new("Highlight")
                hl.Name = "HeadESP_Active"
                hl.Adornee = head
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillTransparency = 0.5 -- Corregido para evitar lag y errores
                hl.Parent = head
                highlights[player.UserId] = hl
            end
            
            -- Actualización de colores en tiempo real
            hl.FillColor = isAlly and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
            hl.OutlineColor = hl.FillColor
            hl.Enabled = true
        else
            -- Si el jugador existe pero el filtro (Aliado/Enemigo) está apagado, limpiamos
            if highlights[player.UserId] then
                highlights[player.UserId]:Destroy()
                highlights[player.UserId] = nil
            end
        end
    end
end

-- Limpieza total al cerrar el script
function ESP.Cleanup()
    for id, hl in pairs(highlights) do
        if hl then hl:Destroy() end
        highlights[id] = nil
    end
end

return ESP
