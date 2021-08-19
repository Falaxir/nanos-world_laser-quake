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

function playMusic(name)
    Sound(Vector(), name, true, true, SoundType.Music, 0.4)
end

function playEffect(name)
    Sound(Vector(), name, true, true, SoundType.SFX, 0.9)
end

function playEffect3D(name, location)
    Sound(location, name, false, true, SoundType.SFX, 0.8)
end

Events.Subscribe("QUAKE_Client_PlayMusic", function(music)
    if music == nil or music == "" then return end
    playMusic(music)
end)

Events.Subscribe("QUAKE_Client_PlayEffect", function(music)
    if music == nil or music == "" then return end
    playEffect(music)
end)

Events.Subscribe("QUAKE_Client_PlayEffect3D", function(music, location)
    if music == nil or location == nil or music == "" or location == "" then return end
    playEffect3D(music, location)
end)

function PlayQuakeSounds()
    if QUAKE_CONFIG ~= nil then
        if QUAKE_KS > QUAKE_CONFIG.KillStreakSoundsNumberMinToPlay then
            playEffect(QUAKE_CONFIG.QuakeKillStreakSounds[math.random(#QUAKE_CONFIG.QuakeKillStreakSounds)])
        else
            playEffect(QUAKE_CONFIG.QuakeRandomSounds[math.random(#QUAKE_CONFIG.QuakeRandomSounds)])
        end
    end
end

Events.Subscribe("QUAKE_Client_PlayAnnouncementSound", function (state, time)
    if state == 1 then
        if time == 60 then
            playMusic("laser-quake-assets::announcer_ends_60sec")
        end
        if time == 30 then
            playMusic("laser-quake-assets::announcer_ends_30sec")
        end
        if time == 10 then
            playMusic("laser-quake-assets::announcer_ends_10sec")
        end
        if time == 5 then
            playMusic("laser-quake-assets::announcer_ends_5sec")
        end
        if time == 4 then
            playMusic("laser-quake-assets::announcer_ends_4sec")
        end
        if time == 3 then
            playMusic("laser-quake-assets::announcer_ends_3sec")
        end
        if time == 2 then
            playMusic("laser-quake-assets::announcer_ends_2sec")
        end
        if time == 1 then
            playMusic("laser-quake-assets::announcer_ends_1sec")
        end
    end
    if state == 2 then
        if time == 10 then
            playMusic("laser-quake-assets::announcer_begins_10sec")
        end
        if time == 5 then
            playMusic("laser-quake-assets::announcer_begins_5sec")
        end
        if time == 4 then
            playMusic("laser-quake-assets::announcer_begins_4sec")
        end
        if time == 3 then
            playMusic("laser-quake-assets::announcer_begins_3sec")
        end
        if time == 2 then
            playMusic("laser-quake-assets::announcer_begins_2sec")
        end
        if time == 1 then
            playMusic("laser-quake-assets::announcer_begins_1sec")
        end
    end
end)