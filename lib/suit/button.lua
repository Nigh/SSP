-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')

return function(core, text, ...)
	local opt, x,y,w,h = core.getOptionsAndSize(...)
	opt.id = opt.id or text
	opt.font = opt.font or love.graphics.getFont()

	w = w or opt.font:getWidth(text) + 4
	h = h or opt.font:getHeight() + 4
	if not opt.disabled then
		opt.state = core:registerHitbox(opt.id, x,y,w,h)
	end
	local drawFunc
	if opt.nodraw then 
		drawFunc = function()  
			local draw = opt.draw or core.theme.Button
			draw(text, opt, x,y,w,h)
		end
	else
		core:registerDraw(opt.draw or core.theme.Button, text, opt, x,y,w,h)
	end
	
	return {
		id = opt.id,
		hit = core:mouseReleasedOn(opt.id),
		hovered = core:isHovered(opt.id),
		entered = core:isHovered(opt.id) and not core:wasHovered(opt.id),
		left = not core:isHovered(opt.id) and core:wasHovered(opt.id),
        drag = core:mouseDragRelease(opt.id),
        draw = drawFunc
	}
end
