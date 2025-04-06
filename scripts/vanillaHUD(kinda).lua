local holdColors = {'Purple', 'Blue', 'Green', 'Red'}

luaDebugMode = true

function onCreate()
    isPixel = getPropertyFromClass('states.PlayState', 'isPixelStage')
    prevGhostTap = getPropertyFromClass('backend.ClientPrefs', 'data.ghostTapping')
    setPropertyFromClass('backend.ClientPrefs', 'data.ghostTapping', false)    
end

function onStartCountdown()
    for _, i in pairs({'timeBar', 'timeBar.bg', 'timeTxt', 'scoreTxt'}) do
	    setProperty(i..'.visible', false) end
    setProperty('botplayTxt.y', getProperty('healthBar.y') + (downscroll and 70 or -120))

    callMethod('healthBar.setColors', {0xFF0000, 0x00FF00})

    makeLuaText('newScore', 'Score: 0', 0, getProperty('scoreTxt.x')+780, getProperty('scoreTxt.y')-10)
    setTextSize('newScore', 16)
    setObjectCamera('newScore', 'hud')
    addLuaText('newScore')

    for i = 1, #holdColors do
        if not isPixel then
            makeAnimatedLuaSprite('glow'..holdColors[i], 'holdCover/holdCover'..holdColors[i])
            addAnimationByPrefix('glow'..holdColors[i], 'holdStart'..holdColors[i], 'holdCoverStart'..holdColors[i], 24, false)
            addAnimationByPrefix('glow'..holdColors[i], 'hold'..holdColors[i], 'holdCover'..holdColors[i], 24, false)
            addAnimationByPrefix('glow'..holdColors[i], 'holdEnd'..holdColors[i], 'holdCoverEnd'..holdColors[i], 24, false)
            addLuaSprite('glow'..holdColors[i], true)
            setObjectCamera('glow'..holdColors[i], 'camHUD')
            setProperty('glow'..holdColors[i]..'.alpha', 0.001)

            makeAnimatedLuaSprite('opGlow'..holdColors[i], 'holdCover/holdCover'..holdColors[i])
            addAnimationByPrefix('opGlow'..holdColors[i], 'hold'..holdColors[i], 'holdCover'..holdColors[i], 24, false)
            addLuaSprite('opGlow'..holdColors[i], true)
            setObjectCamera('opGlow'..holdColors[i], 'camHUD')
            setProperty('opGlow'..holdColors[i]..'.alpha', 0.001)
        else
            makeAnimatedLuaSprite('glow'..holdColors[i], '../week6/pixelNoteHoldCover')
            scaleObject('glow'..holdColors[i], 6, 6)
            addAnimationByPrefix('glow'..holdColors[i], 'loop', 'loop', 24, false)
            addAnimationByPrefix('glow'..holdColors[i], 'explode', 'explode', 24, false)
            addLuaSprite('glow'..holdColors[i], true)
            setObjectCamera('glow'..holdColors[i], 'camHUD')
            setProperty('glow'..holdColors[i]..'.alpha', 0.001)

            makeAnimatedLuaSprite('opGlow'..holdColors[i], '../week6/pixelNoteHoldCover')
            scaleObject('opGlow'..holdColors[i], 6, 6)
            addAnimationByPrefix('opGlow'..holdColors[i], 'loop', 'loop', 24, false)
            addLuaSprite('opGlow'..holdColors[i], true)
            setObjectCamera('opGlow'..holdColors[i], 'camHUD')
            setProperty('opGlow'..holdColors[i]..'.alpha', 0.001)
        end
    end
end

function onCountdownTick(t) -- that's pretty dumb ik
    if t == 0 then
        for i = 0,7 do
            setProperty('strumLineNotes.members['..i..'].x', getProperty('strumLineNotes.members['..i..'].x')-35)
        end
    end
end

function onUpdatePost()
    setTextString('newScore', 'Score: '..score)

    for i = 1, #holdColors do
        if getProperty('glow'..holdColors[i]..'.animation.curAnim.finished') then
            setProperty('glow'..holdColors[i]..'.alpha', 0.001) end

        if getProperty('opGlow'..holdColors[i]..'.animation.curAnim.finished') then
            setProperty('opGlow'..holdColors[i]..'.alpha', .001) end
    end
end

local prevCombo = 0
function goodNoteHit(i, d, t, s)
    if s then
	    setProperty('boyfriend.holdTimer', 0)

        local noteOffsets = {
            x = getPropertyFromGroup('playerStrums', d, 'x'),
            y = getPropertyFromGroup('playerStrums', d, 'y')
        }

        --easy asf yea?
        setProperty('glow'..holdColors[d+1]..'.alpha', getPropertyFromGroup('playerStrums', d, 'alpha'))

        setProperty('glow'..holdColors[d+1]..'.x', noteOffsets.x-390)
        setProperty('glow'..holdColors[d+1]..'.y', noteOffsets.y-123)

        if string.find(getPropertyFromGroup('notes', i, 'animation.curAnim.name'):lower(), 'end') and s then
            playAnim('glow'..holdColors[d+1], not isPixel and 'holdEnd'..holdColors[d+1] or 'explode')
        else
            playAnim('glow'..holdColors[d+1], not isPixel and 'hold'..holdColors[d+1] or 'loop', true)
        end
    end
end

function opponentNoteHit(i,d,t,s)
    if s then
        setProperty('dad.holdTimer', 0)

        local noteOffsets = {
            x = getPropertyFromGroup('opponentStrums', d, 'x'),
            y = getPropertyFromGroup('opponentStrums', d, 'y')
        }

        setProperty('opGlow'..holdColors[d+1]..'.alpha', getPropertyFromGroup('opponentStrums', d, 'alpha'))
        playAnim('opGlow'..holdColors[d+1], not isPixel and 'hold'..holdColors[d+1] or 'loop', true)

        setProperty('opGlow'..holdColors[d+1]..'.x', noteOffsets.x-390)
        setProperty('opGlow'..holdColors[d+1]..'.y', noteOffsets.y-123)
    end
end

function onSpawnNote(i)
    if getPropertyFromGroup('notes', i, 'isSustainNote') then
        setPropertyFromGroup('notes', i, 'noAnimation', true)
    end
end

function onDestroy()
    setPropertyFromClass('backend.ClientPrefs', 'data.ghostTapping', prevGhostTap)
end