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
--	add starfield:update(dt) to love.update()
--  add starfield:draw(x,y) to love.draw(), x/y are position of the canvas

starfield = {}
starfield.objects = {}

starfield.offset = 0 -- populate starfield above/below this amount
--^^^ disabled due to scaling issue (needs fixing)

starfield.w = love.graphics.getWidth()
starfield.h = love.graphics.getHeight()+starfield.offset
starfield.limit = 300
starfield.speed = 1.5
starfield.canvas = love.graphics.newCanvas(starfield.w, starfield.h)
starfield.dense_star = love.graphics.newImage("gfx/glow.png")

starfield.nebulae = { }
starfield.nebulae.quad = love.graphics.newQuad
starfield.nebulae.sprite = love.graphics.newImage("gfx/nebulae/proc_sheet_nebula.png")
starfield.nebulae.min = 1
starfield.nebulae.max = 16
starfield.nebulae.size = 512
starfield.nebulae.quads = { }
starfield.nebulae.quads['nebula'] = { }
starfield.nebulae.r = 255
starfield.nebulae.g = 255
starfield.nebulae.b = 255

local jy = 0
local jx = 0
for n=1,starfield.nebulae.max do		
	starfield.nebulae.quads['nebula'][n] = starfield.nebulae.quad(
		jx, 
		jy, 
		starfield.nebulae.size, 
		starfield.nebulae.size,  
		starfield.nebulae.sprite:getWidth(), 
		starfield.nebulae.sprite:getHeight()
	)
	
	jx = jx + starfield.nebulae.size
	
	if jx >= starfield.nebulae.sprite:getWidth() then 
		jx = 0
		jy = jy + starfield.nebulae.size
	end
end




function starfield:populate()
	--reset
	starfield.objects = {}
	enemies.wave = {}
	ship.projectiles = {}
	pickups.items = {}
	
	--populate starfield
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
		velocity = math.random(40,70) 
		gfx = starfield.dense_star
		r = math.random (100,255)
		g = math.random (100,255)
		b = math.random (100,255)
		o = velocity
	end
	--nebula
	if type == 1 then
		velocity = 40
		gfx = starfield.nebulae.quads['nebula'][math.random(starfield.nebulae.min,starfield.nebulae.max)]
		r = starfield.nebulae.r
		g = starfield.nebulae.g
		b = starfield.nebulae.b
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
	if #self.objects < self.limit then
		self:addobject(
			starfield.w,
			math.random(starfield.h)
		)
	end
	
	if mode == "arcade" then
		self.offset = ship.y
	end
	
	--process object movement
	
	for i=#self.objects,1,-1 do
		local o = self.objects[i]
		
		o.x = o.x - (o.velocity *dt)
		
		if  o.type == 1 then
			if o.x < -starfield.nebulae.size then
				table.remove(self.objects, i)
			end
					
		else
			if o.x < 0 then
				table.remove(self.objects, i)
			end
		end
		
	end

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
		if o.type == 0 then
			love.graphics.setColor(o.r,o.g,o.b,o.o)
			love.graphics.draw(
				o.gfx, o.x-o.gfx:getWidth()/2, 
				o.y-o.gfx:getHeight()/2, 0, 1, 1
			)
			if debug then
				love.graphics.rectangle(
					"line",
					o.x-o.gfx:getWidth()/2, 
					o.y-o.gfx:getHeight()/2,
					o.gfx:getWidth(),
					o.gfx:getHeight()
				)
			end

		end

		--nebulae
		if o.type == 1 then
			love.graphics.setColor(o.r,o.g,o.b,o.o)
			if o.gfx then

			love.graphics.draw(
				starfield.nebulae.sprite, o.gfx,  o.x, 
				o.y-starfield.nebulae.size/2, 0, 1, 1
				
			)
			if debug then
				love.graphics.setColor(0,255,255,40)			
				love.graphics.rectangle(
					"line",
					o.x,
					o.y-starfield.nebulae.size/2,
					starfield.nebulae.size,
					starfield.nebulae.size
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
	
if mode == "arcade" then
	pickups:draw()
	ship:draw()
	enemies:draw()
end

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
	love.graphics.draw(self.canvas, 0,0,0,love.graphics.getWidth()/starfield.w,love.graphics.getWidth()/starfield.w)
	

end
