luaDeprecatedWarnings = false
addHaxeLibrary('FlxTypedSpriteGroup', 'flixel.group')
addHaxeLibrary('Song', 'backend')

local group = {}
local isErect = false
local tankmanSprite = require('mods/'..currentModDirectory..'/stages/props/TankmanSprite')

function group:new(erect)
    runHaxeCode([[
        var tankGroup = new FlxTypedSpriteGroup(0, 0, 4);
        setVar('tankGroup', tankGroup);
    ]])

    isErect = (erect ~= nil) and erect or false
end

function group.add()
    runHaxeCode("addBehindGF(getVar('tankGroup'));")
end

function group:reset()
    callMethod('tankGroup.group.clear', {''})
    initTimemap()
end

function initTimemap()
    runHaxeCode([[
        var tankTime = []; var tankDir = [];
        var tanker = Song.loadFromJson('picospeaker', 'stress');

        for (section in tanker.notes) {
            for (noteJunk in section.sectionNotes) {
                var leData = Std.int(noteJunk[1] % 4);
                tankTime.push(noteJunk[0]);

                if (FlxG.random.bool(6.25)) {
                    tankTime.push(noteJunk[0]);
                    var goingRight:Bool = (leData == 2 || leData == 3) ? false : true;
                    tankDir.push(goingRight); 
                }
            }
        }

        setVar('tankmanTimes', tankTime);
        setVar('tankmanDirs', tankDir);
    ]])

    createTankman(500, 350, getVar('tankmanTimes')[3], false, 1.10)
    createTankman(500, 350, getVar('tankmanTimes')[8], true, 1.10)
    createTankman(500, 350, getVar('tankmanTimes')[12], false, 1.10)
    createTankman(500, 350, getVar('tankmanTimes')[30], false, 1.10)
end

function createTankman(initX, initY, time, right, scale)
    tankmanSprite.strumTime = time
    tankmanSprite.endingOffset = getRandomFloat(50, 200)
    tankmanSprite.runSpeed = getRandomFloat(0.6, 1)
    tankmanSprite.goingRight = right

    tankmanSprite:new(tankmanSprite.tankCount)

    local id = tankmanSprite.tankCount
    local name = 'tankmen'..id

    setProperty(name..'.x', initX)
    setProperty(name..'.y', initY)
    scaleObject(name, scale, scale, false)
    setProperty(name..'.flipX', not right)
    runHaxeCode("getVar('tankGroup').add(game.getLuaObject('"..name.."'));")

    tankmanSprite.tankCount = tankmanSprite.tankCount + 1

    if isErect then
        tankmanSprite:addRimlight()
    end
end

local timer = 0

function onUpdate(elapsed)
    --while true do
    if getSongPosition() < 0 then return end

    tankmanSprite.update()

    --[[local cutoff = getSongPosition() + (1000*3)
    while (#getVar('tankmanTimes') > 1 and getVar('tankmanTimes')[1] <= cutoff) do
        local nextTime = callMethod('tankmanTimes.shift', {''})
        local goingRight = callMethod('tankmanDirs.shift', {''})
        local xPos = 500
        local yPos = 350
        local scale = 1.10
        createTankman(xPos, yPos, nextTime, goingRight, scale)
    end]]
end

function group:kill()
    callMethod('tankGrouo.kill', {''})
    setVar('tankmanTimes', {})
end

return group