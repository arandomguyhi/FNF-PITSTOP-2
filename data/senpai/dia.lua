luaDebugMode = true

local path = '../week6/weeb/'
local diaJson = callMethodFromClass('tjson.TJSON', 'parse', {getTextFromFile('dialogue/conversations/senpai-pico.json')})

function onCustomSubstateCreate(name)
    if name == 'dialogue' then
        makeLuaSprite('back')
        makeGraphic('back', screenWidth*1.2, screenHeight*1.2, diaJson.backdrop.color:gsub('#', ''))
        setObjectCamera('back', 'other')
        screenCenter('back')
        addLuaSprite('back')

        setProperty('back.alpha', 0)
        startTween('fadeBack', 'back', {alpha = 1}, diaJson.backdrop.fadeTime, {})

        makeLuaSprite('portLeft', )

        makeAnimatedLuaSprite('boxSprite', path..'pixelUI/dialogueBox-pixel')
        scaleObject('boxSprite', 6 * 0.9, 6 * 0.9)
        screenCenter('boxSprite')
        addAnimationByPrefix('boxSprite', 'appear', 'Text Box Appear instance 1', 24, false)
        playAnim('boxSprite', 'appear')
        setObjectCamera('boxSprite', 'other')
        setProperty('boxSprite.y', getProperty('boxSprite.y') + 50)
        setProperty('boxSprite.antialiasing', false)
        addLuaSprite('boxSprite')

        createInstance('diaText', 'flixel.addons.text.FlxTypeText', {0, 0, 800, 'Text Text Text', 32})
        setTextFont('diaText', 'pixel-latin.ttf')
        setProperty('diaText.borderSize', 0)
        setTextColor('diaText', '502F2E')
        setTextAlignment('diaText', 'left')
        setObjectCamera('diaText', 'other')
        addInstance('diaText')
        callMethod('diaText.start', {0.1})

        setProperty('diaText.x', screenWidth - getProperty('boxSprite.width') + 260)
        setProperty('diaText.y', screenHeight - 250)
    end
end

function onStartCountdown()
    if not allowCountdown then
        allowCountdown = true

        makeLuaSprite('black', nil, -20, -20)
        makeGraphic('black', screenWidth * 1.5, screenHeight * 1.5, '000000')
        setObjectCamera('black', 'other')
        addLuaSprite('black', true)

        runTimer('removeBlack', 0.25)
        onTimerCompleted = function(tag)
            if tag == 'removeBlack' then
                removeLuaSprite('black', true)
                cameraFade('game', '000000', 2, false, true)
            end
        end

        runHaxeCode([[
            var tweenFunction = function(x) {
                var xSnapped = Math.floor(x * 8) / 8;
            };

            FlxTween.num(0.0, 1.0, 2.0, {
                ease: FlxEase.linear,
                startDelay: 0.25,
                onComplete: function (input) {
                    callOnLuas('openCustomSubstate', ['dialogue']);
                }}, tweenFunction);
        ]])

        return Function_Stop
    end
    return Function_Continue
end

function onUpdate()
    if keyboardJustPressed('ONE') then
        restartSong()
    end
end