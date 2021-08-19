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

MainHUD = WebUI("MainHUD", "file:///hud/hud.html")

Package.Require("Tools.lua")
Package.Require("Events.lua")
Package.Require("Communication.lua")
Package.Require("PlaySound.lua")

Events.Subscribe("QUAKE_Client_LaserTrace", function(weapon)
    LaserTrace(weapon)
end)

QUAKE_KS = 0

function LaserTrace(weapon)
    local plyrChara = Client.GetLocalPlayer():GetControlledCharacter()
    if plyrChara == nil then return end

    local result = GetCharacterLookingAt()

    if result ~= nil then
        Sound(plyrChara:GetLocation(), "laser-quake-assets::laser_shoot", false, true, SoundType.SFX, 0.8)
        if NanosUtils.IsA(result, Vector) then
            Events.CallRemote("QUAKE_Laser_Shoot", result, nil, weapon)
        else
            QUAKE_KS = QUAKE_KS + 1
            PlayQuakeSounds()
            Events.CallRemote("QUAKE_Laser_Shoot", result, result:GetPlayer(), weapon)
        end
    end
end