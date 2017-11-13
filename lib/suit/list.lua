-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')
local title_height = 30
local slider_width = 30
local spacing = 5

local drawFunc = function(itemsDraws,item_quad)
	love.graphics.setScissor(item_quad.x,item_quad.y,item_quad.w,item_quad.h)
	for i,v in ipairs(itemsDraws) do
		v()
	end
	love.graphics.setScissor()
end


return function(core,title, ...)
	local opt, x,y,w,h = core.getOptionsAndSize(...)
	opt.id = title or opt.id
	opt.font = opt.font or love.graphics.getFont()
    
	
    --opt.state = core:registerHitbox(opt.id, x,y,w,h)

	local item_quad = {
		x = x,
		y = y+title_height,
		w = w - slider_width,
		h = h - title_height
	}
	core:Panel(x,y,w,h)
	local titleButton = core:Label(title,x,y,w,title_height)

	if #opt.items*(opt.item_height+spacing) > item_quad.h then
		opt.info = opt.info or {
			min = 0,
			max = #opt.items*(opt.item_height+spacing) - item_quad.h,
			value = 0,	
		}

		opt.offy = opt.offy or 0
		local slider = core:Slider(opt.info,{vertical = true},x+w-slider_width,y + title_height+8, slider_width,h -title_height-16)
	else
		item_quad.w = w
	end
	local itemsDraws = {}
	for i = 1, #opt.items do
		if opt.item_type == "button" then
			local reply = core:Button(opt.items[i][1],{nodraw = true},
				item_quad.x,item_quad.y + spacing*i + (i-1)*opt.item_height - (opt.info and opt.info.value or 0),
				item_quad.w,opt.item_height)
			itemsDraws[i] = reply.draw 
			opt.items[i].reply = reply
		elseif opt.item_type == "label" then
			local reply =core:Label(opt.items[i][1],{nodraw = true},
				item_quad.x,item_quad.y + spacing*i + (i-1)*opt.item_height - (opt.info and opt.info.value or 0),
				item_quad.w,opt.item_height)
			itemsDraws[i] = reply.draw 
			opt.items[i].reply = reply
		end
	end
	core:registerDraw(function()drawFunc(itemsDraws,item_quad)end)
	--[[
	return {
		id = opt.id,
    --    drag = core:mouseDragRelease(opt.id)
	}]]
end
