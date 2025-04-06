luaDebugMode = true

function onCreate()
    ogSpeed = getProperty('songSpeed')
end

function onEvent(name, value1, value2)
    if name == 'Scroll Speed' then
		local splitV1 = stringSplit(value1, ',')

		-- i'll make this better if theres another ocasion
		if splitV1[4] == nil then splitV1[4] = false end
		startTween('changeSpeed', 'this', {songSpeed =  (splitV1[4] and 1 or ogSpeed) * tonumber(splitV1[1])}, ((stepCrochet/1000) * tonumber(splitV1[2])), {ease = tostring(splitV1[3])})
	end
end