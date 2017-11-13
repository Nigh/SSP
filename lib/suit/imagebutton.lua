-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')

return function(core, normal, ...)
	local opt, x,y,w,h = core.getOptionsAndSize(...)
	opt.normal = normal or opt.normal or opt[1]
	opt.hovered = opt.hovered or opt[2] or opt.normal
	opt.active = opt.active or opt[3] or opt.hovered
	assert(opt.normal, "Need at least `normal' state image")
	opt.id = opt.id or normal

	opt.state = core:registerHitbox(opt.id, x,y,w,h)
	

	local img = opt.normal
	if core:isActive(opt.id) then
		img = opt.active
	elseif core:isHovered(opt.id) then
		img = opt.hovered
	end

	core:registerDraw(opt.draw or function(img,x,y, r,g,b,a)
		love.graphics.setColor(r,g,b,a)
		--love.graphics.setColor(255, 255, 255, 255)
        if opt.quad then
            love.graphics.draw(img,opt.quad,x,y)
            love.graphics.rectangle("line",x,y,w,h)
        else
            love.graphics.draw(img,x,y)
        end
	end, img, x,y, love.graphics.getColor())

	return {
		id = opt.id,
		hit = core:mouseReleasedOn(opt.id),
		hovered = core:isHovered(opt.id),
		entered = core:isHovered(opt.id) and not core:wasHovered(opt.id),
		left = not core:isHovered(opt.id) and core:wasHovered(opt.id)
	}
end
