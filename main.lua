
__TESTING = true

local path = ""
local default_mods = "/mods/default"

require ("lib.util")
class = require ("lib.middleclass")
gamestate = require ("lib.gamestate")
tween = require ("lib.tween")
Anim = require ("lib.animation")
suit = require "lib.suit"
camera = require "lib.gamera"
grid = require "lib.grid"
trail = require "lib.trail"
Input = require "lib.input"
input = Input()

classes = require "classes_loader"
mods = require "mods_loader"

function love.load()
	print(gyro.install,emitter.install)
	love.graphics.setBackgroundColor(10,5,14)
	love.graphics.setLineWidth(4)
	love.graphics.setLineStyle("smooth")
	love.graphics.setLineJoin( "bevel" )
	love.graphics.setDefaultFilter( "linear", "nearest", 2 )
	gameState={}
	for _,name in ipairs(love.filesystem.getDirectoryItems(default_mods.."/scene")) do
		gameState[name:sub(1,-5)]=require(default_mods.."/scene."..name:sub(1,-5))
	end
	gamestate.registerEvents()
	gamestate.switch(gameState.testscene)
end

function love.mouse.getXY()
	return gamestate.current().cam:toWorld(love.mouse.getPosition())
end
