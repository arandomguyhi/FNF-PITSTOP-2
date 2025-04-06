-- I'M MAKING THIS MUCH BETTER LATER I PROMISE :SOB:
luaDebugMode = true

local tweenDuration = 0
function onEvent(name, value1, value2)
    if name == 'Focus Camera' then
		local splitV1 = stringSplit(value1, ',')
		local splitV2 = stringSplit(value2, ',')

		local bfCamX = getMidpointX('boyfriend') - 100 - getProperty('boyfriend.cameraPosition[0]') + getProperty('boyfriendCameraOffset[0]')
		local bfCamY = getMidpointY('boyfriend') - 100 + getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]')
		local dadCamX = getMidpointX('dad') + 150 + getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]')
		local dadCamY = getMidpointY('dad') - 100 + getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]')
		local gfCamX = getMidpointX('gf')+getProperty('gf.cameraPosition[0]')+getProperty('girlfriendCameraOffset[0]')
		local gfCamY = getMidpointY('gf')+getProperty('gf.cameraPosition[1]')+getProperty('girlfriendCameraOffset[1]')

		if not string.find(value1, ',') then
			cancelTween('camTween')
			if value1 == 'Opponent' then
				cameraSetTarget('dad')
			elseif value1 == 'Player' then
				cameraSetTarget('boyfriend')
			elseif value1 == 'Girlfriend' then
				setProperty('camFollow.x', gfCamX)
				setProperty('camFollow.y', gfCamY)
			end
		else
			if value2 ~= '' and value2 ~= 'instant' then tweenDuration = (stepCrochet/1000)*tonumber(splitV2[1]) end

			if splitV1[1] == 'Opponent' then
				if value2 ~= '' and value2 ~= 'instant' then
					startTween('camTween', 'camFollow', {x = dadCamX + splitV1[2], y = dadCamY + splitV1[3]}, tweenDuration/2, {ease = tostring(splitV2[2])})
				elseif value2 == 'instant' then
					callMethod('camFollow.setPosition', {dadCamX + splitV1[2], dadCamY + splitV1[3]})
					setProperty('camGame.scroll.x', dadCamX + splitV1[2] - (screenWidth/2))
					setProperty('camGame.scroll.y', dadCamY + splitV1[3] - (screenHeight/2))
				else
					if value2 ~= '' then return end
					setProperty('camFollow.x', dadCamX + splitV1[2])
					setProperty('camFollow.y', dadCamY + splitV1[3])
				end
			elseif splitV1[1] == 'Player' then
				if value2 ~= '' and value2 ~= 'instant' then
					startTween('camTween', 'camFollow', {x = bfCamX + splitV1[2], y = bfCamY + splitV1[3]}, tweenDuration/2, {ease = tostring(splitV2[2])})
				elseif value2 == 'instant' then
					callMethod('camFollow.setPosition', {bfCamX + splitV1[2], bfCamY + splitV1[3]})
					setProperty('camGame.scroll.x', bfCamX + splitV1[2] - (screenWidth/2))
					setProperty('camGame.scroll.y', bfCamY + splitV1[3] - (screenHeight/2))
				else
					if value2 ~= '' then return end
					setProperty('camFollow.x', bfCamX + splitV1[2])
					setProperty('camFollow.y', bfCamY + splitV1[3])
				end
			elseif splitV1[1] == 'Girlfriend' then
				if value2 ~= '' and value2 ~= 'instant' then
					startTween('camTween', 'camFollow', {x = gfCamX + splitV1[2], y = gfCamY + splitV1[3]}, tweenDuration/2, {ease = tostring(splitV2[2])})
				elseif value2 == 'instant' then
					callMethod('camFollow.setPosition', {gfCamX + splitV1[2], gfCamY + splitV1[3]})
					setProperty('camGame.scroll.x', gfCamX + splitV1[2] - (screenWidth/2))
					setProperty('camGame.scroll.y', gfCamY + splitV1[3] - (screenHeight/2))
				else
					if value2 ~= '' then return end
					setProperty('camFollow.x', gfCamX + splitV1[2])
					setProperty('camFollow.y', gfCamY + splitV1[3])
				end
			end
		end

		if gfName == 'nene-pixel' then
			if value1:find('Opponent') then
				playAnim('abotHead', 'toleft')
			elseif value1:find('Player') then
				playAnim('abotHead', 'toright')
			end
		end
    end
end

function onUpdate()
    setProperty('isCameraOnForcedPos', true)
end