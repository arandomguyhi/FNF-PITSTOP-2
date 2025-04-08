local tankmanGroup = require('mods/'..currentModDirectory..'/stages/props/TankmanSpriteGroup')

precacheImage('../week7/images/tankmanKilled1')

function onSongStart()
    tankmanGroup:new()
    tankmanGroup:reset()
    tankmanGroup.add()
end