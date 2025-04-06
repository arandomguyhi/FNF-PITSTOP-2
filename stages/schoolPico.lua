luaDebugMode = true

local path = '../week6/weeb/erect/'

function onCreate()
    setPropertyFromClass('states.PlayState', 'SONG.splashSkin', '../week6/pixelNoteSplash')

    createPixelSpr('sky', 'weebSky', -164, -78, {0.2, 0.2}) -- 10
    createPixelSpr('backTrees', 'weebBackTrees', -242, -80, {0.5, 0.5}) -- 15
    createPixelSpr('school', 'weebSchool', -216, -38, {0.75, 0.75}) -- 20
    createPixelSpr('street', 'weebStreet', -200, 6, {1, 1}) -- 30
    createPixelSpr('treesFG', 'weebTreesBack', -200, 6, {1, 1}) -- 40

    makeAnimatedLuaSprite('treesBG', path..'weebTrees', -806, -1050) -- 60
    addAnimationByIndices('treesBG', 'treeLoop', 'trees_', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18}, 12, true)
    playAnim('treesBG', 'treeLoop')
    scaleObject('treesBG', 6, 6)
    setProperty('treesBG.antialiasing', false)
    addLuaSprite('treesBG')

    makeAnimatedLuaSprite('petals', path..'petals', -20, -40) -- 70
    addAnimationByPrefix('petals', 'leaves', 'PETALS ALL', 24, true)
    playAnim('petals', 'leaves')
    scaleObject('petals', 6, 6)
    setScrollFactor('petals', 0.85, 0.85)
    setProperty('petals.antialiasing', false)
    addLuaSprite('petals')
end

function createPixelSpr(tag, name, x, y, info)
    makeLuaSprite(tag, path..name, x, y)
    scaleObject(tag, 6, 6)
    setScrollFactor(tag, info[1], info[2])
    setProperty(tag..'.antialiasing', false)
    addLuaSprite(tag)
end

function onCreatePost()
    if shadersEnabled then
        initLuaShader('DropShadow')
        for _, i in pairs({'boyfriend', 'dad', 'gf'}) do
            setSpriteShader(i, 'DropShadow')

            setShaderFloat(i, 'thr', 0.1)
            setShaderFloat(i, 'str', 1)

            setAdjustColor(i, -66, -10, 24, -23)
            setShaderFloat(i, 'AA_STAGES', 2)
            setShaderFloatArray(i, 'dropColor', {83/255, 53/255, 29/255})
            updateFrameInfo(i)
            setShaderFloat(i, 'dist', 5)

            if i == 'boyfriend' then
                setShaderFloat(i, 'ang', 90 * getPropertyFromClass('flixel.math.FlxAngle', 'TO_RAD'))

                setShaderSampler2D(i, 'altMask', path..'masks/picoPixel_mask')
                setShaderFloat(i, 'thr2', 1)
                setShaderBool(i, 'useMask', true)
            elseif i == 'gf' then
                setShaderFloat(i, 'ang', 90 * getPropertyFromClass('flixel.math.FlxAngle', 'TO_RAD'))

                setShaderSampler2D(i, 'altMask', path..'masks/nenePixel_mask')
                setShaderFloat(i, 'thr2', 1)
                setShaderBool(i, 'useMask', true)

                if version >= '1.0' then
                    callOnLuas('addSunsetShader', {''})
                end
            else
                setShaderFloat(i, 'ang', 90 * getPropertyFromClass('flixel.math.FlxAngle', 'TO_RAD'))

                setShaderSampler2D(i, 'altMask', path..'masks/senpai_mask')
                setShaderFloat(i, 'thr2', 1)
                setShaderBool(i, 'useMask', true)
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

function onUpdatePost()
    if shadersEnabled then
        for _, i in pairs({'boyfriend', 'dad', 'gf'}) do
            updateFrameInfo(i)
        end

        if version >= '1.0' then
            updateFrameInfo('abotSpeaker')
        end
    end
end