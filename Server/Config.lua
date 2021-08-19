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

QUAKE_CONFIG = {}
-- Do not touch
function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function ConfigLoad()
    Package.Log("Loading Config...")
    local cfgFile = File("Packages/" .. Package.GetPath() .. "/Server/Config.json")
    local cfgJson = JSON.parse(cfgFile:Read(cfgFile:Size()))
    QUAKE_CONFIG = cfgJson
    NewPlayerSpawnLocations = {}
    for key,value in pairs(QUAKE_CONFIG.PlayerSpawnLocations)
    do
        local newVectorTXT = string.gsub(value, "% ", "")
        newVectorTXT = Split(newVectorTXT, ",")
        local newVector = Vector(tonumber(newVectorTXT[1]), tonumber(newVectorTXT[2]), tonumber(newVectorTXT[3]))
        table.insert(NewPlayerSpawnLocations, newVector)
    end
    QUAKE_CONFIG.PlayerSpawnLocations = NewPlayerSpawnLocations
    Package.Log("Loading Config COMPLETE!")
end