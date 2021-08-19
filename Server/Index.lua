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

Package.Require("Config.lua")
ConfigLoad()

--RETRY the old way with prop shooting laser
--ADD quake sound effects like tf2 for the game to be more alive

Server.SetValue("QUAKE_GameState", 0)

Package.RequirePackage("NanosWorldWeapons")

Package.Require("Events.lua")
Package.Require("PlayerCustom.lua")
Package.Require("Timer.lua")

Package.Subscribe("Unload", function()
    local character_locations = {}

    -- When Package unloads, stores the characters locations to respawn them at the same position if the package is being reloaded
    for k, p in pairs(Player.GetAll()) do
        local cha = p:GetControlledCharacter()
        if (cha) then
            table.insert(character_locations, { player = p, location = cha:GetLocation(), rotation = cha:GetRotation() })
        end
    end

    Server.SetValue("QUAKE_character_locations", character_locations)
end)

Package.Subscribe("Load", function()
    local character_locations = Server.GetValue("QUAKE_character_locations") or {}

    if (#character_locations ~= 0) then
        for k, p in pairs(character_locations) do
            SpawnPlayer(p.player, p.location, p.rotation)
        end
    end
end)

function CreateWeapon(chara)
    local new_weapon = NanosWorldWeapons.DesertEagle(chara:GetLocation(), Rotator())
    --new_weapon:SetHandlingMode(HandlingMode.Torch)
    new_weapon:SetDamage(0)
    new_weapon:SetSpread(0)
    new_weapon:SetAmmoSettings(1, 0)
    new_weapon:SetBulletSettings(1, 20000, 20000, Color(1, 0, 0))
    new_weapon:SetCadence(QUAKE_CONFIG.ShootsPerSeconds)
    new_weapon:SetSoundFire("laser-quake-assets::laser_shoot")
    new_weapon:Subscribe("Fire", function(self, shooter)
        self:SetAmmoClip(1)
        CreateBeamWeapon(self)
        Events.CallRemote("QUAKE_Client_LaserTrace", shooter:GetPlayer(), self)
    end)
    new_weapon:Subscribe("Drop", function(pickable, character, was_triggered_by_player)
        if pickable ~= nil then
            pickable:Destroy()
        end
    end)
    new_weapon:SetCrosshairSetting(CrosshairType.Circle)
    chara:PickUp(new_weapon)
end

function SpawnPlayer(player)
    local PlayerCharacters_local = SpawnPlayerCustomisation(player)
    CreateWeapon(PlayerCharacters_local)
    PlayerCharacters_local:SetPunchDamage(100)
    PlayerCharacters_local:SetCanPunch(false)
    PlayerCharacters_local:SetAccelerationSettings(3000, 512, 768, 256, 256, 256, 2048)
    PlayerCharacters_local:SetCanGrabProps(false)
    PlayerCharacters_local:SetCanPickupPickables(false)
    PlayerCharacters_local:SetFallDamageTaken(0)
    PlayerCharacters_local:SetBrakingSettings(3000, 3000, 3000, 3000, 10, 0)
    PlayerCharacters_local:SetCameraMode(1)
    PlayerCharacters_local:SetSpeedMultiplier(QUAKE_CONFIG.GlobalSpeedMultiplier)
    PlayerCharacters_local:Subscribe("FallingModeChanged", function(self, old_state, new_state)
        if new_state == FallingMode.Jumping and old_state == FallingMode.None then
            local control_rotation = self:GetControlRotation()
            local forward_vector = control_rotation:GetForwardVector()
            self:AddImpulse(forward_vector * Vector(30000))
        end
    end)
    --Kill cam
    --PlayerCharacters_local:Subscribe("Death", function(character, last_damage_taken, last_bone_damaged, damage_type_reason, hit_from_direction, instigator)
    --    local PlayerControlled = character:GetPlayer()
    --    if instigator ~= nil then
    --        local InstiChara = instigator:GetControlledCharacter()
    --        if InstiChara ~= nil then
    --            character:AddImpulse(InstiChara:GetControlRotation():GetForwardVector() * Vector(30000))
    --        end
    --        local getInstiPoints = instigator:GetValue("QUAKE_Points")
    --        if getInstiPoints == nil then
    --            getInstiPoints = 0
    --        end
    --        instigator:SetValue("QUAKE_Points", getInstiPoints + 1, true)
    --        Events.CallRemote("QUAKE_Client_HUD_Points", instigator, getInstiPoints + 1)
    --    end
    --    if PlayerControlled ~= nil and instigator ~= nil then
    --        Events.CallRemote("QUAKE_Client_HUD_Killed", PlayerControlled, instigator)
    --    end
    --    if PlayerControlled ~= nil then
    --        PlayerControlled:UnPossess()
    --        local ghostSpectator = false
    --        --local ghostSpectator = Character(character:GetLocation(), Rotator(), "nanos-world::SK_None", CollisionType.NoCollision, false)
    --        --ghostSpectator:SetMovementEnabled(false)
    --        local targetCameraIntigator = Timer.SetInterval(function(instigy, ghost, playerBase)
    --            -- Dead player looking at the player who killed him for 3sec
    --            -- When player dead, spawn a ghost character without gravity and colision that look the player who killed him
    --            -- then take the ghost camera rotation and location to apply to the killed player
    --            -- effect: like tf2 kill system that track killer when you are dead
    --            --if instigy:IsValid() and ghost:IsValid() then
    --            --    local instigatorChara = instigy:GetControlledCharacter()
    --                --if instigatorChara ~= nil then
    --                --    ghost:LookAt(instigatorChara:GetLocation())
    --                --end
    --                --if playerBase:IsValid() then
    --                --    playerBase:SetCameraRotation(ghost:GetControlRotation())
    --                --    playerBase:SetCameraLocation(ghost:GetLocation())
    --                --end
    --            --end
    --        end, 500, instigator, ghostSpectator, PlayerControlled)
    --        Timer.SetTimeout(function(ghost, chara, timery, playerKilled)
    --            Timer.ClearInterval(timery)
    --            --ghost:Destroy()
    --            playerKilled:Possess(chara)
    --            Events.CallRemote("QUAKE_Client_HUD_Killed", playerKilled, nil)
    --            if chara ~= nil then
    --                chara:Respawn()
    --            end
    --            return false
    --        end, QUAKE_CONFIG.RespawnTimeSeconds * 1000, ghostSpectator, character, targetCameraIntigator, PlayerControlled)
    --    end
    --end)
    player:Possess(PlayerCharacters_local)
end