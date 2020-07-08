--[[
 * Copyright (C) 2016-2019 Ricky K. Thomson
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

--TODO ADD DEBRIS


starfield = {}
starfield.objects = {}

player.y = 0 --? move this.

starfield.offset = 128              --offset for panning
starfield.w = 1920                  --canvas width
starfield.h = 1080+starfield.offset --canvas height
starfield.limit = 958              --maximum # of objects
starfield.speed = 0                 --current speed
starfield.minspeed = 5              --slowest speed
starfield.maxspeed = 600            --fastest speed
starfield.warpspeed = 220           --speed when warp starts
starfield.spin = false

starfield.hyperspace 	= love.graphics.newImage("data/gfx/starfield/hyperspace.png")
starfield.warp 			= love.graphics.newImage("data/gfx/starfield/warp.png")
starfield.mist 			= love.graphics.newImage("data/gfx/starfield/mist.png")
starfield.star 			= love.graphics.newImage("data/gfx/starfield/star.png")

starfield.planets 		= textures:load("data/gfx/starfield/planets/new/")
--starfield.planets 		= textures:load("data/gfx/starfield/planets/old/")
starfield.planets.populate = true
starfield.planets.limit = 1

starfield.mist_quad = love.graphics.newQuad(0,0, starfield.w, starfield.h, starfield.mist:getDimensions() )
starfield.mist:setWrap("repeat", "repeat")
starfield.mist_scroll = 0

starfield.nova = {}
starfield.nova.sprite = love.graphics.newImage("data/gfx/starfield/nova.png")
starfield.nova.limit = 5

starfield.nebulae = { }
starfield.nebulae.sprite = love.graphics.newImage("data/gfx/starfield/nebulae/proc_sheet_nebula.png")
starfield.nebulae.min = 1
starfield.nebulae.max = 16
starfield.nebulae.size = 512
starfield.nebulae.quads = textures:loadSprite(starfield.nebulae.sprite, starfield.nebulae.size, starfield.nebulae.max )
starfield.nebulae.color = {1,1,1}
starfield.nebulae.populate = true
starfield.nebulae.limit = 0
starfield.nebulae.drawmin = 6
starfield.nebulae.drawmax = 25

starfield.background = {}
starfield.background.color = { 0.0, 0.0, 0.0 }


function starfield:setColor(r,g,b)
	starfield.nebulae.color = { 
		r or love.math.random(10,50)/100,
		g or love.math.random(10,50)/100,
		b or love.math.random(10,50)/100
	}
end

function starfield:populate()


	--object counts
	starfield.count = {
		nebulae = 0,
		star = 0,
		nova = 0,
		planet = 0,
	}

	--reset all entities in the game
	-- (maybe move non starfield objects elsewhere)
	starfield.objects = {}
	enemies.wave = {}
	explosions.objects = {}
	projectiles.missiles = {}
	pickups.items = {}

	starfield.canvas = love.graphics.newCanvas(starfield.w, starfield.h)

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
	
	for _,e in ipairs(enemies.wave) do
		e.xvel = e.xvel + n*5
	end
	
	for _,p in ipairs(pickups.items) do
		p.xvel = p.xvel - n*5
	end
	
	for _,p in ipairs(projectiles.missiles) do
		if p.player == false then
			p.xvel = p.xvel - n*5
		end
	end
end

	
function starfield:addStar(x,y)
	--normal star	
	local vel =  love.math.random(11,15)/10
	local scale = love.math.random(1,15)/10

	table.insert(self.objects, {
		x = x,
		y = y,
		w = self.star:getWidth()*scale,
		h = self.star:getHeight()*scale,
		maxvel = vel,
		minvel = vel,
		name = "star",
		r = love.math.random(0.784,0.960),
		g = love.math.random(0.784,0.960),
		b = love.math.random(0.784,0.960),
		o = love.math.random(2,60) /100,
		gfx = self.star,
		scale = scale,
		
	})
	self.count.star = self.count.star +1
end

function starfield:addNova(x,y)
	--bright star
	if self.count.nova < self.nova.limit then
	local vel =  love.math.random(12,15)/10
	table.insert(self.objects, {
		x = x,
		y = y,
		w = self.nova.sprite:getWidth(),
		h = self.nova.sprite:getHeight(),
		maxvel = vel,
		minvel = vel,
		name = "nova",
		r = love.math.random (0.39,0.8),
		g = love.math.random (0.39,0.8),
		b = love.math.random (0.39,0.8),
		o = love.math.random(0.07,0.25),
		gfx = self.nova.sprite,
		--scale = 1,
	})
	self.count.nova = self.count.nova +1
	end
end	
		
function starfield:addNebula(x,y)
	if self.nebulae.populate then
		--nebula
		if self.count.nebulae < starfield.nebulae.limit then
		
		local scale = love.math.random(9,30)/10
		local vel = love.math.random(10,13)/10
		
		table.insert(self.objects, {
			x = x,
			y = y-(self.nebulae.size*scale)/2,
			w = self.nebulae.size*scale,
			h = self.nebulae.size*scale,
			maxvel = vel,
			minvel = vel,
			name = "nebula",
			r = self.nebulae.color[1]/0.95,
			g = self.nebulae.color[2]/0.95,
			b = self.nebulae.color[3]/0.95,
			o = love.math.random(1.5,2.5)/10,
			gfx = self.nebulae.quads[love.math.random(self.nebulae.min,self.nebulae.max)],
			scale = scale,
			angle = love.math.random(0.0,math.pi*100)/100,
		})
		self.count.nebulae = self.count.nebulae +1
		end
	end
end
	
function starfield:addPlanet(x,y)
	if self.planets.populate then
		if  self.count.planet < starfield.planets.limit then
		local scale = love.math.random(35,100)/100
		local vel = 3
		local gfx  = starfield.planets[love.math.random(1,#starfield.planets)]
		
		table.insert(self.objects, {
			x = x,
			y = y-gfx:getHeight()/2*scale,
			w = gfx:getWidth()*scale,
			h = gfx:getHeight()*scale,
			maxvel = vel,
			minvel = vel,
			yvel = scale,
			name = "planet",
			r = starfield.nebulae.color[1]*1.5,
			g = starfield.nebulae.color[2]*1.5,
			b = starfield.nebulae.color[3]*1.5,
			o = 1,
			gfx = gfx,
			scale = scale,
			angle =  love.math.random(0,math.pi*100)/100,
			atmosphere = self.nebulae.quads[love.math.random(self.nebulae.min,self.nebulae.max)],
			atmosphere_angle = 0,
			atmosphere_speed = 0.05
		})
		self.count.planet = self.count.planet +1
		end
	end
end

function starfield:addobject(x,y)
	local n = love.math.random(0,3)

	if n == 0 then
		self:addNova(x,y)
	elseif n == 1 then
		self:addNebula(x,y)
	elseif n == 2  then
		self:addPlanet(x,y)
	else
		self:addStar(x,y)
	end

end

function starfield:setSeed(seed)
	--generate new random seed
	if not seed then 
		game.seed = love.math.random(1,2^32)
	else
		game.seed = seed
	end

	love.math.setRandomSeed(game.seed)
	starfield:setColor()
	starfield.nebulae.limit = love.math.random(starfield.nebulae.drawmin,starfield.nebulae.drawmax)
	starfield.background.color = { love.math.random(0,8)/100,love.math.random(0,8)/100,love.math.random(0,8)/100 }
	
	
	
end

function starfield:drawPalette(x,y)
	--debug palette
	if mode == "title" then
		love.graphics.setColor(0,0,0,1)
		local size = 50
		local padding = 10
		local x,y = (x or 20),(y or 20)
		love.graphics.rectangle("fill", x,y,size*2+(padding*3),size+(padding*2))
		love.graphics.setColor(0.3,0.3,0.3,1)
		love.graphics.rectangle("line", x,y,size*2+(padding*3),size+(padding*2))
		love.graphics.setColor(starfield.nebulae.color)
		love.graphics.rectangle("fill", x+padding,y+padding,size,size)
		love.graphics.setColor(starfield.background.color)
		love.graphics.rectangle("fill", x+padding+size+padding,y+padding,size,size)
	end
end


function starfield:update(dt)
	if paused then return end

	-- cap starfield speed to limits
	self.speed = math.max(math.min(self.speed,self.maxspeed),self.minspeed)

	--populate starfield
	while #self.objects < self.limit do
		self:addobject(
			self.w,
			love.math.random(self.h)
		)
	end


	-- set conditions based on speed
	if self.speed >= self.warpspeed then
		sound.bgm:setPitch(math.max(0.5,sound.bgm:getPitch() -0.25*dt))
		sound.bgm:setVolume(math.max(1,sound.bgm:getVolume() -1*dt))
		
		self.planets.populate = false
		hud.warp = true 
	else
		sound.bgm:setPitch(math.min(1,sound.bgm:getPitch() +0.5*dt))
		sound.bgm:setVolume(math.min(1,sound.bgm:getVolume() +1*dt))
		
		self.planets.populate = true
		hud.warp = false
	end


	--if mode == "arcade" then
	--	self.offset = player.y
	--end
	
	--process object movement
	for i=#self.objects,1,-1 do
		local o = self.objects[i]
		
		o.x = o.x - ((o.maxvel * self.speed) *dt)
		
		if mode == "arcade" then
			if o.name == "planet" then
				o.scale = o.scale - 0.005 *dt
			end
		end
		
		--[[
		if self.speed >= self.warpspeed then
			if o.name == "nebula" then
				o.scale = o.scale - 0.05 *dt
			end
		end
		--]]
	
		if o.name == "planet" then
		--	if debugarcade then
		--	enemies:rotate(o,0.05,dt)
		--	end
			
			o.atmosphere_angle = o.atmosphere_angle + o.atmosphere_speed *dt
		end	
	
	
	
		-- use similar effect for behind planets (with smoke)
	--[[
		if o.name == "nebula" then
			o.scale = o.scale - 0.05 *dt
			o.angle = o.angle - 0.04 *dt
		end
	--]]
	
	
		if o.x+(o.w) < 0 then
			table.remove(self.objects, i)
			if o.name == "nova" then
				self.count.nova = self.count.nova -1
			elseif o.name == "nebula" then
				self.count.nebulae = self.count.nebulae -1
			elseif o.name == "planet" then
				self.count.planet = self.count.planet -1
			elseif o.name == "star" then
				self.count.star = self.count.star -1
			end
		end
	end

	--mist overlay
	self.mist_scroll = self.mist_scroll - ((self.speed/2 )* dt)
	if self.mist_scroll > self.mist:getWidth() then
		self.mist_scroll = 0
	end
	self.mist_quad:setViewport(-self.mist_scroll,0,self.w,self.h )

end


function starfield:draw(x,y)
	love.graphics.setCanvas(self.canvas)
	--love.graphics.clear()
	
	--background
	if self.speed < self.warpspeed then
		love.graphics.setColor(self.background.color[1],self.background.color[2],self.background.color[3],1)
		love.graphics.rectangle("fill", 0,0,self.w,self.h )
	end

	for _, o in ipairs(self.objects) do
		-- additional mode for pseudo-3d cyclindrical effect 
		-- ps; looks better if planets are unpopulated in starfield.
		if starfield.spin then
			love.graphics.push()
		
			love.graphics.translate(0+love.graphics:getWidth()/2,0+love.graphics:getHeight()/2)
			love.graphics.rotate(math.pi)
			love.graphics.translate(0-love.graphics:getWidth()/2,0-love.graphics:getHeight()/2)
			
			if o.name == "star" then
				love.graphics.setColor(o.r,o.g,o.b,(self.speed > self.warpspeed*2 and o.o / (self.speed/(self.warpspeed*2)) or o.o))
				love.graphics.draw(
					o.gfx, o.x-o.w/2, 
					o.y-o.h/2, 0, o.scale, o.scale
				)
				
			end
			love.graphics.pop()
		end
			
		if o.name == "star" then
			love.graphics.setColor(o.r,o.g,o.b,(self.speed > self.warpspeed*2 and o.o / (self.speed/(self.warpspeed*2)) or o.o))
				love.graphics.draw(
					o.gfx, o.x-o.w/2, 
					o.y-o.h/2, 0, o.scale, o.scale
				)
	
		end
		
		if o.name == "nova" then
			love.graphics.setColor(o.r,o.g,o.b,(self.speed > self.warpspeed*2 and o.o / (self.speed/(self.warpspeed*2)) or o.o))
			love.graphics.draw(
				o.gfx, o.x-o.gfx:getWidth()/2, 
				o.y-o.gfx:getHeight()/2, 0, 1, 1
			)
			love.graphics.setColor(1,1,1,0.392)
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

		if o.name == "nebula" then
			love.graphics.push()
			
			
			love.graphics.setColor(o.r,o.g,o.b,o.o)
			
			if o.gfx then
				love.graphics.translate(o.x+o.w/2,o.y+o.h/2)
				love.graphics.rotate(o.angle or 0)
				love.graphics.translate(-o.x-o.w/2,-o.y-o.h/2)
				
				love.graphics.draw(starfield.nebulae.sprite, o.gfx,  o.x, o.y, 0, o.scale, o.scale)
				
				if debug then
					love.graphics.setColor(0,1,1,0.156)			
					love.graphics.rectangle("line",o.x,o.y,o.w,o.h)
				end
			end
			love.graphics.pop()
			
		end	
	end
	

	
	
	for _, o in ipairs(self.objects) do
		if o.name == "planet" then
			love.graphics.push()

			
			if o.gfx then
				--rotate planet
				love.graphics.translate(o.x+o.w/2, o.y+o.h/2)
				love.graphics.rotate(o.angle or 0)
				love.graphics.translate(-o.x-o.w/2,-o.y-o.h/2)
				
				
				--atmosphere effect (using nebula as placeholder -- make a smoke-like texture for this)
				love.graphics.setColor(o.r,o.g,o.b,o.o/2)
				love.graphics.draw(starfield.nebulae.sprite, o.atmosphere, 
					o.x+o.w/2, 
					o.y+o.h/2, 
					o.atmosphere_angle, 
					o.w/starfield.nebulae.size+0.25, 
					o.h/starfield.nebulae.size+0.25, 
					starfield.nebulae.size/2, 
					starfield.nebulae.size/2 
				)
				love.graphics.setColor(o.r,o.g,o.b,o.o/4)
				love.graphics.draw(starfield.nebulae.sprite, o.atmosphere, 
					o.x+o.w/2, 
					o.y+o.h/2, 
					-o.atmosphere_angle, 
					o.w/starfield.nebulae.size+0.3, 
					o.h/starfield.nebulae.size+0.3, 
					starfield.nebulae.size/2, 
					starfield.nebulae.size/2 
				)
				
				--draw planet
				love.graphics.setColor(o.r,o.g,o.b,o.o)
				love.graphics.draw(o.gfx, o.x, o.y, 0, o.scale, o.scale	)
				
				if debug then
					love.graphics.setColor(0,1,0.39,0.549)			
					love.graphics.rectangle("line", o.x, o.y, o.w, o.h)
				end
			
			end
			love.graphics.pop()
		end	
	end

	--[[ TODO; fix broken color here
	--additional screen colour filter
	love.graphics.setColor(0.307,0.2,0.234,math.min(0.3,math.max(1,starfield.speed/2000)))
	love.graphics.setColor(self.background.color[1],self.background.color[2],self.background.color[3],0.3)
	love.graphics.rectangle("fill",0,0,starfield.w,starfield.h)
	--]]

	--overlay hyperspace effect image
	--love.graphics.setColor(1,1,1,math.min(0.1,starfield.speed/1000))
	--love.graphics.draw(starfield.hyperspace, 0,0, 0, self.w/self.hyperspace:getWidth(), self.h/self.hyperspace:getHeight())
	
	
	--overlay  mist effect 
	love.graphics.setColor(.313,.313,.313,.058)
	love.graphics.draw(self.mist, self.mist_quad, 0,0, 0, self.w/self.mist:getWidth(), self.h/self.mist:getHeight())	
	
	if mode == "arcade" then
		pickups:draw()
		enemies:draw()
		explosions:draw()
		projectiles:draw()
		player:draw()
	end

	love.graphics.setCanvas()
	love.graphics.setColor(1,1,1,1)
	
	love.graphics.push()
	--love.graphics.scale(love.graphics.getWidth()/starfield.w,love.graphics.getHeight()/starfield.h)  
	love.graphics.draw(self.canvas, x, -player.y/10)
	love.graphics.pop()
	
	starfield:drawPalette(40,40)
end

return starfield
