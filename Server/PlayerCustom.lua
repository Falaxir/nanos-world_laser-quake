-- List of SK_Male hair Static Meshes
sk_male_hair_meshes = {
    "",
    "nanos-world::SM_Hair_Long",
    "nanos-world::SM_Hair_Short"
}

-- List of SK_Male beard Static Meshes
sk_male_beard_meshes = {
    "",
    "nanos-world::SM_Beard_Extra",
    "nanos-world::SM_Beard_Middle",
    "nanos-world::SM_Beard_Mustache_01",
    "nanos-world::SM_Beard_Mustache_02",
    "nanos-world::SM_Beard_Side"
}

-- List of SK_Female hair Static Meshes
sk_female_hair_meshes = {
    "",
    "nanos-world::SM_Hair_Kwang"
}

male_death_sounds = {
    "nanos-world::A_Male_01_Death",
    "nanos-world::A_Male_02_Death",
    "nanos-world::A_Male_03_Death",
    "nanos-world::A_Male_04_Death",
    "nanos-world::A_Male_05_Death",
    "nanos-world::A_Male_06_Death"
}

male_pain_sounds = {
    "nanos-world::A_Male_01_Pain",
    "nanos-world::A_Male_02_Pain",
    "nanos-world::A_Male_03_Pain",
    "nanos-world::A_Male_04_Pain",
    "nanos-world::A_Male_05_Pain",
    "nanos-world::A_Male_06_Pain",
    "nanos-world::A_Male_07_Pain",
    "nanos-world::A_Male_06_Pain"
}

female_death_sounds = {
    "nanos-world::A_Female_01_Death",
    "nanos-world::A_Female_02_Death",
    "nanos-world::A_Female_03_Death",
    "nanos-world::A_Female_04_Death",
    "nanos-world::A_Female_05_Death"
}

female_pain_sounds = {
    "nanos-world::A_Female_01_Pain",
    "nanos-world::A_Female_02_Pain",
    "nanos-world::A_Female_03_Pain",
    "nanos-world::A_Female_04_Pain",
    "nanos-world::A_Female_05_Pain",
    "nanos-world::A_Female_06_Pain",
    "nanos-world::A_Female_07_Pain",
    "nanos-world::A_Female_06_Pain"
}

human_morph_targets = {
    "nose1",
    "nose2",
    "brows",
    "mouth",
    "fat",
    "nose3",
    "chin",
    "face",
    "nose4",
    "skinny",
    "jaw",
    "brows2",
    "angry",
    "smirk",
    "smirk2",
    "smirk3",
    "smile",
    "nose6",
    "jaw_forward",
    "lips",
    "lips2",
    "mouth_wide",
    "eyes1",
    "eyes2",
    "eyes3",
    "eyes4",
    "eyes_retraction",
    "lips3",
    "eyes5",
    "nose7",
    "forehead",
    "bodyfat",
}

human_skin_tones = {
    Color(1.000000, 1.000000, 1.000000),
    Color(1.000000, 0.926933, 0.820785),
    Color(0.984375, 0.854302, 0.661377),
    Color(1.000000, 0.866979, 0.785255),
    Color(0.890625, 0.768996, 0.658135),
    Color(0.880208, 0.706081, 0.588818),
    Color(0.526042, 0.340051, 0.221689),
    Color(0.244792, 0.185846, 0.151720),
    Color(0.791667, 0.573959, 0.428820),
    Color(0.947917, 0.655642, 0.399902),
    Color(0.583333, 0.406594, 0.261284),
    Color(0.645833, 0.465268, 0.360730),
    Color(1.000000, 0.917535, 0.739583),
    Color(0.932292, 0.825388, 0.670085),
    Color(0.817708, 0.710384, 0.549398),
    Color(0.765625, 0.620475, 0.454590),
    Color(0.050000, 0.050000, 0.080000),
}

hair_tints = {
    Color(0.067708, 0.030797, 0.001471),
    Color(0.983483, 1.000000, 0.166667),
    Color(0.010000, 0.010000, 0.010000),
    Color(1.000000, 0.129006, 0.000000),
}

function SpawnPlayerCustomisation(player, location, rotation)
    local selected_mesh = QUAKE_CONFIG.PlayerCharacters[math.random(#QUAKE_CONFIG.PlayerCharacters)]
    local new_char = Character(location or QUAKE_CONFIG.PlayerSpawnLocations[math.random(#QUAKE_CONFIG.PlayerSpawnLocations)], rotation or Rotator(), selected_mesh)

    -- Customization
    if (selected_mesh == "nanos-world::SK_Male") then
        local selected_hair = sk_male_hair_meshes[math.random(#sk_male_hair_meshes)]
        if (selected_hair ~= "") then
            new_char:AddStaticMeshAttached("hair", selected_hair, "hair_male")
        end

        local selected_beard = sk_male_beard_meshes[math.random(#sk_male_beard_meshes)]
        if (selected_beard ~= "") then
            new_char:AddStaticMeshAttached("beard", selected_beard, "beard")
        end
    end

    if (selected_mesh == "nanos-world::SK_Male" or selected_mesh == "nanos-world::SK_Mannequin") then
        local selected_death_Sound = male_death_sounds[math.random(#male_death_sounds)]
        new_char:SetDeathSound(selected_death_Sound)

        local selected_pain_Sound = male_pain_sounds[math.random(#male_pain_sounds)]
        new_char:SetPainSound(selected_pain_Sound)
    end

    if (selected_mesh == "nanos-world::SK_Female" or selected_mesh == "nanos-world::SK_Mannequin_Female") then
        local selected_death_Sound = female_death_sounds[math.random(#female_death_sounds)]
        new_char:SetDeathSound(selected_death_Sound)

        local selected_pain_Sound = female_pain_sounds[math.random(#female_pain_sounds)]
        new_char:SetPainSound(selected_pain_Sound)
    end

    if (selected_mesh == "nanos-world::SK_Female") then
        local selected_hair = sk_female_hair_meshes[math.random(#sk_female_hair_meshes)]
        if (selected_hair ~= "") then
            new_char:AddStaticMeshAttached("hair", selected_hair, "hair_female")
        end

        -- Those parameters are specific to female mesh
        new_char:SetMaterialColorParameter("BlushTint", Color(0.52, 0.12, 0.15))
        new_char:SetMaterialColorParameter("EyeShadowTint", Color(0.24, 0.05, 0.07))
        new_char:SetMaterialColorParameter("LipstickTint", Color(0.31, 0.03, 0.1))
    end

    -- Adds eyes to humanoid meshes
    if (selected_mesh == "nanos-world::SK_Male" or selected_mesh == "nanos-world::SK_Female") then
        new_char:AddStaticMeshAttached("eye_left", "nanos-world::SM_Eye", "eye_left")
        new_char:AddStaticMeshAttached("eye_right", "nanos-world::SM_Eye", "eye_right")

        -- Those parameters are specific to humanoid meshes (were added in their materials)
        new_char:SetMaterialColorParameter("HairTint", hair_tints[math.random(#hair_tints)])
        new_char:SetMaterialColorParameter("Tint", human_skin_tones[math.random(#human_skin_tones)])

        new_char:SetMaterialScalarParameter("Muscular", math.random(100) / 100)
        new_char:SetMaterialScalarParameter("BaseColorPower", math.random(2) + 0.5)

        for i, morph_target in ipairs(human_morph_targets) do
            new_char:SetMorphTarget(morph_target, math.random(200) / 100 - 1)
        end
    end
    return new_char
end