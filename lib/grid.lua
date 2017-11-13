local grid = {}

local gridSize=64
local screenQuad
local gridCanvas

-- local code=[[
-- 	extern number offx;
-- 	extern number offy;
-- 	extern number gridSize;
-- 	vec4 effect( vec4 color, Image texture, vec2 tc, vec2 sc ){
-- 		float a=abs(mod((sc.x-love_ScreenSize.x/2)+offx,gridSize)/gridSize-0.5);
-- 		float b=abs(mod((sc.y-love_ScreenSize.y/2)+offy,gridSize)/gridSize-0.5);
-- 		return vec4(1,1,1,(0.03+0.2*gridSize/64)*pow((1-a)*(1-b),4.0));
-- 	}
-- ]]

local code=[[
	extern number offx;
	extern number offy;
	extern number gridSize;
	float k;
	vec4 effect( vec4 color, Image texture, vec2 tc, vec2 sc ){
		float a=abs(mod((sc.x-love_ScreenSize.x/2)+offx,gridSize)/gridSize-0.5);
		float b=abs(mod((sc.y-love_ScreenSize.y/2)+offy,gridSize)/gridSize-0.5);
		if(a<b) {k = pow(b*2,4);}
		else {k = pow(a*2,4);}
		return vec4(0.5,0.5,0.5,(0.03+0.2*gridSize/64)*k);
	}
]]

local shader = love.graphics.newShader(code)

function grid.new(cam)
	grid.cam = cam
	grid.canvas = love.graphics.newCanvas()
	shader:send("gridSize",gridSize*grid.cam.scale)
	return grid
end


function grid.draw()
	shader:send("offx",grid.cam.x*grid.cam.scale)
	shader:send("offy",grid.cam.y*grid.cam.scale)
	shader:send("gridSize",gridSize*grid.cam.scale)
	love.graphics.setShader(shader)
	love.graphics.setColor(1,1,1,0)
	love.graphics.rectangle("fill", 0, 0, w(), h())
	love.graphics.setShader()
end

return grid
