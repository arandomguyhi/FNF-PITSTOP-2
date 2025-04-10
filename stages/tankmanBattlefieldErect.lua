luaDebugMode = true

local path = '../week7/images/erect/'

local bzl = require('mods/'..currentModDirectory..'/stages/props/TankmanSpriteGroup')

function onCreate()
    makeLuaSprite('bg', path..'bg', -985, -805)
    scaleObject('bg', 1.15, 1.15)
    addLuaSprite('bg')

    makeAnimatedLuaSprite('sniper', path..'sniper', -127, 349)
    scaleObject('sniper', 1.15, 1.15)
    addAnimationByPrefix('sniper', 'idle', 'Tankmanidlebaked instance 1', 24, false)
    addAnimationByPrefix('sniper', 'sip', 'tanksippingBaked instance 1', 24, false)
    playAnim('sniper', 'idle')
    addLuaSprite('sniper')

    makeAnimatedLuaSprite('guy', path..'guy', 1398, 407)
    scaleObject('guy', 1.15, 1.15)
    addAnimationByPrefix('guy', 'idle', 'BLTank2 instance 1', 24, false)
    playAnim('guy', 'idle')
    addLuaSprite('guy')
end

function onCreatePost()
    if shadersEnabled then
        initLuaShader('DropShadow')
        for _, i in pairs({'boyfriend', 'dad', 'gf'}) do
            setSpriteShader(i, 'DropShadow')

            setAdjustColor(i, -46, -38, -25, -20)
            setShaderFloatArray(i, 'dropColor', {223/255, 239/255, 60/255})
            setShaderFloat(i, 'thr', 0.1)
            updateFrameInfo(i)

            if i == 'boyfriend' then
                setShaderFloat(i, 'ang', 90 * getPropertyFromClass('flixel.math.FlxAngle', 'TO_RAD'))

                runHaxeCode([[
                    game.boyfriend.animation.callback = function() {
                        parentLua.call('updateFrameInfo', ['boyfriend']);
                    }
                ]])
            elseif i == 'gf' then
                setShaderFloat(i, 'ang', 90 * getPropertyFromClass('flixel.math.FlxAngle', 'TO_RAD'))

                setShaderSampler2D(i, 'altMask', path..'masks/gfTankmen_mask')
                setShaderFloat(i, 'thr2', 0.4)
                setShaderBool(i, 'useMask', true)

                runHaxeCode([[
                    game.gf.animation.callback = function() {
                        parentLua.call('updateFrameInfo', ['gf']);
                    }
                ]])
            else
                setShaderFloat(i, 'ang', 135 * getPropertyFromClass('flixel.math.FlxAngle', 'TO_RAD'))
                setShaderFloat(i, 'thr', 0.3)

                setShaderSampler2D(i, 'altMask', path..'masks/tankmanCaptainBloody_mask')
                setShaderFloat(i, 'thr2', 1)
                setShaderBool(i, 'useMask', false)

                runHaxeCode([[
                    game.dad.animation.callback = function() {
                        parentLua.call('updateFrameInfo', ['dad']);
                    }
                ]])
            end

            setShaderFloat(i, 'dist', 15)
            setShaderFloat(i, 'AA_STAGES', 2)
        end
    end
end

function onBeatHit()
    if getRandomBool(2) then
        sipTime = true
        playAnim('sniper', 'sip', true)
    end

    if curBeat % 2 == 0 then
        if not sipTime then
            playAnim('sniper', 'idle', true)
        end
        playAnim('guy', 'idle', true)
    end
end

function onUpdate()
    if getProperty('sniper.animation.curAnim.name') == 'sip' and getProperty('sniper.animation.curAnim.finished') then
        sipTime = false
    end
end

function onEvent(name)
    if name == 'enableMask' then
        setShaderBool('dad', 'useMask', true)

        setProperty('dad.idleSuffix', '-bloody')
        for i = 0, getProperty('unspawnNotes.length')-1 do
            if not getProperty('unspawnNotes['..i..'].mustPress') then
                setProperty('unspawnNotes['..i..'].animSuffix', '-bloody')
            end
        end
    end
end

function setAdjustColor(spr,b,h,c,s)
    setShaderFloat(spr, 'brightness', b)
    setShaderFloat(spr, 'hue', h)
    setShaderFloat(spr, 'contrast', c)
    setShaderFloat(spr, 'saturation', s)
end

function updateFrameInfo(spr)
    setShaderFloatArray(spr, 'uFrameBounds', {
        getProperty(spr..'.frame.uv.x'), getProperty(spr..'.frame.uv.y'),
        getProperty(spr..'.frame.uv.width'), getProperty(spr..'.frame.uv.height')
    })
    setShaderFloat(spr, 'angOffset', getProperty(spr..'.frame.angle') * getPropertyFromClass('flixel.math.FlxAngle', 'TO_RAD'))
end