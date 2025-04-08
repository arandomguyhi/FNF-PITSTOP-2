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
    makeAnimatedLuaSprite(i, '../week7/images/tankmanKilled1')
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

    addLuaSprite(i)
    initAnim(id)
end

function deathFlicker()
    --
end

function kill()
    for i = 1, tankSpr.tankCount do
        removeLuaSprite('tankmen'..i)
    end
end

function tankSpr:addRimlight()
    if shadersEnabled then
        makeLuaSprite('rim') setSpriteShader('rim', 'DropShadow')

        setShaderFloat('rim', 'brightness', -46)
        setShaderFloat('rim', 'hue', -38)
        setShaderFloat('rim', 'contrast', -25)
        setShaderFloat('rim', 'saturation', -20)

        setShaderFloat('rim', 'thr', 0.4)
        setShaderFloatArray('rim', 'dropColor', {223/255, 239/255, 60/255})

        runHaxeCode("getVar('tankmanSprite').shader = game.getLuaObject('rim').shader;")

        setShaderFloat('rim', 'ang', 135)
        setShaderFloat('rim', 'str', 1)
        setShaderFloat('rim', 'dist', 15)
        setShaderFloat('rim', 'AA_STAGES', 2)
        setShaderBool('rim', 'altMask', false)
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

        if getProperty(tank..'.animation.curAnim.name') == 'shot' and getProperty(tank..'.animation.curAnim.curFrame') >= 10 then
            deathFlicker()
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