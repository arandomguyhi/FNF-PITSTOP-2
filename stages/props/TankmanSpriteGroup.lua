luaDeprecatedWarnings = false
addHaxeLibrary('FlxTypedSpriteGroup', 'flixel.group')
addHaxeLibrary('Song', 'backend')

local group = {}
local isErect = false
local tankmanSprite = require('mods/'..currentModDirectory..'/stages/props/TankmanSprite')

-- removed the actual group cuz it was useless

function group:new(erect)
    isErect = (erect ~= nil) and erect or false
end

function group:reset()
    --callMethod('tankGroup.group.clear', {''})
    initTimemap()
end

function initTimemap()
    runHaxeCode([[
        var tankTime = []; var tankDir = [];
        var tanker = Song.loadFromJson('picospeaker', 'stress');

        for (section in tanker.notes) {
            for (noteJunk in section.sectionNotes) {
                var leData = Std.int(noteJunk[1] % 4);

                if (FlxG.random.bool(15.25)) {
                    tankTime.push(noteJunk[0]);
                    var goingRight:Bool = (leData == 2 || leData == 3) ? false : true;
                    tankDir.push(goingRight); 
                }
            }
        }

        setVar('tankmanTimes', tankTime);
        setVar('tankmanDirs', tankDir);
    ]])
end

function createTankman(time, right, scale)
    tankmanSprite.strumTime = time
    tankmanSprite.endingOffset = getRandomFloat(50, 200)
    tankmanSprite.runSpeed = getRandomFloat(0.6, 1)
    tankmanSprite.goingRight = right

    tankmanSprite:new(tankmanSprite.tankCount)

    local id = tankmanSprite.tankCount
    local name = 'tankmen'..id

    scaleObject(name, scale, scale, false)
    setProperty(name..'.flipX', not right)

    tankmanSprite.tankCount = tankmanSprite.tankCount + 1
end

local timer = 0

function onUpdate(elapsed)
    tankmanSprite.update()

    runHaxeCode([[
        while (true) {
            var cutoff = Conductor.songPosition + (1000*3);
            if (getVar('tankmanTimes').length > 0 && getVar('tankmanTimes')[0] <= cutoff) {
                var nextTime = getVar('tankmanTimes').shift();
                var goingRight = getVar('tankmanDirs').shift();
                var scale = 1.10;
                parentLua.call('createTankman', [nextTime, goingRight, scale]);
            } else
                break;
        }
    ]])
end

function group:kill()
    callMethod('tankGrouo.kill', {''})
    setVar('tankmanTimes', {})
end

return group