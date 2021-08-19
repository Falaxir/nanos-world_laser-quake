-- __          ___           _______. _______ .______           ______      __    __       ___       __  ___  _______
--|  |        /   \         /       ||   ____||   _  \         /  __  \    |  |  |  |     /   \     |  |/  / |   ____|
--|  |       /  ^  \       |   (----`|  |__   |  |_)  |       |  |  |  |   |  |  |  |    /  ^  \    |  '  /  |  |__
--|  |      /  /_\  \       \   \    |   __|  |      /        |  |  |  |   |  |  |  |   /  /_\  \   |    <   |   __|
--|  `----./  _____  \  .----)   |   |  |____ |  |\  \----.   |  `--'  '--.|  `--'  |  /  _____  \  |  .  \  |  |____
--|_______/__/     \__\ |_______/    |_______|| _| `._____|    \_____\_____\\______/  /__/     \__\ |__|\__\ |_______|
--
--.______   ____    ____     _______    ___       __          ___      ___   ___  __  .______
--|   _  \  \   \  /   /    |   ____|  /   \     |  |        /   \     \  \ /  / |  | |   _  \
--|  |_)  |  \   \/   /     |  |__    /  ^  \    |  |       /  ^  \     \  V  /  |  | |  |_)  |
--|   _  <    \_    _/      |   __|  /  /_\  \   |  |      /  /_\  \     >   <   |  | |      /
--|  |_)  |     |  |        |  |    /  _____  \  |  `----./  _____  \   /  .  \  |  | |  |\  \----.
--|______/      |__|        |__|   /__/     \__\ |_______/__/     \__\ /__/ \__\ |__| | _| `._____|

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
    end, QUAKE_CONFIG.InvincibilityTimeSeconds * 1000, self)
end)

Character.Subscribe("Death", function(self, last_damage_taken, last_bone_damage, damage_type_reason, hit_from_direction, instigator)
    local PlayerControlled = self:GetPlayer()
    if PlayerControlled ~= nil then
        PlayerControlled:UnPossess()
        Timer.SetTimeout(function(chara, plyr)
            plyr:Possess(chara)
            Events.CallRemote("QUAKE_Client_HUD_Killed", plyr, nil)
            if chara ~= nil then
                chara:Respawn()
            end
            return false
        end, QUAKE_CONFIG.RespawnTimeSeconds * 1000, self, PlayerControlled)
    end
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

function CreateBeamWeapon(weapon)
    local beam_particle = Particle(Vector(), Rotator(), "nanos-world::P_Beam", false, true)
    beam_particle:AttachTo(weapon, AttachmentRule.SnapToTarget, "muzzle")
    beam_particle:SetParameterColor("BeamColor", Color(0, 0, 2, 1))
    beam_particle:SetParameterFloat("BeamWidth", 6)
    beam_particle:SetParameterFloat("JitterAmount", 0)
    weapon:SetValue("ParticleLaser", beam_particle)
    Timer.SetTimeout(function(weAreInTheBeam)
        weAreInTheBeam:Detach()
        return false
    end, 50, beam_particle)
    Timer.SetTimeout(function(weAreInTheBeam)
        weAreInTheBeam:Destroy()
        return false
    end, QUAKE_CONFIG.LaserDurationSeconds * 1000, beam_particle)
end

Events.Subscribe("QUAKE_KillBroadcast", function(plyr, PlayerControlled, instigator)
    Server.BroadcastChatMessage("<cyan>" .. instigator:GetName() .. "</> killed <cyan>" .. PlayerControlled:GetName() .. "</>")
end)

Events.Subscribe("QUAKE_Laser_Shoot", function(plyr, result, plrKilled, weapon)
    if plyr == nil or result == nil then return end
    local beam_particle = weapon:GetValue("ParticleLaser")
    if beam_particle:IsValid() then
        if (NanosUtils.IsA(result, Vector)) then
            beam_particle:SetParameterVector("BeamEnd", result)
        elseif plrKilled ~= nil then
            beam_particle:SetParameterVector("BeamEnd", result:GetLocation())
            result:ApplyDamage(1000)
            local getInstiPoints = plyr:GetValue("QUAKE_Points")
            if getInstiPoints == nil then
                getInstiPoints = 0
            end
            plyr:SetValue("QUAKE_Points", getInstiPoints + 1, true)
            Events.CallRemote("QUAKE_Client_HUD_Points", plyr, getInstiPoints + 1)
            Events.CallRemote("QUAKE_Client_HUD_Killed", plrKilled, plyr)
        end
    end
end)

Events.Subscribe("QUAKE_START_Game", function()
    Server.SetValue("QUAKE_GameState", 1)
    Events.BroadcastRemote("QUAKE_Client_PlayEffect", "laser-quake-assets::play")
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
    Events.CallRemote("QUAKE_Client_GETConfig", player, QUAKE_CONFIG)
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