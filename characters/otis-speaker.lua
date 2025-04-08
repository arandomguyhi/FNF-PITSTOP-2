luaDebugMode = true
luaDeprecatedWarnings = false

addHaxeLibrary('Song', 'backend')

function onCreate()
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