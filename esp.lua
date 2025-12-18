-- Guardar como: esp.lua
local ESP = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local highlights = {}

_G.ESP_Enabled = true

function ESP.Create(player)
    if player == LocalPlayer then return end
    local function setup(char)
        local head = char:WaitForChild("Head", 15)
        if not head then return end
        
        local hl = Instance.new("Highlight")
        hl.Name = "HeadESP"
        hl.Adornee = head
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 0.5 -- Evita el error de FillOpacity
        hl.Parent = head
        highlights[player.UserId] = hl
    end
    player.CharacterAdded:Connect(setup)
    if player.Character then setup(player.Character) end
end

function ESP.Update()
    for _, player in ipairs(Players:GetPlayers()) do
        local hl = highlights[player.UserId]
        if hl and player.Character and player.Character:FindFirstChild("Humanoid") then
            hl.Enabled = _G.ESP_Enabled and player.Character.Humanoid.Health > 0
            hl.FillColor = (player.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
            hl.OutlineColor = hl.FillColor
        end
    end
end

function ESP.Cleanup()
    for _, hl in pairs(highlights) do if hl then hl:Destroy() end end
    table.clear(highlights)
end

return ESP
