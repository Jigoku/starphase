--[[
 * Copyright (C) 2016 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 --]]
 
 -- how to use
--  run starfield:populate() once to initialize the canvas 
--	add starfield:update() to love.update()
--  add starfield:draw(x,y) to love.draw(), x/y are position of the canvas

starfield = {}
starfield.objects = {}

--sane defaults
starfield.offset = 512 -- populate starfield above/below this amount
starfield.w = love.graphics.getWidth()
starfield.h = love.graphics.getHeight()+starfield.offset
starfield.limit = 300
starfield.total = 0
starfield.speed = 1.5


starfield.canvas = love.graphics.newCanvas(starfield.w, starfield.h)


starfield.gfx_glow = love.graphics.newImage("gfx/glow.png") -- 100



--fix these table names
	nebulae = { }
	nebulae.quad = love.graphics.newQuad
	nebulae.sprite = love.graphics.newImage("gfx/nebulae/proc_sheet_nebula.png")
	nebulae.min = 1
	nebulae.max = 16
	nebulae.size = 512
	nebulae.quads = { }
	nebulae.quads['nebula'] = { }
	local jy = 0
	local jx = 0
	for n=1,nebulae.max do		
		nebulae.quads['nebula'][n] = nebulae.quad(jx, jy, nebulae.size, nebulae.size,  nebulae.sprite:getWidth(), nebulae.sprite:getHeight())
		jx = jx + nebulae.size
		if jx >= nebulae.sprite:getWidth() then 
		jx = 0
		jy = jy + nebulae.size
		end
	end




function starfield:populate()

	
	--populate initial starfield
	for i=0,self.limit do
		self:addobject(
			math.random(0, starfield.w),
			math.random(0, starfield.h)
		)
	end
end



function starfield:addobject(x,y)
	local type = math.random(0,100)
	local velocity = math.random(40,100)
	local gfx
	
	--normal star
	local r = math.random(200,255)
	local g = math.random(200,255)
	local b = math.random(200,255)
	local o = velocity
	
	--dense star
	if type == 0 then
		velocity = math.random(40,90) 
		r = math.random (100,255)
		g = math.random (100,255)
		b = math.random (100,255)
		o = velocity
	end
	--nebula
	if type == 1 then
		velocity = 40
		gfx = nebulae.quads['nebula'][math.random(nebulae.min,nebulae.max)]
		r = math.random (100,255)
		g = math.random (100,255)
		b = math.random (100,255)
		o = math.random(40,100)
	end
	
	--debris
	if type > 1 and type < 6 then
		velocity = 1500
	end
	

		
	table.insert(self.objects, {
		x = x,
		y = y,
		velocity = velocity * self.speed,
		type = type,
		r = r or 255,
		g = g or 255,
		b = b or 255,
		gfx = gfx or nil,
		o = o or nil,
	})
end



function starfield:update(dt)
	if paused then return end

	--populate starfield
	if self.total < self.limit then
		self:addobject(
			starfield.w,
			math.random(starfield.h)
		)
	end
	self.offset = ship.y+ship.gfx:getHeight()/2 
	
	--process object movement
	local n = 0
	
	for i=#self.objects,1,-1 do
		local o = self.objects[i]
		
		n = n +1 
		o.x = o.x - (o.velocity *dt)
		
		if  o.type == 1 then
			if o.x < -nebulae.size then
				table.remove(self.objects, i)
			end
					
			
		else
			if o.x < 0 then
				table.remove(self.objects, i)
			end
		end
		
	end

	self.total = n 
	

end


function starfield:draw(x,y)

	love.graphics.setCanvas(self.canvas)
	starfield.canvas:clear()
	
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill", 0,0,self.w,self.h )
	

	
	love.graphics.setColor(255,255,255,255)

	for _, o in ipairs(self.objects) do
	
		--star
		love.graphics.setColor(o.r,o.g,o.b,o.o*1.5)
		love.graphics.line(o.x,o.y, o.x,o.y+1)

		--dense star
		if o.type == 100 then
			love.graphics.setColor(o.r,o.g,o.b,o.o)
			love.graphics.draw(
				starfield.gfx_glow, o.x-self.gfx_glow:getWidth()/2, 
				o.y-self.gfx_glow:getHeight()/2, 0, 1, 1
			)
			if debug then
				love.graphics.rectangle(
					"line",
					o.x-self.gfx_glow:getWidth()/2, 
					o.y-self.gfx_glow:getHeight()/2,
					self.gfx_glow:getWidth(),
					self.gfx_glow:getHeight()
				)
			end

		end

		--nebulae
		if o.type == 1 then
			love.graphics.setColor(0,255,255,o.o)
			if o.gfx then

			love.graphics.draw(
				nebulae.sprite, o.gfx,  o.x, 
				o.y-nebulae.size/2, 0, 1, 1
				
			)
			if debug then
				love.graphics.setColor(0,255,255,40)			
				love.graphics.rectangle(
					"line",
					o.x,
					o.y-nebulae.size/2,
					nebulae.size,
					nebulae.size
				)
			end
			
			end
		end
			
		--debris
		if o.type > 1 and o.type < 6 then
			love.graphics.setColor(255,255,255,20)
			love.graphics.line(o.x,o.y, o.x+150,o.y)
		end

	end

	enemies:draw()

	--ship projectiles (player)
	for _, p in ipairs (ship.projectiles) do
		love.graphics.setColor(p.r,p.g,p.b,255)

		love.graphics.draw(
				ship.cannon.texture,  p.x, 
				p.y, 0, 1, 1
				
			)
		if debug then
			love.graphics.setColor(p.r,p.g,p.b,140)			
				love.graphics.rectangle(
					"line",
					p.x,
					p.y,
					p.w,
					p.h
				)
		end
		
	end
	
	love.graphics.setCanvas()

	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.canvas, 0,-self.offset/2)
	
	

	
end
