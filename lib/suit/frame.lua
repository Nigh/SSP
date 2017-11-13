-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')


local vertBuff = {}
local k = 50
local p = 20
local bw = 100
local buffindex = 0

return function(core,title, ...)
	local Panel = core.Panel
	local opt, x,y,w,h = core.getOptionsAndSize(...)
	opt.id = opt.id or title.."frame"
	opt.font = opt.font or love.graphics.getFont()

	local tw = love.graphics.getFont():getWidth(title)
	local th = love.graphics.getFont():getHeight(title)+p
	core:Panel(x,y,w,h)

	local verts = vertBuff[title..buffindex]
	if not verts then
		verts = {x+k-p ,y-th, x+k + tw +p , y-th, x+tw+2*k,y, x,y}
		buffindex = buffindex + 1
		vertBuff[title..buffindex] = verts
	end
	local titleButton = core:Label(title,{polygon =verts,disabled = true },x,y-th,tw+k*2,th)

	local buttons = opt.buttons
	for i,b in ipairs(buttons) do
		local bx = x+w - i*(2*p+bw)
		local by = y+h
		local up = 2*p+bw
		local down = bw
		local verts = vertBuff[i..title..tostring(button)] or {
			bx,by,
			bx+up,by,
			bx+p+bw,by+th,
			bx+p,by+th,
		}
		vertBuff[i..title..tostring(button)] = verts
		b.reply = core:Button(b.text,{polygon = verts},bx,by,up,th)
	end

	return {
		id = opt.id,
		title = titleButton,
	}
end



