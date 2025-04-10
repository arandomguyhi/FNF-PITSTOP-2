luaDebugMode = true

local path = '../week6/weeb/'
local diaJson = callMethodFromClass('tjson.TJSON', 'parse', {getTextFromFile('dialogue/conversations/senpai-pico.json')})

setVar('isTalking', true)
local curDia = 1

function onCustomSubstateCreate(name)
    if name == 'dialogue' then
        playMusic('../week6/music/'..diaJson.music.asset, 1, diaJson.music.looped)
        soundFadeIn('', diaJson.music.fadeTime, 0, 1)

        makeLuaSprite('back')
        makeGraphic('back', screenWidth*1.2, screenHeight*1.2, diaJson.backdrop.color:gsub('#', ''))
        setObjectCamera('back', 'other')
        screenCenter('back')
        addLuaSprite('back')

        setProperty('back.alpha', 0)
        startTween('fadeBack', 'back', {alpha = 1}, diaJson.backdrop.fadeTime, {})

        makeAnimatedLuaSprite('boxSprite', path..'pixelUI/dialogueBox-new')
        scaleObject('boxSprite', 6 * 0.9, 6 * 0.9)
        screenCenter('boxSprite')
        addAnimationByPrefix('boxSprite', 'enter', 'Text Box Appear', 24, false)
        addAnimationByPrefix('boxSprite', 'speaking', 'Text Box Speaking', 24, false)
        addAnimationByPrefix('boxSprite', 'wait', 'Text Box wait to click', 24, true)
        addAnimationByPrefix('boxSprite', 'click', 'Text Box CLICK', 24, false)
        addAnimationByIndices('boxSprite', 'end', 'Text Box Appear', {4,3,2,1,0}, 24, false)
        setObjectCamera('boxSprite', 'other')
        setProperty('boxSprite.y', getProperty('boxSprite.y') + 50)
        setProperty('boxSprite.antialiasing', false)
        addLuaSprite('boxSprite')

        playAnim('boxSprite', diaJson.dialogue[1].boxAnimation)

        createInstance('textDisplay', 'flixel.addons.text.FlxTypeText', {0, 0, 800, diaJson.dialogue[curDia].text[1], 32})
        setTextFont('textDisplay', 'pixel-latin.ttf')
        setProperty('textDisplay.borderSize', 0)
        setTextColor('textDisplay', '502F2E')
        setTextAlignment('textDisplay', 'left')
        setObjectCamera('textDisplay', 'other')
        addInstance('textDisplay')

        callMethod('textDisplay.start', {0.05})
        runHaxeCode([[
            getVar('textDisplay').sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
            getVar('textDisplay').completeCallback = function() {
                game.getLuaObject('boxSprite').playAnim('wait');
                setVar('isTalking', false);
            }
        ]])

        setProperty('textDisplay.x', screenWidth - getProperty('boxSprite.width') + 260)
        setProperty('textDisplay.y', screenHeight - 250)

        changePortrait(diaJson.dialogue[curDia].speaker)
    end
end

function onCustomSubstateUpdate(name)
    if name == 'dialogue' then
        if (buildTarget == 'windows' and getProperty('controls.ACCEPT') or touchedScreen()) then
            playSound('textboxClick')

            if getVar('isTalking') then
                setVar('isTalking', false)
                callMethod('textDisplay.skip', {''})
                return
            end

            if curDia < #diaJson.dialogue and not getVar('isTalking') then
                changeDialogue()

                playAnim('boxSprite', 'click')
                if getProperty('boxSprite.animation.finished') then
                    playAnim('boxSprite', diaJson.dialogue[curDia].boxAnimation)
                end

                setVar('isTalking', true)
            elseif curDia >= #diaJson.dialogue then
                playAnim('boxSprite', 'end', true)
                for _, spr in pairs({'back', 'boxSprite', 'portrait', 'textDisplay'}) do
                    startTween('bzl'.._, spr, {alpha = 0}, 1, {onComplete = 'startCountdown'})
                end
                soundFadeIn('', diaJson.outro.fadeTime, 1, 0)
                closeCustomSubstate()
            end
        end
    end
end

function onStartCountdown()
    if not allowCountdown and not seenCutscene then
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

local curText = 1
function changeDialogue()
    local texts = diaJson.dialogue[curDia].text

    if curText >= #texts then
        curDia = curDia + 1
        curText = 1

        changePortrait(diaJson.dialogue[curDia].speaker)
        setText(diaJson.dialogue[curDia].text[curText])

        return
    end

    curText = curText + 1
    appendText(texts[curText])
end

function setText(newText)
    setProperty('textDisplay.prefix', '')
    callMethod('textDisplay.resetText', {newText})
    callMethod('textDisplay.start', {0.05})
end

function appendText(newText)
    setProperty('textDisplay.prefix', getProperty('textDisplay.text'))
    callMethod('textDisplay.resetText', {newText})
    callMethod('textDisplay.start', {0.05})
end

local musicStopped = false
function changePortrait(port)
    local portJson = callMethodFromClass('tjson.TJSON', 'parse', {getTextFromFile('dialogue/speakers/'..port..'.json')})

    if luaSpriteExists('portrait') then
        removeLuaSprite('portrait') end

    makeAnimatedLuaSprite('portrait', '../week6/'..portJson.assetPath, portJson.offsets[1], portJson.offsets[2])
    scaleObject('portrait', portJson.scale, portJson.scale)
    setProperty('portrait.antialiasing', not portJson.isPixel)
    addAnimationByPrefix('portrait', portJson.animations[1].name, portJson.animations[1].prefix, portJson.animations[1].frameRate, false)
    addAnimationByPrefix('portrait', portJson.animations[2].name, portJson.animations[2].prefix, 24, false)
    setObjectCamera('portrait', 'other')
    addLuaSprite('portrait')

    setObjectOrder('boxSprite', getObjectOrder('portrait')+1)
    setObjectOrder('textDisplay', getObjectOrder('boxSprite')+1)

    playAnim('portrait', diaJson.dialogue[curDia].speakerAnimation, true)

    if port == 'senpai-bwuh' then
        musicStopped = true
        pauseSound('')
    elseif musicStopped and port == 'senpai' then
        musicStopped = false
        resumeSound('')
        soundFadeIn('', 2, 0, 1)
    end
end

function touchedScreen()
    local mX, mY = getMouseX('camOther') + getProperty('camOther.scroll.x'), getMouseY('camOther') + getProperty('camOther.scroll.y')
    local x, y = getProperty('camOther.x'), getProperty('camOther.y')
    return mouseClicked() and (mX > x) and (mX < x + screenWidth) and (mY > y) and (mY < y + screenHeight)
end