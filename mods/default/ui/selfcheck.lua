local check = {}
local unit
function check:init(ui,menu)
	self.ui = ui
	self.ship = ui.ship
	self.hud = ui.hud
	self.color = ui.color
	self.menu = menu
	unit = self.ui.unit

	self.frame = {
		title = "self checking",
		x = w()/2-500, 
		y = h()/2-250, 
		w = 1000,
		h = 400,
		buttons = {
		{text = "close"},
		}
	}



	self.desc_list = {
		x = self.frame.x+unit,
		y = self.frame.y + unit,
		w = 30*unit,
		h = self.frame.h - 2*unit,
		title = "description",
		item_height = self.frame.h - 2*unit - 35,
		item_type = "label",
		items = {
			{"this is an awesome ship"}
		}
	}

	self.ship_show = {
		x = self.desc_list.x + self.desc_list.w + 20*unit - unit/2,
		y = self.frame.h/2+self.frame.y,
		w = 38*unit,
		h = self.frame.h - 2*unit,
		scale = self.frame.h/4,
		verts = self.ship.verts
	}


	self.slot_show = {
		title = "modules",
		x = self.frame.x + 70*unit,
		y = self.frame.y + unit,
		w = self.frame.w - 71*unit,
		h = self.frame.h - 2*unit,
		item_height = 60,
		item_type = "button",
		items = {},
		slots = {},
	}

	for i, slot in ipairs(self.ship.slot) do
		self.slot_show.slots[i] = slot 
		if slot.plugin then
			self.slot_show.items[i] = {i.." "..slot.plugin.mod_name}
		else
			self.slot_show.items[i] = {i.." ".."not used"}
		end
	end

	return self
end

function check:update(dt)

	

	local frame = self.frame
	suit.Frame(frame.title,frame,frame.x, frame.y, frame.w,frame.h)


	local des = self.desc_list
	suit.List(des.title,des,des.x, des.y, des.w,des.h)


	if self.frame.buttons[1].reply.hit then
		self.menu.currentWindow = nil
	end
	
	local show = self.ship_show
	suit.Panel(show.x-show.w/2,show.y-show.h/2,show.w,show.h)

	local slot = self.slot_show
	suit.Panel(slot.x,slot.y,slot.w,slot.h)
	suit.List(slot.title,slot,slot.x,slot.y,slot.w,slot.h)
	self.highLight =  nil
	for i , b in ipairs(slot.items) do
		if b.reply.hovered then
			self.highLight = i
			--self.desc_list.items[1][1] = 
		end
	end
end


local slot_size = 30


function check:draw()
	local show = self.ship_show
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.push()
	love.graphics.translate(show.x, show.y)
	love.graphics.outlinePolygon(show.verts,show.scale)
	if self.highLight then
		local slot = self.slot_show.slots[self.highLight]
		local offx = slot.offx*show.scale
		local offy = slot.offy*show.scale
		local rot = slot.rot*2*Pi
		love.graphics.push()
		love.graphics.translate(offx, offy)
		love.graphics.rotate(rot)
		love.graphics.setColor(50, 250, 50, 150)
		love.graphics.rectangle("fill",  - slot_size/2,  - slot_size/2, slot_size, slot_size)
		love.graphics.setColor(255, 255, 255, 250)
		love.graphics.polygon("fill", 0, - slot_size/2, - slot_size/2, slot_size/2, slot_size/2,slot_size/2)		
		if slot.plugin and slot.plugin.socket == "weapon" then
			love.graphics.setColor(0, 255, 0, 20)
			love.graphics.arc("fill", 0, 0, show.scale, -slot.plugin.rotLimit-Pi/2, slot.plugin.rotLimit-Pi/2)
		end
		love.graphics.rotate(-rot)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.printf(self.highLight, - slot_size/2,  -2, slot_size, "center")
		love.graphics.pop()
	end
	love.graphics.pop()

end


return check



--[[
self.shop = {x = w()/2-40*unit, y = h()/2-30*unit, w = 80*unit, h = 45*unit, title = "xxxx trading center",bw = unit*10,bh = unit*4}
	--"status,stockage,message,event,exchange,dockyard,"
	
	self.status = {x = w()/2-40*unit, y = h()/2-28*unit, w = 80*unit, h = 45*unit,
		 title = "xxxx ship status",bw = unit*10,bh = unit*4}
	self.stockage = {x = w()/2-40*unit, y = h()/2-28*unit, w = 80*unit, h = 45*unit,
		 title = "xxxx ship stockage",info = {min = 0,max = 10,step = 1,value = 0,vertical=true},}]]