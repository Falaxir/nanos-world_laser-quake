Character.Subscribe("Respawn", function(self)
    CreateWeapon(self)
    self:SetInvulnerable(true)
    self:SetDefaultMaterial(MaterialType.Masked)
    self:SetMaterialColorParameter("Tint", Color(0, 0, 1))
    Timer.SetTimeout(function(chara)
        if chara:IsValid() then
            chara:SetDefaultMaterial(MaterialType.None)
            chara:SetInvulnerable(false)
        end
        return false
    end, QUAKE_CONFIG.InvincibilityTimeSeconds, self)
end)

function CreateScoreboard()
    local ResultData = {}
    for i, player in pairs(Player.GetAll()) do
        table.insert(
                ResultData,
                i,
                {
                    ["Name"] = player:GetName(),
                    ["Points"] = player:GetValue("QUAKE_Points")
                }
        )
    end
    local ResultString = JSON.stringify(ResultData)
    Events.BroadcastRemote("QUAKE_Client_HUD_Scoreboard", ResultString)
end

Events.Subscribe("QUAKE_END_Game", function()
    Server.SetValue("QUAKE_GameState", 2)
    CreateScoreboard()
    Events.BroadcastRemote("QUAKE_Client_HUD_Advert_important", "END GAME", nil)
    Events.BroadcastRemote("QUAKE_Client_HUD_Advert_top_one", "Results", nil)
    Server.SetValue("QUAKE_TimeLimit", QUAKE_CONFIG.RoundScoreboardEndTimeSeconds)
end)

Events.Subscribe("QUAKE_START_Game", function()
    Server.SetValue("QUAKE_GameState", 1)
    Events.BroadcastRemote("QUAKE_Client_HUD_Scoreboard", nil)
    for key,value in pairs(Player.GetAll())
    do
        local chara = value:GetControlledCharacter()
        if chara ~= nil then
            chara:Respawn()
        end
        Events.CallRemote("QUAKE_Client_HUD_Points", value, 0)
        value:SetValue("QUAKE_Points", 0, true)
    end
    Events.BroadcastRemote("QUAKE_Client_HUD_Advert_important", "ROUND BEGINS", 5)
    Events.BroadcastRemote("QUAKE_Client_HUD_Advert_top_one", "Score the most points!", 5)
    Server.SetValue("QUAKE_TimeLimit", QUAKE_CONFIG.RoundTimeLimitSeconds)
end)

Events.Subscribe("QUAKE_WAITING_Game", function()
    Server.SetValue("QUAKE_GameState", 0)
    Server.SetValue("QUAKE_TimeLimit", 2)
end)

Player.Subscribe("Spawn", function(player)
    Server.BroadcastChatMessage("<cyan>" .. player:GetName() .. "</> has joined the server")
    SpawnPlayer(player)
end)

Player.Subscribe("Destroy", function(player)
    -- Destroy it's Character
    local character = player:GetControlledCharacter()
    if (character) then
        character:Destroy()
    end

    Server.BroadcastChatMessage("<cyan>" .. player:GetName() .. "</> has left the server")
end)