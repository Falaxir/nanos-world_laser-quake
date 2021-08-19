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

Events.Subscribe("QUAKE_Client_HUD_Players", function (text)
    MainHUD:CallEvent("QUAKE_HUD_Players_Remaining", "Players: " .. text)
end)

Events.Subscribe("QUAKE_Client_HUD_Timer", function (text)
    MainHUD:CallEvent("QUAKE_HUD_Timer", text)
end)

Events.Subscribe("QUAKE_Client_HUD_Killed", function (instigator)
    QUAKE_KS = 0
    local PlayerControlled = Client.GetLocalPlayer()
    if PlayerControlled ~= nil and instigator ~= nil then
        Events.Call("QUAKE_Client_PlayEffect", "laser-quake-assets::humiliation")
        Events.CallRemote("QUAKE_KillBroadcast", PlayerControlled, instigator)
        MainHUD:CallEvent("QUAKE_HUD_Killed", instigator:GetName())
    else
        MainHUD:CallEvent("QUAKE_HUD_Killed", instigator)
    end
end)

Events.Subscribe("QUAKE_Client_HUD_Advert_important", function (text, timer)
    MainHUD:CallEvent("QUAKE_HUD_Advert_important", text)
    if timer == nil then return end
    Timer.SetTimeout(function()
        MainHUD:CallEvent("QUAKE_HUD_Advert_important", nil)
        return false
    end, timer * 1000)
end)

Events.Subscribe("QUAKE_Client_HUD_Advert_top_one", function (text, timer)
    MainHUD:CallEvent("QUAKE_HUD_Advert_top_one", text)
    if timer == nil then return end
    Timer.SetTimeout(function()
        MainHUD:CallEvent("QUAKE_HUD_Advert_top_one")
        return false
    end, timer)
end)

Events.Subscribe("QUAKE_Client_HUD_Points", function (points)
    MainHUD:CallEvent("QUAKE_HUD_Points", "Points: " .. points)
end)

Events.Subscribe("QUAKE_Client_HUD_Scoreboard", function (scores)
    if scores ~= nil then
        playEffect("laser-quake-assets::perfect")
    end
    MainHUD:CallEvent("QUAKE_HUD_Scoreboard", scores)
end)