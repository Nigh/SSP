local exchange = {}
local unit
function exchange:init(ui,menu)
	self.ui = ui
	self.ship = ui.ship
	self.hud = ui.hud
	self.color = ui.color
	self.menu = menu
	unit = self.ui.unit

	self.frame = {
		title = "exchange center No. 12321",
		x = w()/2-60*unit, 
		y = h()/2-250, 
		w = 120*unit,
		h = 400,
		buttons = {
		{text = "close"},
		{text = "check"}
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


	self.item_show = {
		title = "stockage",
		x = self.frame.x + 76*unit,
		y = self.frame.y + unit,
		w = 43*unit,
		h = self.frame.h - 2*unit,
		item_height = 60,
		item_type = "button",
		items = {},
	}

	for i = 1,30 do
		self.item_show.items[i] = {"item test"..i}
	end

	self.shop_show = {
		title = "shop",
		x = self.frame.x + 32*unit,
		y = self.frame.y + unit,
		w = 43*unit,
		h = self.frame.h - 2*unit,
		item_height = 60,
		item_type = "button",
		items = {},
	}

	for i = 1,30 do
		self.shop_show.items[i] = {"shop test"..i}
	end

	return self
end

function exchange:update(dt)

	

	local frame = self.frame
	suit.Frame(frame.title,frame,frame.x, frame.y, frame.w,frame.h)


	local des = self.desc_list
	suit.List(des.title,des,des.x, des.y, des.w,des.h)

	local item = self.item_show
	suit.List(item.title,item,item.x, item.y, item.w,item.h)

	local shop = self.shop_show
	suit.List(shop.title,shop,shop.x, shop.y, shop.w,shop.h)


	if self.frame.buttons[1].reply.hit then
		self.menu.currentWindow = nil
	end
	
end

function exchange:draw()
	

end


return exchange