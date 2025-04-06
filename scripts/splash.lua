if not getPropertyFromClass('states.PlayState', 'isPixelStage') then
    return end

luaDebugMode = true

precacheImage('../week6/pixelNoteSplash')

function createSplash(index, color)
    local name = 'splash'..index
    local noteOffsets = {
        x = getPropertyFromGroup('playerStrums', index-1, 'x'),
        y = getPropertyFromGroup('playerStrums', index-1, 'y')
    }

    makeAnimatedLuaSprite(name, '../week6/pixelNoteSplash', noteOffsets.x - 60, noteOffsets.y - 50)
    for i = 1, 3 do
        addAnimationByPrefix(name, color..i, color..i, 24, false)
    end
    setProperty(name..'.blend', 0)

    setObjectCamera(name, 'hud')
    setObjectOrder(name, getObjectOrder('noteGroup')+1)
    addLuaSprite(name)
    scaleObject(name, 4, 4)
    setProperty(name..'.antialiasing', false)

    playAnim(name, color..getRandomInt(1,3))
    setProperty(name..'.animation.curAnim.frameRate', 24 + getRandomInt(-2, 2))
end

function goodNoteHit(id,data,type,sustain)
    if sustain or getPropertyFromGroup('notes', id, 'rating') ~= 'sick' then return end

    col = {'purple', 'blue', 'green', 'red'}
    createSplash(data+1, col[data+1])
end

function onUpdatePost()
    for i = 1, 4 do
        if getProperty('splash'..i..'.animation.curAnim.finished') then
            removeLuaSprite('splash'..i)
        end
    end
end