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