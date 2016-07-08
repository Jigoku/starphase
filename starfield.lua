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

starfield.offset = 0

-- 326 -- populate starfield this amount higher than screen height
--^^^ disabled due to scaling issue (needs fixing)
starfield.limit = 1000
starfield.speed = 1.5

starfield.dense_star = love.graphics.newImage("gfx/glow.png")
starfield.star = love.graphics.newImage("gfx/star.png")

starfield.nebulae = { }
starfield.nebulae.quad = love.graphics.newQuad
starfield.nebulae.sprite = love.graphics.newImage("gfx/nebulae/proc_sheet_nebula.png")
starfield.nebulae.min = 1
starfield.nebulae.max = 16
starfield.nebulae.size = 512
starfield.nebulae.quads = { }
starfield.nebulae.quads['nebula'] = { }
starfield.nebulae.red = 0
starfield.nebulae.green = 205
starfield.nebulae.blue = 205


-- colour themes
--
-- orange 		255,155,55
-- green/blue 	0,255,255
-- red 			255,55,55
-- pink 		255,100,255
-- blue/orange 	100,100,255

local jy = 0
local jx = 0
for n=1,starfield.nebulae.max do
	--load the sprites from a spritesheet 
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
	starfield.count = {
		nebulae = 0,
		star = 0,
		dense = 0,
		debris = 0,
	}

	--reset all entities
	starfield.objects = {}
	enemies.wave = {}
	explosions.objects = {}
	projectiles.missiles = {}
	pickups.items = {}
	
	starfield.w = love.graphics.getWidth()
	starfield.h = love.graphics.getHeight()+starfield.offset
	starfield.canvas = love.graphics.newCanvas(starfield.w, starfield.h)
	
	--populate starfield
	for i=0,self.limit do
		self:addobject(
			math.random(0, starfield.w),
			math.random(0, starfield.h)
		)
	end
end

function starfield:addStar(x,y)
	--normal star	
	table.insert(self.objects, {
		x = x,
		y = y,
		w = self.star:getWidth(),
		h = self.star:getHeight(),
		velocity = math.random(30,160) * self.speed,
		type = "star",
		r = math.random(170,215),
		g = math.random(170,215),
		b = math.random(170,215),
		o = math.random(10,140),
		gfx = self.star,
		scale = 1
	})
	self.count.star = self.count.star +1
end

function starfield:addDense_star(x,y)
	--dense star
	if self.count.dense < 15 then
	table.insert(self.objects, {
		x = x,
		y = y,
		w = self.dense_star:getWidth(),
		h = self.dense_star:getHeight(),
		velocity = math.random(40,70)  * self.speed,
		type = "dense_star",
		r = math.random (100,255),
		g = math.random (100,255),
		b = math.random (100,255),
		o = math.random(30,70),
		gfx = self.dense_star,
		scale = 1
	})
	self.count.dense = self.count.dense +1
	end
end

function starfield:addDebris(x,y)
	--debris
	if not (mode == "title") then
		table.insert(self.objects, {
			x = x,
			y = y,
			w = self.star:getWidth(),
			h = self.star:getHeight(),
			velocity = 1500  * self.speed,
			type = "debris",
			r = 185,
			g = 185,
			b = 185,
			o = 150,
			gfx = self.star,
			scale = 1
		})
	end
	self.count.debris = self.count.debris +1
end
		
		
function starfield:addNebula(x,y)
	--nebula
	if self.count.nebulae < 15 then
	local scale = math.random(10,15)/10
	table.insert(self.objects, {
		x = x,
		y = y,
		w = self.nebulae.size*scale,
		h = self.nebulae.size*scale,
		velocity = 30  * self.speed,
		type = "nebula",
		r = self.nebulae.red,
		g = self.nebulae.green,
		b = self.nebulae.blue,
		o = math.random(40,90),
		gfx = self.nebulae.quads['nebula'][math.random(self.nebulae.min,self.nebulae.max)],
		scale = scale
	})
	self.count.nebulae = self.count.nebulae +1
	end
end
	
	

function starfield:addobject(x,y)
	local n = math.random(0,100)
	local velocity, type, gfx, r,g,b,o

	if n == 0 then
		self:addDense_star(x,y)
	elseif n == 1 then
		self:addNebula(x,y)
	elseif n > 1 and n < 8 then
		self:addDebris(x,y)
	else
		self:addStar(x,y)
	end

end



function starfield:update(dt)
	if paused then return end

	--populate starfield
	if #self.objects < self.limit then
		self:addobject(
			self.w,
			math.random(self.h)
		)
	end
	
	if mode == "arcade" then
		self.offset = player.y
	end
	
	--process object movement
	
	for i=#self.objects,1,-1 do
		local o = self.objects[i]
		
		o.x = o.x - (o.velocity *dt)
		
		if o.x+o.w < 0 then
			table.remove(self.objects, i)
			if o.type == "dense_star" then
				self.count.dense = self.count.dense -1
			elseif o.type == "nebula" then
				self.count.nebulae = self.count.nebulae -1
			elseif o.type == "debris" then
				self.count.debris = self.count.debris -1
			elseif o.type == "star" then
				self.count.star = self.count.star -1
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
		
		if o.type == "star" then
			love.graphics.setColor(o.r,o.g,o.b,o.o)
			love.graphics.draw(
				o.gfx, o.x-o.gfx:getWidth()/2, 
				o.y-o.gfx:getHeight()/2, 0, 1, 1
			)
		end

		if o.type == "dense_star" then
			love.graphics.setColor(o.r,o.g,o.b,o.o)
			love.graphics.draw(
				o.gfx, o.x-o.gfx:getWidth()/2, 
				o.y-o.gfx:getHeight()/2, 0, 1, 1
			)
			love.graphics.setColor(255,255,255,100)
			love.graphics.draw(
				self.star, o.x-self.star:getWidth()/2, 
				o.y-self.star:getHeight()/2, 0, 1, 1
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

		if o.type == "nebula" then
			love.graphics.setColor(o.r,o.g,o.b,o.o)
			if o.gfx then

			love.graphics.draw(
				starfield.nebulae.sprite, o.gfx,  o.x, 
				o.y-starfield.nebulae.size/2, 0, o.scale, o.scale
				
			)
			if debug then
				love.graphics.setColor(0,255,255,40)			
				love.graphics.rectangle(
					"line",
					o.x,
					o.y-starfield.nebulae.size/2,
					starfield.nebulae.size*o.scale,
					starfield.nebulae.size*o.scale
				)
			end
			
			end
		end
			

		if o.type == "debris" then
			love.graphics.setColor(255,255,255,20)
			love.graphics.line(o.x,o.y, o.x+150,o.y)
		end



	end
	
	if mode == "arcade" then
		pickups:draw()
		
		enemies:draw()
		explosions:draw()
		projectiles:draw()
		player:draw()
	end

	
	love.graphics.setCanvas()

	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.canvas, x,y,0,love.graphics.getWidth()/starfield.w,love.graphics.getWidth()/starfield.w)

end
