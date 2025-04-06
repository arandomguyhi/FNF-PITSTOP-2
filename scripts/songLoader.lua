luaDebugMode = true

function onCreatePost()
    local diff = difficultyName:lower()
    local bfName = boyfriendName:find('-') and stringSplit(boyfriendName, '-')[1] or boyfriendName

    runHaxeCode([[
        game.inst.loadEmbedded(Paths.returnSound(Paths.formatToSongPath(']]..songPath..[[/Inst-]]..diff..[['), 'songs'));
        game.opponentVocals.loadEmbedded(Paths.voices(']]..songPath..[[', ']]..dadName..[[-]]..diff..[['));
        game.vocals.loadEmbedded(Paths.voices(']]..songPath..[[', ']]..bfName..[[-]]..diff..[['));
    ]])
end