
local rootDir = "../../../"
local modDir = "../../../mods/"
local scene = gamestate.new()

local keyboard_hook={}

local debugdraw=require(rootDir.."lib/debugDraw")


function scene:init()
	love.graphics.setLineWidth(4)
	love.graphics.setLineJoin( "bevel" )

	self.world = require(rootDir.."core/world")
	self.cam = camera.new(-10000,-9000,20000,18000)
	self.zoom = 1
	grid.new(self.cam)
	-- self.ui = require(modDir.."default/ui")

	self.player=self.world:new_phys_obj(require(modDir.."default/ship/test_ship_large1"))

	_ = self.world:new_phys_obj(require(modDir.."default/ship/test_ship1"))
	_:setXY(-400,-200)

	_=self.world:new_phys_obj(require(modDir.."default/ship/test_ship1"))
	_:setXY(400,0)
	-- 安装推进器
	_ = self.world:new_phys_obj(require(modDir.."default/device/test_thruster2"))
	_.host = self.player
	table.insert(self.player.slot,_)
	-- 为推进器安装控制器
	__ = base:new(require(modDir.."default/controller/power_ctrl"))
	__:install_to(_)

	table.insert(keyboard_hook,__)

	-- 安装动量轮
	_ = self.world:new_phys_obj(require(modDir.."default/device/test_gyro_large"))
	_.host = self.player
	table.insert(self.player.slot,_)
	-- 为动量轮安装控制器
	__ = base:new(require(modDir.."default/controller/turn_ctrl"))
	__:install_to(_)

	table.insert(keyboard_hook,__)

	-- 生成blink发生器
	_ = base:new(require(modDir.."default/device/test_blink_X1"))
	_:install_to(self.player)
	-- 为blink发生器安装控制器
	__ = self.world:new_phys_obj(require(modDir.."default/controller/skill_ctrl"))
	__:install_to(_)
	table.insert(keyboard_hook,__)

	-- print(self.player.body:getMassData())
end

function scene:update(dt)
	self.cam:followTarget(self.player,10,20)
	self.world:update(dt)
end

function scene:draw()
	grid.draw()
	self.cam:draw(function() self.world:draw() end)
	-- love.graphics.setLineWidth(1.2)
	self.cam:draw(function() debugdraw.draw(self.world.physics_world) end)
end

function scene:wheelmoved(x,y)
	self.zoom = self.zoom * (1+y/10)
	self.zoom = math.clamp(self.zoom,0.07,2)
	self.cam:setScale(self.zoom)
	self.cam:setPosition(self.player.x,self.player.y)
end

function scene:keypressed( key, scancode, isrepeat )
	for i,v in ipairs(keyboard_hook) do
		if v[key] and v[key].press then v[key].press(v) end
	end
end

function scene:keyreleased( key, scancode )
	for i,v in ipairs(keyboard_hook) do
		if v[key] and v[key].release then v[key].release(v) end
	end
end

return scene
