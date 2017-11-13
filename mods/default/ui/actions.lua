local actions = {}
local unit
function actions:init(ui)
	self.ui = ui
	self.ship = ui.ship
	self.hud = ui.hud
	self.color = ui.color
	unit = self.ui.unit
	self.x = 20+ unit*35
	self.y = h()- 10 - 8* unit
	self.w = 81*unit 
	self.h = 8*unit
	self.bw = 6*unit
	self.bh = 6*unit 
	return self
end

function actions:update(dt)
	local mods = {}	
	for i, slot in ipairs(self.ship.slot) do
		local tab = {
			slot = slot,
			socket = slot.socket,
			mod = slot.plugin,
			enabled = slot.enabled,
		}
		if tab.mod then
			tab.name = tab.mod.mod_name
			tab.timer = tab.mod.cd_timer or 0
			tab.cd = tab.mod.cool_down
		else
			tab.name = "not used"
		end
		mods[i] = tab
		end
	
	self.mods = mods
	if #mods<13 then
		suit.Panel(self.x,self.y,self.w,self.h)
		for i = 1, 12 do
			local mod = mods[i]
			if mod then
				local name = i.." ".."\n"..mod.name
				if suit.Button(name,
					{toggle = mod.slot.enabled},
					self.x + (i-1)*self.bw+6*i , 
					self.y+unit,self.bw,self.bh).hit then
					mod.slot.enabled = not mod.slot.enabled
					self.ship:slot_enable(mod.slot,mod.slot.enabled)
					
				end
			end
		end
	else
		suit.Panel(self.x,self.y-self.bh,self.w,self.h+self.bh)
		for i = 1, 12 do
			local mod = mods[i]
			if mod then
				local name = i.." ".."\n"..mod.name
				if suit.Button(name,
					{toggle = mod.slot.enabled},
					self.x + (i-1)*self.bw+6*i,
					self.y+unit-self.bh,self.bw,self.bh).hit then
					mod.slot.enabled = not mod.slot.enabled
					self.ship:slot_enable(mod.slot,mod.slot.enabled)
				end
			end
		end
		for i = 13, 24 do
			local mod = mods[i]
			if mod then
				local name = i.." ".."\n"..mod.name
				if suit.Button(name,
					{toggle = mod.slot.enabled},
					self.x + (i-13)*self.bw+6*(i-13), 
					self.y+unit,self.bw,self.bh).hit then
					mod.slot.enabled = not mod.slot.enabled
					self.ship:slot_enable(mod.slot,mod.slot.enabled)
				end
			end
		end
	end
end


function actions:drawRectPie(x,y,w,h,percent)
	if percent<0 then return end
	local function to_cut()
		love.graphics.arc("fill", x+w/2, y+h/2, w*2, -Pi/2, 2*Pi*(1-percent) -Pi/2)
	end
	love.graphics.stencil(to_cut, "replace", 1)

    love.graphics.setStencilTest("less", 1)
 
    love.graphics.setColor(100, 100, 255, 250)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(0, 0, 0, 250)    
end

function actions:draw()
	local mods = self.mods
	if #mods<13 then
		for i = 1, 12 do
			local mod = mods[i]
			if mod and mod.cd then
				self:drawRectPie(self.x + (i-1)*self.bw+6*i ,
				 self.y+unit,self.bw,self.bh,mod.timer/mod.cd)
			end
		end
	else
		suit.Panel(self.x,self.y-self.bh,self.w,self.h+self.bh)
		for i = 1, 12 do
			local mod = mods[i]
			if mod and mod.cd then
				self:drawRectPie( self.x + (i-1)*self.bw+6*i , 
					self.y+unit-self.bh,self.bw,self.bh,mod.timer/mod.cd)
			end
		end
		for i = 13, 24 do
			local mod = mods[i]
			if mod and mod.cd then
				self:drawRectPie( self.x + (i-13)*self.bw+6*(i-13) , 
					self.y+unit,self.bw,self.bh,mod.timer/mod.cd)
			end
		end
	end
end


return actions