local message = {}
local unit
function message:init(ui,menu)
	self.ui = ui
	self.ship = ui.ship
	self.hud = ui.hud
	self.color = ui.color
	self.menu = menu
	unit = self.ui.unit

	self.frame = {
		title = "message",
		x = w()/2-math.ceil(100*unit/2), 
		y = h()/2-250, 
		w = 100*unit,
		h = 400,
		buttons = {
		{text = "close"},
		{text = "delete"},
		{text = "log"}
		}
	}



	self.desc_list = {
		x = self.frame.x + 32*unit,
		y = self.frame.y + unit,
		w = 67*unit,
		h = self.frame.h - 2*unit,
		title = "details",
		item_height = self.frame.h - 2*unit - 35,
		item_type = "label",
		items = {
			{"this is an awesome ship"}
		}
	}

	self.item_show = {
		title = "messages",
		x = self.frame.x + unit,
		y = self.frame.y + unit,
		w = 30*unit,
		h = self.frame.h - 2*unit,
		item_height = 60,
		item_type = "button",
		items = {},
	}

	for i = 1,30 do
		self.item_show.items[i] = {"test"..i}
	end
	return self
end

function message:update(dt)

	

	local frame = self.frame
	suit.Frame(frame.title,frame,frame.x, frame.y, frame.w,frame.h)


	local des = self.desc_list
	suit.List(des.title,des,des.x, des.y, des.w,des.h)


	if self.frame.buttons[1].reply.hit then
		self.menu.currentWindow = nil
	end

	local item = self.item_show
	suit.List(item.title,item,item.x,item.y,item.w,item.h)
	
end

function message:draw()
	

end


return message