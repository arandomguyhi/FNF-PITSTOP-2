local tankmanGroup = require('mods/'..currentModDirectory..'/stages/props/TankmanSpriteGroup')
local hasPlayedEndCutscene = false

precacheImage('../week7/images/tankmanKilled1')
precacheImage('../week7/images/erect/cutscene/tankmanEnding/spritemap1')

tankmanGroup:new(true)
tankmanGroup:reset()

function onStartCountdown()
    if not hasPlayedVideo and not seenCutscene then
        hasPlayedVideo = true

        callMethod('startVideo', {'stressPicoCutscene', true, false, false, true})
        runHaxeCode([[
            game.videoCutscene.videoSprite.bitmap.onEndReached.add(function() {
                parentLua.call('startLeSong', ['']);
            });
        ]])

        return Function_Stop
    else
        hasPlayedVideo = false
    end
    return Function_Continue
end
function startLeSong() startCountdown() end

function onEndSong()
    if not hasPlayedEndCutscene then
        hasPlayedEndCutscene = true

        makeLuaSprite('bgSprite')
        makeGraphic('bgSprite', 2000, 2500, '000000')
        setObjectCamera('bgSprite', 'other')
        addLuaSprite('bgSprite', true)
        setProperty('bgSprite.alpha', 0)

        startEndCutscene()

        return Function_Stop
    else
        hasPlayedEndCutscene = false
    end
    return Function_Continue
end

function startEndCutscene()
    setProperty('camHUD.visible', false)

    runHaxeCode([[ // ik i can use instance, but i'm lazy
        var rimlightCamera = new FlxCamera();
        rimlightCamera.bgColor = 0x00FFFFFF;
        FlxG.cameras.add(rimlightCamera, false);
        setVar('rimlightCamera', rimlightCamera);
    ]])

    if shadersEnabled then
        initLuaShader('DropShadowScreenspace')

        makeLuaSprite('screenspaceRimlight') setSpriteShader('screenspaceRimlight', 'DropShadowScreenspace')
        setShaderFloat('screenspaceRimlight', 'brightness', -46)
        setShaderFloat('screenspaceRimlight', 'hue', -38)
        setShaderFloat('screenspaceRimlight', 'contrast', -25)
        setShaderFloat('screenspaceRimlight', 'saturation', -20)

        setShaderFloat('screenspaceRimlight', 'ang', 45 * getPropertyFromClass('flixel.math.FlxAngle', 'TO_RAD'))
        setShaderFloat('screenspaceRimlight', 'thr', 0.3)

        setShaderFloat('screenspaceRimlight', 'dist', 5)
        setShaderFloat('screenspaceRimlight', 'str', 1)
        setShaderFloat('screenspaceRimlight', 'angOffset', 0)

        setShaderBool('screenspaceRimlight', 'useMask', false)
        setShaderFloat('screenspaceRimlight', 'AA_STAGES', 2)
        setShaderFloat('screenspaceRimlight', 'zoom', 1)
        setShaderFloatArray('screenspaceRimlight', 'dropColor', {223/255, 239/255, 60/255})

        runHaxeCode("getVar('rimlightCamera').setFilters([new ShaderFilter(game.getLuaObject('screenspaceRimlight').shader)]);")
    end

    makeFlxAnimateSprite('tankmanCutscene', 0, 0, '../week7/images/erect/cutscene/tankmanEnding')
    addAnimationBySymbol('tankmanCutscene', 'animation', 'tankman stress ending', 24, false)
    setProperty('tankmanCutscene.x', getProperty('dad.x') + 723)
    setProperty('tankmanCutscene.y', getProperty('dad.y') + 195)

    startTween('setCamPos', 'camFollow', {x = getMidpointX('dad') + 520, y = getMidpointY('dad') - 130}, 2.8, {ease = 'expoOut'})
    startTween('setCamZoom', 'game', {['camGame.zoom'] = 0.65, defaultCamZoom = 0.65}, 2, {ease = 'expoOut'})

    setProperty('dad.visible', false)
    addLuaSprite('tankmanCutscene')
    runHaxeCode("game.getLuaObject('tankmanCutscene').camera = getVar('rimlightCamera');")

    playAnim('tankmanCutscene', 'animation')
    playSound('../week7/sounds/erect/endCutscene')

    runTimer('laugh', 176/24)
    runTimer('camUp', 270/24)
    runTimer('endCut', 320/24)

    onTimerCompleted = function(tag)
        if tag == 'laugh' then
            playAnim('boyfriend', 'laughEnd', true)
            setProperty('boyfriend.specialAnim', true)
        elseif tag == 'camUp' then
            startTween('setCamPos', 'camFollow', {x = getMidpointX('dad') + 520, y = getMidpointY('dad') - 430}, 2.8, {ease = 'expoOut'})
            doTweenAlpha('allBlack', 'bgSprite', 1, 2)
        elseif tag == 'endCut' then
            runHaxeCode("FlxG.cameras.remove(getVar('rimlightCamera'));")
            endSong()
        end
    end
end

function onUpdatePost()
    if hasPlayedEndCutscene then
        setProperty('rimlightCamera.scroll.x', getProperty('camGame.scroll.x'))
        setProperty('rimlightCamera.scroll.y', getProperty('camGame.scroll.y'))
        setProperty('rimlightCamera.zoom', getProperty('camGame.zoom'))
    end
end