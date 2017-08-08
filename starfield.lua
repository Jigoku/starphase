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

local starfield = {}
starfield.objects = {}

starfield.offset = 0

-- 326 -- populate starfield this amount higher than screen height
--^^^ disabled due to scaling issue (needs fixing)
starfield.limit = 1150
starfield.speed = 0
starfield.minspeed = 10   --slowest speed
starfield.maxspeed = 600  --fastest speed
starfield.warpspeed = 100 --speed when warp starts

starfield.hyperspace = love.graphics.newImage("gfx/starfield/hyperspace.png")
starfield.warp = love.graphics.newImage("gfx/starfield/warp.png")
starfield.mist = love.graphics.newImage("gfx/starfield/mist.png")
starfield.nova = love.graphics.newImage("gfx/starfield/nova.png")
starfield.star = love.graphics.newImage("gfx/starfield/star.png")
starfield.planets = textures:load("gfx/starfield/planets/")

starfield.planets.populate = true
starfield.planets.limit = 1

starfield.nebulae = { }
starfield.nebulae.sprite = love.graphics.newImage("gfx/starfield/nebulae/proc_sheet_nebula.png")
starfield.nebulae.min = 1
starfield.nebulae.max = 16
starfield.nebulae.size = 512
starfield.nebulae.quads = textures:loadSprite(starfield.nebulae.sprite, starfield.nebulae.size, starfield.nebulae.max )
starfield.nebulae.red = 255
starfield.nebulae.green = 255
starfield.nebulae.blue = 255
starfield.nebulae.populate = true
starfield.nebulae.limit = 6

starfield.debris = {}
starfield.debris.limit = 0

starfield.background = { 10, 20, 20 }

function starfield:setColor(r,g,b)
	starfield.nebulae.red = (r or love.math.random(50,255))
	starfield.nebulae.green = (g or love.math.random(50,255))
	starfield.nebulae.blue = (b or love.math.random(50,255))
end

function starfield:populate()
	starfield.count = {
		nebulae = 0,
		star = 0,
		nova = 0,
		debris = 0,
		planet = 0,
	}

	--reset all entities
	starfield.objects = {}
	enemies.wave = {}
	explosions.objects = {}
	projectiles.missiles = {}
	pickups.items = {}

	
	starfield.w = love.graphics.getWidth()
	starfield.h = love.graphics.getHeight()
	
	starfield.canvas = love.graphics.newCanvas(starfield.w, starfield.h)
	starfield.mist_quad = love.graphics.newQuad(0,0, starfield.w, starfield.h, starfield.mist:getDimensions() )
	starfield.mist:setWrap("repeat", "repeat")
	starfield.mist_scroll = 0

	--populate starfield
	while #starfield.objects <  self.limit do
		self:addobject(
			love.math.random(0, starfield.w),
			love.math.random(0, starfield.h)
		)
	end
end


function starfield:speedAdjust(n,dt)
	self.speed = math.max(self.speed +n,0)
	for _,o in ipairs(self.objects) do
		if o.maxvel > o.minvel then
			o.maxvel = math.max(o.maxvel +n, o.minvel)
		end
	end
	
end


			
function starfield:addStar(x,y)
	--normal star	
	
	local vel =  love.math.random(12,15)/10
	local scale = love.math.random(0.5,1.5)
	table.insert(self.objects, {
		x = x,
		y = y,
		w = self.star:getWidth(),
		h = self.star:getHeight(),
		maxvel = vel,
		minvel = vel,
		type = "star",
		r = love.math.random(200,245),
		g = love.math.random(200,245),
		b = love.math.random(200,245),
		o = love.math.random(5,160),
		gfx = self.star,
		scale = scale,
		
	})
	self.count.star = self.count.star +1
end

function starfield:addNova(x,y)
	--dense star
	--if self.speed > self.warpspeed then return end
	if self.count.nova < self.nebulae.limit then
	local vel =  love.math.random(12,15)/10
	table.insert(self.objects, {
		x = x,
		y = y,
		w = self.nova:getWidth(),
		h = self.nova:getHeight(),
		maxvel = vel,
		minvel = vel,
		type = "nova",
		r = love.math.random (100,255),
		g = love.math.random (100,255),
		b = love.math.random (100,255),
		o = love.math.random(20,80),
		gfx = self.nova,
		scale = 1,
	})
	self.count.nova = self.count.nova +1
	end
end

function starfield:addDebris(x,y)

	--debris
	if self.count.debris < self.debris.limit then
	--if self.speed > self.warpspeed then
		local vel = love.math.random(1000,1500) 
		local w = love.math.random(100,200)
		table.insert(self.objects, {
			x = x+w,
			y = y,
			w = w,
			h = 1,
			maxvel = vel,
			minvel = vel,
			type = "debris",
			r = 140,
			g = love.math.random(200,255),
			b = love.math.random(200,255),
			o = math.min(20 *starfield.speed/100,40),
			gfx = self.warp,
			scale = 1
		})
		self.count.debris = self.count.debris +1
	--end
	end

end
		
		
function starfield:addNebula(x,y)
	if self.nebulae.populate then
		--nebula
		if self.count.nebulae < starfield.nebulae.limit then
		
		local scale = love.math.random(9,20)/10
		local vel = love.math.random(10,15)/10
		
		table.insert(self.objects, {
			x = x,
			y = y-(self.nebulae.size*scale)/2,
			w = self.nebulae.size*scale,
			h = self.nebulae.size*scale,
			maxvel = vel,
			minvel = vel,
			type = "nebula",
			r = self.nebulae.red,
			g = self.nebulae.green,
			b = self.nebulae.blue,
			o = love.math.random(40,120),
			gfx = self.nebulae.quads[love.math.random(self.nebulae.min,self.nebulae.max)],
			scale = scale,
			rotation = love.math.random(0.0,math.pi*10)/10,
		})
		self.count.nebulae = self.count.nebulae +1
		end
	end
end
	
	
function starfield:addPlanet(x,y)
	if self.planets.populate then
		if self.speed < self.warpspeed and self.count.planet < starfield.planets.limit then
		local scale = love.math.random(10,25)/10
		local vel = love.math.random(2,3)
		local gfx  = starfield.planets[love.math.random(1,#starfield.planets)]
		table.insert(self.objects, {
			x = x+(gfx:getHeight()*scale),
			y = y-(gfx:getWidth()*scale)/2,
			w = gfx:getWidth()*scale,
			h = gfx:getHeight()*scale,
			maxvel = vel,
			minvel = vel,
			type = "planet",
			r = love.math.random(50,150),
			g = love.math.random(50,150),
			b = love.math.random(50,150),
			o = 255,
			gfx = gfx,
			scale = scale,
			rotation = (love.math.random(0,1) == 1 and 0.02 or -0.02),
		})
		self.count.planet = self.count.planet +1
		end
	end
end


function starfield:addobject(x,y)

	local n = love.math.random(0,100)
	

	if n == 0 then
		self:addNova(x,y)
	elseif n == 1 then
		self:addNebula(x,y)
	elseif n == 2 then
		self:addPlanet(x,y)
	elseif n > 3 and n < 30 then
		self:addDebris(x,y)
	else
		self:addStar(x,y)
	end


end


function starfield:setSeed(seed)
	if not seed then 
		game.seed = love.math.random(0,9999999999)
	else
		game.seed = seed
	end
	
	love.math.setRandomSeed(game.seed)
	
	starfield:setColor()
end


function starfield:update(dt)
	if paused then return end

	--populate starfield
	while #self.objects < self.limit do
		self:addobject(
			self.w,love.math.random(self.h)
		)
	end
	
	self.speed = math.max(math.min(self.speed,self.maxspeed),self.minspeed)
	--if mode == "arcade" then
	--	self.offset = player.y
	--end
	
	--process object movement
	
	
	for i=#self.objects,1,-1 do
		local o = self.objects[i]

		if o.type == "debris" then
			o.x = o.x - (o.maxvel *dt)
		else
			o.x = o.x - ((o.maxvel * self.speed) *dt)
		end

		if o.type == "planet" then
			enemies:rotate(o,o.rotation/o.scale,dt)
		end	

		if o.x+(o.w*(o.scale)) < 0 then
			table.remove(self.objects, i)
			if o.type == "nova" then
				self.count.nova = self.count.nova -1
			elseif o.type == "nebula" then
				self.count.nebulae = self.count.nebulae -1
			elseif o.type == "debris" then
				self.count.debris = self.count.debris -1
			elseif o.type == "planet" then
				self.count.planet = self.count.planet -1
			elseif o.type == "star" then
				self.count.star = self.count.star -1
			end
		end
	end



	--mist overlay
	self.mist_scroll = self.mist_scroll - ((self.speed/2 )* dt)
	if self.mist_scroll > self.mist:getWidth()then
		self.mist_scroll = 0
	end
	self.mist_quad:setViewport(-self.mist_scroll,0,starfield.w,starfield.h )


end


function starfield:draw(x,y)
		

	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()
	
	--background
	love.graphics.setColor(self.background[1],self.background[2],self.background[3],255)
	love.graphics.rectangle("fill", 0,0,self.w,self.h )
	

	
	love.graphics.setColor(255,255,255,255)

	for _, o in ipairs(self.objects) do
		
		if o.type == "star" then
			love.graphics.setColor(o.r,o.g,o.b,(self.speed > self.warpspeed*2 and o.o / (self.speed/(self.warpspeed*2)) or o.o))
			love.graphics.draw(
					o.gfx, o.x-o.gfx:getWidth()/2, 
					o.y-o.gfx:getHeight()/2, 0, o.scale, o.scale
			)
		end

		
		if o.type == "nova" then
			love.graphics.setColor(o.r,o.g,o.b,(self.speed > self.warpspeed*2 and o.o / (self.speed/(self.warpspeed*2)) or o.o))
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
				love.graphics.setColor(o.r,o.g,o.b,o.o)
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
			love.graphics.push()
			
			
			love.graphics.setColor(o.r,o.g,o.b,(self.speed > self.warpspeed*2 and o.o / (self.speed/(self.warpspeed*2)) or o.o))
			
			if o.gfx then
			
				love.graphics.translate(o.x+o.w/2,o.y+o.h/2)
				love.graphics.rotate(o.rotation or 0)
				love.graphics.translate(-o.x-o.w/2,-o.y-o.h/2)
				
				love.graphics.draw(
					starfield.nebulae.sprite, o.gfx,  o.x, 
					o.y, 0, o.scale, o.scale	
				)
				
			if debug then
				love.graphics.setColor(0,255,255,40)			
				love.graphics.rectangle(
					"line",
					o.x,
					o.y,
					o.w,
					o.h
				)
			end
			
			love.graphics.pop()
			
			end
		end	
		

	end
	
	--overlay  mist effect 
	love.graphics.setColor(80,80,80,15)
	love.graphics.draw(
		self.mist, self.mist_quad, 0,0, 0, self.w/self.mist:getWidth(), self.h/self.mist:getHeight()
	)	





--top layer
	for _, o in ipairs(self.objects) do
		
		if o.type == "planet" then
			love.graphics.push()
			
			
			love.graphics.setColor(o.r,o.g,o.b,o.o)
			if o.gfx then
			
				love.graphics.translate(o.x+o.w/2,o.y+o.h/2)
				love.graphics.rotate(o.angle or 0)
				love.graphics.translate(-o.x-o.w/2,-o.y-o.h/2)
				
				love.graphics.draw(
					o.gfx,  o.x, 
					o.y, 0, o.scale, o.scale	
				)
				
			if debug then
				love.graphics.setColor(0,255,100,140)			
				love.graphics.rectangle(
					"line",
					o.x,
					o.y,
					o.w,
					o.h
				)
			end
			
			love.graphics.pop()
		

			end
		end	
		
		
		if o.type == "debris" then
			love.graphics.setColor(o.r,o.g,o.b,o.o)
			
			love.graphics.draw(o.gfx, o.x,o.y,0,1,1)
			--love.graphics.line(o.x,o.y, o.x+o.w,o.y)
		end
		
		

	end
	
	
				--hyperspace warp test
	if self.speed > self.warpspeed then 
	
	--blue/green
	love.graphics.setColor(70,110,155,math.min(2 *starfield.speed/25,255))
	--green/blue
	--love.graphics.setColor(100,240,210,math.min(2 *starfield.speed/50,30))
	--pink/purple
	--love.graphics.setColor(255,100,255,math.min(2 *starfield.speed/25,255))
		love.graphics.rectangle("fill",0,0,starfield.w,starfield.h)
	end
	
	if mode == "arcade" then
	-- move this
		pickups:draw()
		
		enemies:draw()
		explosions:draw()
		projectiles:draw()
		player:draw()
		

	end


	love.graphics.setColor(255,255,255,20)
	love.graphics.draw(
		starfield.hyperspace, 0,0, 0, self.w/self.hyperspace:getWidth(), self.h/self.hyperspace:getHeight()
	)
	
	love.graphics.setCanvas()


	love.graphics.setColor(255,255,255,255)

	love.graphics.draw(self.canvas, x,y)

	

	
	--overlay  hyperspace effect 

			
end

return starfield
