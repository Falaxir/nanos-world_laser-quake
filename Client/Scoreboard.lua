function reverseTable(t)
    local len = #t
    for i = len - 1, 1, -1 do
        t[len] = table.remove(t, i)
    end
end

function CreateScoreboard()
    local roundPoints = {}
    local PlayerNames = Player.GetAll()

    for key,value in pairs(PlayerNames)
    do
        local getQUAKE_Points = value:GetValue("QUAKE_Points")
        if getQUAKE_Points == nil then
            getQUAKE_Points = 0
        end
        table.insert(roundPoints, getQUAKE_Points)
    end
    table.sort(roundPoints)
    Events.BroadcastRemote("QUAKE_Client_HUD_Scoreboard", JSON.stringify(roundPoints))
end