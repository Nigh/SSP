
__TESTING = true

local path = ""
local default_mods = "/mods/default"

require (path.."/lib/util")
class=require (path.."/lib/middleclass")
gamestate= require (path.."lib/gamestate")
tween = require (path.."/lib/tween")
Anim = require (path.."/lib/animation")
suit = require "/lib/suit"
camera = require "/lib/gamera"
base = require "base.base"
grid = require "/lib/grid"
Input = require "/lib/input"
input = Input()

function love.load()
	love.graphics.setBackgroundColor(10,5,14)
	love.graphics.setLineWidth(4)
	love.graphics.setLineJoin( "bevel" )

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
