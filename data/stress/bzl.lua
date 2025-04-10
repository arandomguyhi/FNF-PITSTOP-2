local tankmanGroup = require('mods/'..currentModDirectory..'/stages/props/TankmanSpriteGroup')

precacheImage('../week7/images/tankmanKilled1')

tankmanGroup:new(true)
tankmanGroup:reset()