Server.SetValue("QUAKE_TimeLimit", QUAKE_CONFIG.RoundTimeLimitSeconds)

Timer.SetInterval(function()
    local state = Server.GetValue("QUAKE_GameState")
    if state == nil then
        state = 0
        Server.SetValue("QUAKE_GameState", 0)
    end
    local playerNames = Player.GetAll()
    local timerTick = Server.GetValue("QUAKE_TimeLimit")
    Events.BroadcastRemote("QUAKE_Client_HUD_Players", #playerNames)
    Events.BroadcastRemote("QUAKE_Client_HUD_Timer", timerTick)
    if timerTick == 60 or timerTick == 30 or timerTick <= 10 then
        if state >= 1 then
            Events.BroadcastRemote("QUAKE_Client_PlayAnnouncementSound", state, timerTick)
        end
    end
    if state == 0 then
        if #playerNames < 2 then
            Events.BroadcastRemote("QUAKE_Client_HUD_Advert_important", "2 Players required to begin", nil)
            return true
        end
        Events.Call("QUAKE_START_Game", nil)
        return true
    end
    if state == 1 then
        if #playerNames < 2 then
            Events.Call("QUAKE_WAITING_Game", nil)
            return true
        end
        if timerTick <= 0 then
            Events.Call("QUAKE_END_Game", nil)
            return true
        end
    end
    if state == 2 then
        if timerTick <= 0 then
            Events.Call("QUAKE_WAITING_Game", nil)
            return true
        end
    end
    if timerTick <= 0 then return true end
    Server.SetValue("QUAKE_TimeLimit", timerTick - 1)
    return true
end, 1000)