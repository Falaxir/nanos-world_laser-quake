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

QUAKE_CONFIG = nil

Package.Subscribe("Load", function()
    Client.SetDiscordActivity("Playing on Nanos World", "Laser Quake Gamemode", "screenshot_173", "by Falaxir")
end)

Events.Subscribe("QUAKE_Client_GETConfig", function(cfg)
    QUAKE_CONFIG = cfg
end)

QUAKE_ROCKETJUMP_PRESSED = false
QUAKE_ROCKETJUMP_ISBEINGPRESSED = false

Client.Subscribe("MouseDown", function(key_name, mouse_x, mouse_y)
    if key_name == "RightMouseButton" then
        local posy = GetPositionBlocked()
        local playerChara = Client.GetLocalPlayer():GetControlledCharacter()
        if playerChara ~= nil and posy ~= nil then
            local distance = playerChara:GetLocation():Distance(posy)
            if distance > 500 then
                playEffect("nanos-world::A_VR_Negative")
                return true
            end
            QUAKE_ROCKETJUMP_PRESSED = true
            QUAKE_ROCKETJUMP_ISBEINGPRESSED = true
            Events.CallRemote("QUAKE_RocketJump", posy)
            Timer.SetTimeout(function(pos)
                playEffect3D("nanos-world::A_Explosion_Large", pos)
                return false
            end, 200, posy)
            Timer.SetTimeout(function()
                QUAKE_ROCKETJUMP_PRESSED = false
                return false
            end, QUAKE_CONFIG.RocketJumpPerSeconds * 1000)
        end
    end
end)

Client.Subscribe("MouseUp", function(key_name, mouse_x, mouse_y)
    if key_name == "RightMouseButton" then
        QUAKE_ROCKETJUMP_ISBEINGPRESSED = false
    end
end)