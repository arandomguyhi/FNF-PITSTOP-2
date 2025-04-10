
luaDebugMode = true
luaDeprecatedWarnings = false

addHaxeLibrary('Song', 'backend')

function onCreate()
    createInstance('abot', 'states.stages.objects.ABotSpeaker', {getProperty('gfGroup.x')-65, getProperty('gfGroup.y')+215})
    addInstance('abot')

    setObjectOrder('abot', getObjectOrder('dadGroup')-1)

    setObjectOrder('gfGroup', getObjectOrder('abot')+1)
    setScrollFactor('gfGroup', 1, 1)

    runHaxeCode([[
        var shootTimes = []; var shootDirs = [];
        var shooter = Song.loadFromJson('picospeaker', 'stress');

        for (section in shooter.notes) {
            for (noteJunk in section.sectionNotes) {
                shootTimes.push(noteJunk[0]);
                shootDirs.push(Std.int(noteJunk[1] % 4));
            }
        }

        setVar('shootTimes', shootTimes);
        setVar('shootDirs', shootDirs);

        // for some reason, the one above replaces the chart (????)
        Song.loadFromJson(']]..songPath..[[-]]..difficultyName:lower()..[[', 'stress');
    ]])
end

function onCreatePost()
    if shadersEnabled then
        initLuaShader('adjustColor')

        for _,i in pairs({'abot.eyeBg', 'abot.speaker'}) do
            setSpriteShader(i, 'adjustColor')
            setShaderFloat(i, 'hue', -10)
            setShaderFloat(i, 'saturation', -20)
            setShaderFloat(i, 'brightness', -30)
            setShaderFloat(i, 'contrast', -25)
        end

        for i = 0, getProperty('abot.vizSprites.length')-1 do
            setSpriteShader('abot.vizSprites['..i..']', 'adjustColor')
            setShaderFloat('abot.vizSprites['..i..']', 'brightness', -12)
            setShaderFloat('abot.vizSprites['..i..']', 'hue', -30)
            setShaderFloat('abot.vizSprites['..i..']', 'contrast', 0)
            setShaderFloat('abot.vizSprites['..i..']', 'saturation', -10)
        end
    end
end

function onUpdatePost()
    runHaxeCode([[
        if (getVar('shootTimes').length > 0 && getVar('shootTimes')[0] <= Conductor.songPosition) {
            var nextTime:Float = getVar('shootTimes').shift();
			var nextDir:Int = getVar('shootDirs').shift();

			parentLua.call('playPicoAnimation', [nextDir]);
        }
    ]])
end

function playPicoAnimation(direction)
    setProperty('gf.holdTimer', 0)
    setProperty('gf.specialAnim', true)
    
    if direction == 0 then playAnim('gf', 'shoot1', true)
    elseif direction == 1 then playAnim('gf', 'shoot2', true)
    elseif direction == 2 then playAnim('gf', 'shoot3', true)
    elseif direction == 3 then playAnim('gf', 'shoot4', true) end
end

function onSongStart()
    setProperty('abot.snd', instanceArg('sound.music', 'flixel.FlxG'), false, true)
end