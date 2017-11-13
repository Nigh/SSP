local drawMode={}
drawMode.visible={
	body=true,
	fixture=true,
	contact=false,
	joint=true,
	texture=true,
	bloom=false,
	trace=false,
}

drawMode.defaultStyle= {
		dynamic={100, 200, 255, 255},
		static={100, 100, 100, 255},
		kinematic={100, 255, 200, 255},
		sensor={0,0,-255,0},
		joint={255, 100, 100, 150},
		body={255, 0, 255, 50},
		contact={0,255,255,255}
	}

local gearAngle= {}

local function CreateGear(segments)
	segments = segments or 40
	local vertices = {}
	table.insert(vertices, {0, 0})
	for i=0, segments do
		local angle = (i / segments) * math.pi * 2
		local x = math.cos(angle)+(i%2)*math.cos(angle)*0.7
		local y = math.sin(angle)+(i%2)*math.sin(angle)*0.7
		table.insert(vertices, {x, y})
	end
	return love.graphics.newMesh(vertices, "fan")
end


local gearShape = CreateGear(20)

local getDist = function(x1,y1,x2,y2) return math.sqrt((x1-x2)^2+(y1-y2)^2) end
local getRot  = function (x1,y1,x2,y2) 
	if x1==x2 and y1==y2 then return 0 end 
	local angle=math.atan((x1-x2)/(y1-y2))
	if y1-y2<0 then angle=angle-math.pi end
	if angle>0 then angle=angle-2*math.pi end
	if angle==0 then return 0 end
	return -angle
end
local axisRot = function(x,y,rot) return math.cos(rot)*x-math.sin(rot)*y,math.cos(rot)*y+math.sin(rot)*x  end


local polygonTrans= function(x,y,rot,size,v)
	local tab={}
	for i=1,#v/2 do
		tab[2*i-1],tab[2*i]=axisRot(v[2*i-1],v[2*i],rot)
		tab[2*i-1]=tab[2*i-1]*size+x
		tab[2*i]=tab[2*i]*size+y
	end
	return tab
end



function drawMode.drawBody(body,color)
	local bodyX=body:getX()
	local bodyY=body:getY()
	love.graphics.setColor(color)
	love.graphics.circle("fill", bodyX, bodyY, 4)
end

function drawMode.drawTexture(body,color)
	if not color then color={255,255,255,255} end
	love.graphics.setColor(color)
end

function drawMode.drawFixture(fixture,color)
	local body = fixture:getBody()
	local bodyX=body:getX()
	local bodyY=body:getY()
	local bodyAngle=body:getAngle()
	local shape=fixture:getShape()
	local shapeType = shape:type()
	local shapeR=shape:getRadius()
	
	local width = love.graphics.getLineWidth()
	local c3=color[3]
	
	if shapeType=="CircleShape" then
		color[4]=255
		local fx,fy=shape:getPoint()
		local offx,offy= axisRot(fx,fy,bodyAngle)
		love.graphics.setColor(color)
		love.graphics.circle("line", bodyX+offx, bodyY+offy, shapeR)
		love.graphics.line(bodyX+offx,bodyY+offy,
			bodyX+math.sin(bodyAngle)*shapeR+offx,bodyY-math.cos(bodyAngle)*shapeR+offy)
		color[4]=50
		love.graphics.setColor(color)
		love.graphics.circle("fill", bodyX+offx, bodyY+offy, shapeR)
	elseif shapeType=="ChainShape" or shapeType=="EdgeShape" then
		color[4]=255
		love.graphics.setColor(color)
		love.graphics.line(body:getWorldPoints(shape:getPoints()))
	else
		color[4]=255
		love.graphics.setColor(color)
		love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
		color[4]=50
		love.graphics.setColor(color)
		love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
	end

	color[3]=c3
	love.graphics.setLineWidth(width)
	

end


function drawMode.drawJoint(joint,color)
	love.graphics.setColor(color)
	local jointType=joint:getType()
	if jointType=="distance" then
		local aX,aY,bX,bY=joint:getAnchors()
		local normDist = joint:getLength()
		local dir=1
		local verts={0,0}
		local vertsCount=math.floor(normDist/10)
		local realDist = getDist(aX,aY,bX,bY)
		local abDirection = getRot (bX,bY,aX,aY)
		for i=1,vertsCount do
			dir=-dir
			table.insert(verts, 10*dir)
			table.insert(verts, i*10*realDist/normDist)
		end
		table.insert(verts, 0)
		table.insert(verts, realDist)
		verts=polygonTrans(aX,aY,abDirection,1,verts)
		love.graphics.line(verts)
		love.graphics.line(aX,aY,bX,bY)
		love.graphics.circle("line", aX, aY, 3)
		love.graphics.circle("line", bX, bY, 3)	
	elseif jointType=="weld" then
		local bodyA,bodyB = joint:getBodies()
		local aX,aY = bodyA:getPosition()
		local bX,bY = bodyB:getPosition()
		local abDirection = getRot (bX,bY,aX,aY)
		local dist = getDist(aX,aY,bX,bY)
		local verts={-5,-5,5,-5,5,dist+5,-5,dist+5}
		verts=polygonTrans(aX,aY,abDirection,1,verts)
		love.graphics.polygon("line", verts)
	elseif jointType=="prismatic" then
		local bodyA,bodyB = joint:getBodies()
		local aX,aY= bodyA:getPosition()
		local bX,bY = bodyB:getPosition()
		local jX,jY = joint:getAnchors()
		local abDirection = getRot (bX,bY,aX,aY)
		local lower, upper = joint:getLimits( )
		lower= lower<-200 and -200 or lower
		upper= upper>200 and 200 or upper
		if lower~=-200 then
			love.graphics.line(polygonTrans(jX,jY,abDirection,1,{-10,lower-10,10,lower-10}))
		end

		if upper~=200 then
			love.graphics.line(polygonTrans(jX,jY,abDirection,1,{-10,upper+10,10,upper+10}))
		end
		love.graphics.circle("line", bX,bY,8)
		love.graphics.line(polygonTrans(jX,jY,abDirection,1,{-10,lower-10,-10,upper+10}))
		love.graphics.line(polygonTrans(jX,jY,abDirection,1,{10,lower-10,10,upper+10}))
		love.graphics.line(aX,aY,bX,bY)
		love.graphics.line(jX, jY, aX, aY)
		love.graphics.line(jX, jY, bX, bY)
	elseif jointType=="revolute" then
		local jX,jY=joint:getAnchors()
		local jAngle=joint:getJointAngle( )
		love.graphics.circle("line", jX, jY, 10)
		love.graphics.line(jX-math.cos(jAngle)*10,jY-math.sin(jAngle)*10,
			jX+math.cos(jAngle)*10,jY+math.sin(jAngle)*10)

		local bodyA,bodyB = joint:getBodies()
		local aX,aY = bodyA:getPosition()
		local bX,bY = bodyB:getPosition()
		love.graphics.line(aX,aY,jX,jY)
		love.graphics.line(bX,bY,jX,jY)
	
	elseif jointType=="rope" then
		--print(joint,joint:getType(),joint.getMaxLength)
		if not joint.getMaxLength then return end
		local aX,aY,bX,bY=joint:getAnchors()
		local normDist = joint:getMaxLength()
		local dir=1
		local verts={0,0}
		local vertsCount=math.floor(normDist/10)
		local realDist = getDist(aX,aY,bX,bY)
		local abDirection = getRot (bX,bY,aX,aY)
		local width=5*(normDist-realDist)*dir/realDist
		width = width>5 and 5 or width
		for i=1,vertsCount do
			dir=-dir
			table.insert(verts, width*dir)
			table.insert(verts, i*10*realDist/normDist)
		end
		table.insert(verts, 0)
		table.insert(verts, realDist)
		verts=polygonTrans(aX,aY,abDirection,1,verts)
		love.graphics.line(verts)
		love.graphics.line(aX,aY,bX,bY)
		love.graphics.circle("line", aX, aY, 3)
		love.graphics.circle("line", bX, bY, 3)		
	elseif jointType=="pulley" then
		local aX,aY,bX,bY=joint:getAnchors()
		local aGX,aGY,bGX,bGY = joint:getGroundAnchors()
		love.graphics.circle("line", aX, aY, 3)
		love.graphics.circle("line", bX, bY, 3)
		love.graphics.circle("line", aGX, aGY, 3)
		love.graphics.circle("line", bGX, bGY, 3)
		love.graphics.line(aX, aY, aGX,aGY,bGX,bGY,bX,bY)
	elseif jointType=="wheel" then
		local jX,jY,jbX,jbY=joint:getAnchors()
		local bodyA,bodyB = joint:getBodies()
		local aX,aY = bodyA:getPosition()
		local bX,bY = bodyB:getPosition()
		local realDist = getDist(jbX,jbY,aX,aY)
		local abDirection = getRot (aX,aY,jbX,jbY)
		local normDist = realDist+math.abs(joint:getJointTranslation( ))
		local dir=1
		local verts={0,0}
		local vertsCount=math.floor(normDist/10)
		
		for i=1,vertsCount do
			dir=-dir
			table.insert(verts, 10*dir)
			table.insert(verts, i*10*realDist/normDist)
		end
		table.insert(verts, 0)
		table.insert(verts, realDist)
		verts=polygonTrans(jbX,jbY,abDirection,1,verts)
		love.graphics.line(verts)
		love.graphics.circle("line", jbX, jbY, 8)
		love.graphics.line(polygonTrans(jbX,jbY,abDirection,1,{-10,0,-10,realDist}))
		love.graphics.line(polygonTrans(jbX,jbY,abDirection,1,{10,0 ,10,realDist}))
		love.graphics.line(polygonTrans(jbX,jbY,abDirection,1,{10,0 ,-10,0}))
		love.graphics.line(polygonTrans(jbX,jbY,abDirection,1,{-10,realDist ,10,realDist}))
		--love.graphics.setColor(0, 255, 0, 255)
		--love.graphics.line(jX,jY,jbX,jbY)
	elseif jointType=="gear" then
		if not joint.getJoints then return end
		local j1,j2=joint:getJoints()
		local x1,y1=j1:getAnchors()
		local x2,y2=j2:getAnchors()
		local reactF=joint:getReactionForce(1)
		local reactT=joint:getReactionTorque(1)
		if not gearAngle[joint] then gearAngle[joint]=0 end
		gearAngle[joint]=gearAngle[joint]+reactF/10000+reactT/10000
		love.graphics.line(x1, y1, ((x1+x2)/2)-5,((y1+y2)/2)-5)
		love.graphics.line(x2, y2, ((x1+x2)/2)+5,((y1+y2)/2)+5)
		love.graphics.draw(gearShape, ((x1+x2)/2)-5,((y1+y2)/2)-5,gearAngle[joint],5,5)
		love.graphics.draw(gearShape, ((x1+x2)/2)+5,((y1+y2)/2)+5,-gearAngle[joint],5,5)
	end
end

function drawMode.drawContact(contact,color)
	love.graphics.setColor(color)
	local x1, y1, x2, y2 = contact:getPositions( )
	if x1 then love.graphics.circle("fill", x1, y1, 3) end
	if x2 then love.graphics.circle("fill", x2, y2, 3) end
end




function drawMode.draw(world,colorStyle,offx,offy,offr)
	--helper.editor = helper.editor or editor
	--collectgarbage("stop")
	local _save_w = love.graphics.getLineWidth()
	local _save_j = love.graphics.getLineJoin()
	love.graphics.push( )
	love.graphics.setLineWidth(1.2)
	if offx then
		love.graphics.translate(offx, offy)
		love.graphics.rotate(offr or 0)
	end

	colorStyle=colorStyle or drawMode.defaultStyle
	local bodyList
	local jointList
	local contactList
	if type(world)=="userdata" then
		bodyList=world:getBodyList()
		jointList=world:getJointList()
		contactList=world:getContactList()
	else
		bodyList=world
	end
	-------------------------------------------
	for i=#bodyList,1,-1 do
		if bodyList[i]:isDestroyed() then
			table.remove(bodyList, i)
		end
	end

	------------------update------------------------
	
	for i,body in ipairs(bodyList) do
		if not jointList then
			jointList={}
			for i,joint in ipairs(body:getJointList()) do
				if not table.getIndex(jointList,joint) then
					table.insert(jointList, joint)
				end
			end
		end

		if not contactList then
			contactList={}
			for i,contact in ipairs(body:getContactList()) do
				if not table.getIndex(contactList,contact) then
					table.insert(contactList, contact)
				end
			end
		end
	end
	--------------------------draw-----------------------------------
	love.graphics.setLineJoin( "none" )

	if drawMode.visible.texture then
		for i,body in ipairs(bodyList) do
			drawMode.drawTexture(body)
		end
	end

	if drawMode.visible.body then
		for i,body in ipairs(bodyList) do
			drawMode.drawBody(body,colorStyle.body)
		end
	end


	if drawMode.visible.fixture then
		for i,body in ipairs(bodyList) do
			local bodyType= body:getType()	
			for i,fixture in ipairs(body:getFixtureList()) do
				local color
				if  bodyType=="dynamic" then
					color=colorStyle.dynamic
				elseif bodyType=="static" then
					color=colorStyle.static
				elseif bodyType=="kinematic" then
					color=colorStyle.kinematic
				end
				local color={unpack(color)}
				if  fixture:isSensor() then		
					for i=1,4 do
						color[i]=color[i]-colorStyle.sensor[i]
					end
				end
				drawMode.drawFixture(fixture,color)
			end
		end
	end

	
	if drawMode.visible.joint then
		if jointList then
			for i,joint in ipairs(jointList) do
				drawMode.drawJoint(joint,colorStyle.joint)
			end
		end
	end

	if drawMode.visible.contact then
		if contactList then
			for i,contact in ipairs(contactList) do
				drawMode.drawContact(contact,colorStyle.contact)
			end
		end	
	end

	--helper.script.draw()
	love.graphics.pop( )
	--collectgarbage("collect")
	love.graphics.setLineWidth(_save_w)
	love.graphics.setLineJoin(_save_j)
end

return drawMode
