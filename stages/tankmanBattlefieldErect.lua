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