luaDebugMode = true

if version < '1.0' then
    return end

makeAnimatedLuaSprite('abotHead', 'characters/abotPixel/abotHead', getProperty('gfGroup.x')-240, getProperty('gfGroup.y')+200)
scaleObject('abotHead', 6, 6)
setProperty('abotHead.antialiasing', false)
addAnimationByPrefix('abotHead', 'toleft', 'toleft0', 24, false)
addAnimationByPrefix('abotHead', 'toright', 'toright0', 24, false)
addLuaSprite('abotHead')

makeAnimatedLuaSprite('abotSpeaker', 'characters/abotPixel/aBotPixelSpeaker')
scaleObject('abotSpeaker', 6, 6)
setProperty('abotSpeaker.origin.x', callMethodFromClass('Math', 'round', {getProperty('abotSpeaker.origin.x')}))
setProperty('abotSpeaker.origin.y', callMethodFromClass('Math', 'round', {getProperty('abotSpeaker.origin.y')}))
setProperty('abotSpeaker.antialiasing', false)
setProperty('abotSpeaker.x', getProperty('gfGroup.x')-238)
setProperty('abotSpeaker.y', getProperty('gfGroup.y')+120)
addAnimationByPrefix('abotSpeaker', 'danceLeft', 'danceLeft', 24, false)
addLuaSprite('abotSpeaker')

createInstance('abot', 'states.stages.objects.ABotSpeaker', {getProperty('gfGroup.x'), getProperty('gfGroup.y')})
addInstance('abot')

setProperty('abot.eyeBg.visible', false)
setProperty('abot.eyes.visible', false)
setProperty('abot.speaker.visible', false)

loadGraphic('abot.bg', 'characters/abotPixel/aBotPixelBack')
scaleObject('abot.bg', 6, 6)
setProperty('abot.bg.antialiasing', false)
callMethod('abot.bg.setPosition', {getProperty('gfGroup.x')-85, getProperty('gfGroup.y')+120})

makeAnimatedLuaSprite('abotBody', 'characters/abotPixel/aBotPixelBody')
scaleObject('abotBody', 6, 6)
setProperty('abotBody.origin.x', callMethodFromClass('Math', 'round', {getProperty('abotBody.origin.x')}))
setProperty('abotBody.origin.y', callMethodFromClass('Math', 'round', {getProperty('abotBody.origin.y')}))
setProperty('abotBody.antialiasing', false)
setProperty('abotBody.x', getProperty('gfGroup.x')-100)
setProperty('abotBody.y', getProperty('gfGroup.y')+100)
addAnimationByPrefix('abotBody', 'danceLeft', 'danceLeft', 24, false)
addAnimationByPrefix('abotBody', 'danceRight', 'danceRight', 24, false)
addAnimationByPrefix('abotBody', 'lowerKnife', 'return', 24, false)
addLuaSprite('abotBody')

function onSongStart()
    setProperty('abot.snd', instanceArg('sound.music', 'flixel.FlxG'), false, true)
end

for i = 0, getProperty('abot.vizSprites.length')-1 do
    local leX = getProperty('abot.vizSprites['..i..'].x')
    local leY = getProperty('abot.vizSprites['..i..'].y')

    loadFrames('abot.vizSprites['..i..']', 'characters/abotPixel/aBotVizPixel')
    scaleObject('abot.vizSprites['..i..']', 6, 6)
    setProperty('abot.vizSprites['..i..'].antialiasing', false)
    callMethod('abot.vizSprites['..i..'].setPosition', {getProperty('gfGroup.x') + (50*i)-32, leY - getProperty('gfGroup.y') + 461})

    callMethod('abot.vizSprites['..i..'].animation.addByPrefix', {'VIZ', 'viz'..(i+1), 0})
    callMethod('abot.vizSprites['..i..'].animation.play', {'VIZ'})
    callMethod('abot.vizSprites['..i..'].animation.curAnim.finish', {''})
end

function onCountdownTick(t)
    playAnim('abotSpeaker', 'danceLeft', true)
    playAnim('abotBody', 'dance'..(t % 2 == 0 and 'Left' or 'Right'), true)
end

function onBeatHit()
    playAnim('abotSpeaker', 'danceLeft', true)
    playAnim('abotBody', 'dance'..(curBeat % 2 == 0 and 'Left' or 'Right'), true)
end

function addSunsetShader()
    initLuaShader('adjustColor')

    setSpriteShader('abotSpeaker', 'DropShadow')
    setAdjustColor('abotSpeaker', -66, -10, 24, -23)
    setShaderFloat('abotSpeaker', 'ang', 90)
    setShaderFloatArray('abotSpeaker', 'dropColor', {83/255, 53/255, 29/255})
    setShaderFloat('abotSpeaker', 'dist', 5)
    setShaderFloat('abotSpeaker', 'AA_STAGES', 0)
    setShaderFloat('abotSpeaker', 'thr', 1)

    updateFrameInfo('abotSpeaker')
    setShaderSampler2D('abotSpeaker', 'altMask', 'masks/aBotPixelSpeaker_mask')
    setShaderFloat('abotSpeaker', 'thr2', 0)
    setShaderBool('abotSpeaker', 'altMask', true)

    for _, i in pairs({'abotBody', 'abot.bg', 'abotHead'}) do
        setSpriteShader(i, 'adjustColor')

        setShaderFloat(i, 'hue', -10)
        setShaderFloat(i, 'saturation', -23)
        setShaderFloat(i, 'brightness', -66)
        setShaderFloat(i, 'contrast', 24)
    end

    for i = 0, getProperty('abot.vizSprites.length')-1 do
        setSpriteShader('abot.vizSprites['..i..']', 'adjustColor')
        setShaderFloat('abot.vizSprites['..i..']', 'hue', -10)
        setShaderFloat('abot.vizSprites['..i..']', 'saturation', -23)
        setShaderFloat('abot.vizSprites['..i..']', 'brightness', -66)
        setShaderFloat('abot.vizSprites['..i..']', 'contrast', 24)
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