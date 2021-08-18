Events.Subscribe("QUAKE_Client_HUD_Players", function (text)
    MainHUD:CallEvent("QUAKE_HUD_Players_Remaining", "Players: " .. text)
end)

Events.Subscribe("QUAKE_Client_HUD_Timer", function (text)
    MainHUD:CallEvent("QUAKE_HUD_Timer", text)
end)

Events.Subscribe("QUAKE_Client_HUD_Killed", function (killer)
    MainHUD:CallEvent("QUAKE_HUD_Killed", killer)
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
    MainHUD:CallEvent("QUAKE_HUD_Scoreboard", scores)
end)