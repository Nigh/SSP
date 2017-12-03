
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
	global_camera = self.cam
	self.zoom = 1
	grid.new(self.cam)
	-- self.ui = require(modDir.."default/ui")

	_ = self.world:new_obj("void seeker")
	_:setXY(800,800)
	self.player = _

	_ = self.world:new_obj("test_ship_L1")

	_ = self.world:new_obj("test_ship1")
	_:setXY(-400,-200)

	_=self.world:new_obj("test_ship1")
	_:setXY(400,0)


	-- 安装推进器
	-- _ = self.world:new_obj(require(modDir.."default/device/test_thruster2"))
	_ = self.world:new_obj("thruster XL")
	_.host = self.player
	_.dx,_.dy = _.host:toRealXY(127,219)
	table.insert(self.player.slot,_)
	-- 为推进器安装控制器
	__ = classes:new("power_ctrl")
	__:install_to(_)
	table.insert(keyboard_hook,__)
	-- 安装拖尾特效
	___ = classes:new("void engine trail")
	___:install_with_cam(_,self.cam)

	_ = self.world:new_obj("thruster XL")
	_.host = self.player
	_.dx,_.dy = _.host:toRealXY(119,225)
	table.insert(self.player.slot,_)
	-- 为推进器安装控制器
	__ = classes:new("power_ctrl")
	__:install_to(_)
	table.insert(keyboard_hook,__)
	-- 安装拖尾特效
	___ = classes:new("void engine trail")
	___:install_with_cam(_,self.cam)

	_ = self.world:new_obj("thruster XL")
	_.host = self.player
	_.dx,_.dy = _.host:toRealXY(250,219)
	table.insert(self.player.slot,_)
	-- 为推进器安装控制器
	__ = classes:new("power_ctrl")
	__:install_to(_)
	table.insert(keyboard_hook,__)
	-- 安装拖尾特效
	___ = classes:new("void engine trail")
	___:install_with_cam(_,self.cam)

	_ = self.world:new_obj("thruster XL")
	_.host = self.player
	_.dx,_.dy = _.host:toRealXY(259,225)
	table.insert(self.player.slot,_)
	-- 为推进器安装控制器
	__ = classes:new("power_ctrl")
	__:install_to(_)
	table.insert(keyboard_hook,__)
	-- 安装拖尾特效
	___ = classes:new("void engine trail")
	___:install_with_cam(_,self.cam)


	-- 安装动量轮
	_ = classes:new("gyroscope_XL")
	_.host = self.player
	table.insert(self.player.slot,_)
	-- 为动量轮安装控制器
	__ = classes:new(require(modDir.."default/controller/turn_ctrl"))
	__:install_to(_)

	table.insert(keyboard_hook,__)

	-- 生成blink发生器
	_ = classes:new(require(modDir.."default/device/test_blink_X1"))
	_:install_to(self.player)
	-- 为blink发生器安装控制器
	__ = self.world:new_obj(require(modDir.."default/controller/skill_ctrl"))
	__:install_to(_)
	table.insert(keyboard_hook,__)

	-- -- 安装拖尾特效
	-- _ = classes:new("void seeker trail")
	-- _:install_with_cam(self.player,self.cam)
	-- _:setDelta(_.host:toRealXY(189,95))

	-- 安装粒子特效
	_ = classes:new("void seeker particle")
	_:install_to(self.player)
	_:setDelta(_.host:toRealXY(_.dx,_.dy))

	-- 安装激光发射器
	_ = classes:new("laser_X1")
	print(_.install_to)
	_:install_to(self.player)
	-- 为激光器安装控制器
	__ = self.world:new_obj("fire_ctrl")
	__:install_to(_)
	table.insert(keyboard_hook,__)


	-- print(self.player.body:getMassData())
	love.keyboard.setTextInput( true, 10, 100, 100, 20 )
end

function scene:update(dt)
	self.cam:followTarget(self.player,10,20)
	self.world:update(dt)
end

function scene:draw()
	-- grid.draw()
	-- lg.push()
	-- love.graphics.translate(500, 200)
	-- love.graphics.scale(0.1)
	-- self.world:draw()
	-- lg.pop()
	-- lg.setColor(255,255,255,255)
	-- love.graphics.draw(self.player.tex_pic, 700, 300,self.player:getROT(),0.3,0.3,189,333)
	self.cam:draw(function() self.world:draw() end)
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

function scene:textedited( text, start, length )
	print(text, start, length)
end

function love.textinput( text )
	print(text)
end


return scene
