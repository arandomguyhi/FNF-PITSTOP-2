luaDebugMode = true

local tankSpr = {
    endingOffset = 0,
    runSpeed = 0,
    strumTime = 0,
    goingRight = false,
    tankCount = 1
}
local tankData = {}

function tankSpr:new(id)
    local i = 'tankmen'..id
    makeAnimatedLuaSprite(i, '../week7/images/tankmanKilled1', 500, 350)
    addAnimationByPrefix(i, 'run', 'tankman running', 24, true)
    addAnimationByPrefix(i, 'shot', 'John Shot '..getRandomInt(1,2), 24, false)
    scaleObject(i, 0.4, 0.4)

    tankData[id] = {
        id = i,
        endingOffset = tankSpr.endingOffset,
        runSpeed = tankSpr.runSpeed,
        strumTime = tankSpr.strumTime,
        facingRight = tankSpr.goingRight,
        hasShot = false
    }

    setObjectOrder(i, getObjectOrder('guy')+1)

    addLuaSprite(i)
    initAnim(id)

    if shadersEnabled then
        addRimlight(id)
    end
end

function deathFlicker(tankName)
    runHaxeCode([[
        import flixel.effects.FlxFlicker;

        var tankmanFlicker:FlxFlicker = null;
        tankmanFlicker = FlxFlicker.flicker(game.getLuaObject(']]..tankName..[['), 0.3, 1 / 30, false, true, function(cu:FlxFlicker) {
            tankmanFlicker = null;
			parentLua.call('kill', [']]..tankName..[[']);
        });
    ]])
end

function kill(tank)
    removeLuaSprite(tank, true)
end

function addRimlight(id)
    if shadersEnabled then
        local name = 'tankmen'..id

        setSpriteShader(name, 'DropShadow')

        setShaderFloat(name, 'brightness', -46)
        setShaderFloat(name, 'hue', -38)
        setShaderFloat(name, 'contrast', -25)
        setShaderFloat(name, 'saturation', -20)

        setShaderFloat(name, 'thr', 0.4)
        setShaderFloatArray(name, 'dropColor', {223/255, 239/255, 60/255})

        runHaxeCode([[
            game.getLuaObject(']]..name..[[').animation.callback = function() {
                parentLua.call('updateFrameInfo', [']]..name..[[']);
            }
        ]])

        setShaderFloat(name, 'ang', 135)
        setShaderFloat(name, 'str', 1)
        setShaderFloat(name, 'dist', 15)
        setShaderFloat(name, 'AA_STAGES', 2)
        setShaderBool(name, 'altMask', false)
    end
end

function initAnim(id)
    local data = tankData[id]
    if data then
        playAnim(data.id, 'run')
        setProperty(data.id..'.animation.curAnim.curFrame', getRandomInt(1, getProperty(data.id..'.animation.curAnim.numFrames')-1))

        setProperty(data.id..'.offset.y', 0)
        setProperty(data.id..'.offset.x', 0)
    end
end

function revive()
    for i = 1, tankSpr.tankCount do
        setProperty('tankmen'..i..'.visible', true)
    end
    initAnim()
end

function updateFrameInfo(spr)
    if shadersEnabled then
        setShaderFloatArray(spr, 'uFrameBounds', {
            getProperty(spr..'.frame.uv.x'), getProperty(spr..'.frame.uv.y'),
            getProperty(spr..'.frame.uv.width'), getProperty(spr..'.frame.uv.height')
        })
        setShaderFloat(spr, 'angOffset', getProperty(spr..'.frame.angle') * getPropertyFromClass('flixel.math.FlxAngle', 'TO_RAD'))
    end
end

function tankSpr.update()
    local songPos = getSongPosition()

    for id, data in pairs(tankData) do
        local tank = data.id

        if shadersEnabled then
            if luaSpriteExists(tank) then
            --updateFrameInfo(tank)
            end
        end

        if getProperty(tank..'.animation.curAnim.name') == 'shot' and getProperty(tank..'.animation.curAnim.curFrame') >= 10 and not data.hasShot then
            data.hasShot = true
            deathFlicker(tank)
        end

        if songPos >= data.strumTime and getProperty(tank..'.animation.curAnim.name') == 'run' then
            playAnim(tank, 'shot')

            setProperty(tank..'.offset.y', 200)
            setProperty(tank..'.offset.x', 300)
        end

        if getProperty(tank..'.animation.curAnim.name') == 'run' then
            local runFactor = (songPos - data.strumTime) * data.runSpeed
            if not data.facingRight then
                setProperty(tank..'.x', (screenWidth * 0.02 - data.endingOffset) + runFactor)
            else
                setProperty(tank..'.x', (screenWidth * 0.74 + data.endingOffset) - runFactor)
            end
        end
    end
end

return tankSpr