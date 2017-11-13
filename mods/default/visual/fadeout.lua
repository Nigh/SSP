local fadeout = {}

function fadeout:init(anticount)
	self.anticount = 2
	self.lines = {}
	return self
end

function fadeout:addLine(ox,oy,tx,ty,color,w)
	table.insert(self.lines,{self.anticount,ox,oy,tx,ty,color,w})
end

function fadeout:update(dt)
	local temp = {}
	for i,line in ipairs(self.lines) do
		line[1] = line[1] - dt
		if line[1]>0 then
			table.insert(temp,line)
		end
	end
	self.lines = temp
end

function fadeout:draw()
	love.graphics.setBlendMode("replace")
	for i,line in ipairs(self.lines) do
		local color = line[6]
		love.graphics.setLineWidth(line[7]*line[1]/self.anticount)
		love.graphics.setColor(line[6][1], line[6][2], line[6][3], 100*line[1]/self.anticount)
		--love.graphics.line(line[2],line[3],line[4],line[5])
		love.graphics.circle("fill", line[2],line[3],line[7]*line[1]/self.anticount/2)
	end
	love.graphics.setLineWidth(1)
	love.graphics.setBlendMode("alpha")
end


return fadeout