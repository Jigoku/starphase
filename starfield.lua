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
starfield.maxspeed = 400  --fastest speed
starfield.warpspeed = 100 --speed when warp starts

starfield.hyperspace = love.graphics.newImage("gfx/starfield/hyperspace.png")
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
starfield.nebulae.quads = loadsprite(starfield.nebulae.sprite, starfield.nebulae.size, starfield.nebulae.max )
starfield.nebulae.red = 255
starfield.nebulae.green = 255
starfield.nebulae.blue = 255
starfield.nebulae.populate = true
starfield.nebulae.limit = 7

starfield.debris = {}
starfield.debris.limit = 150


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
	
	
	starfield.nebulae.red = love.math.random(55,255)
	starfield.nebulae.green = love.math.random(55,255)
	starfield.nebulae.blue = love.math.random(55,255)
	
	starfield.w = game.scale.w
	starfield.h = game.scale.h+starfield.offset
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
	
	local vel =  love.math.random(20,25)/10
	
	table.insert(self.objects, {
		x = x,
		y = y,
		w = self.star:getWidth(),
		h = self.star:getHeight(),
		maxvel = vel,
		minvel = vel,
		type = "star",
		r = love.math.random(170,215),
		g = love.math.random(170,215),
		b = love.math.random(170,215),
		o = love.math.random(5,160),
		gfx = self.star,
		scale = 1,
		
	})
	self.count.star = self.count.star +1
end

function starfield:addNova(x,y)
	--dense star
	if self.speed > self.warpspeed then return end
	if self.count.nova < self.nebulae.limit then
	local vel =  love.math.random(30,35)/10
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
		o = love.math.random(50,80),
		gfx = self.nova,
		scale = 1,
		name = names:getPlanet()
	})
	self.count.nova = self.count.nova +1
	end
end

function starfield:addDebris(x,y)
	--debris
	if self.count.debris < self.debris.limit then
	if self.speed > self.warpspeed then
		local vel = love.math.random(1500,2000)
		table.insert(self.objects, {
			x = x,
			y = y,
			w = love.math.random(100,200),
			--h = self.star:getHeight(),
			maxvel = vel,
			minvel = vel,
			type = "debris",
			r = 140,
			g = love.math.random(200,255),
			b = love.math.random(200,255),
			o = math.min(25 *starfield.speed/100,60),
			--gfx = self.star,
			--scale = 1
		})
		self.count.debris = self.count.debris +1
	end
	end
	
end
		
		
function starfield:addNebula(x,y)
	if self.nebulae.populate then
		--nebula
		if self.count.nebulae < starfield.nebulae.limit then
		
		local scale = love.math.random(9,20)/10
		local vel = love.math.random(15,20)/10
		
		table.insert(self.objects, {
			x = x,
			y = y,
			w = self.nebulae.size*scale,
			h = self.nebulae.size*scale,
			maxvel = vel,
			minvel = vel,
			type = "nebula",
			r = self.nebulae.red,
			g = self.nebulae.green,
			b = self.nebulae.blue,
			o = love.math.random(10,80),
			gfx = self.nebulae.quads[love.math.random(self.nebulae.min,self.nebulae.max)],
			scale = scale,
			rotation = love.math.random(0.0,math.pi*10)/10,
		})
		self.count.nebulae = self.count.nebulae +1
		end
	end
end
	
	
function starfield:addPlanet(x,y)
	if self.planets.populate and self.speed < self.warpspeed then
		if self.count.planet < starfield.planets.limit then
		local scale = love.math.random(10,25)/10
		local vel = 5
		local gfx  = starfield.planets[love.math.random(1,#starfield.planets)]
		table.insert(self.objects, {
			x = x,
			y = y-(gfx:getHeight()*scale)/2,
			w = gfx:getWidth()*scale,
			h = gfx:getHeight()*scale,
			maxvel = vel,
			minvel = vel,
			type = "planet",
			r = love.math.random(50,205),
			g = love.math.random(150,205),
			b = love.math.random(150,205),
			o = 255,
			gfx = gfx,
			scale = scale,
			rotation = (love.math.random(0,1) == 1 and 0.02 or -0.02),
			name = names:getPlanet()
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
		self:addNebula(x,y-starfield.nebulae.size/2)
	elseif n == 2 then
		self:addPlanet(x,y)
	elseif n > 3 and n < 30 then
		self:addDebris(x,y)
	else
		self:addStar(x,y)
	end


end



function starfield:update(dt)
	if paused then return end

	--populate starfield
	while #self.objects < self.limit do
		self:addobject(
			self.w,
			love.math.random(self.h)
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

		if o.x+o.w < 0 then
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
	self.mist_scroll = self.mist_scroll + ((self.speed/2 )* dt)
	if self.mist_scroll > self.mist:getWidth()then
		self.mist_scroll = 0
	end
	self.mist_quad:setViewport(self.mist_scroll,0,starfield.w,starfield.h )


end


function starfield:draw(x,y)
		

	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()
	
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill", 0,0,self.w,self.h )
	
	--hyperspace warp test
	if self.speed > 100 then 
	
	--green/blue
	love.graphics.setColor(100,240,210,math.min(2 *starfield.speed/50,30))
	--pink/purple
	--love.graphics.setColor(255,100,255,math.min(2 *starfield.speed/50,30))
		love.graphics.rectangle("fill",0,0,starfield.w,starfield.h)
	end
	
	love.graphics.setColor(255,255,255,255)

	for _, o in ipairs(self.objects) do
		
		if o.type == "star" then
			love.graphics.setColor(o.r,o.g,o.b,(self.speed > self.warpspeed*2 and o.o / (self.speed/(self.warpspeed*2)) or o.o))
			love.graphics.draw(
					o.gfx, o.x-o.gfx:getWidth()/2, 
					o.y-o.gfx:getHeight()/2, 0, 1, 1
			)
		end

		
		if o.type == "nova" then
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
	love.graphics.setColor(self.nebulae.red,self.nebulae.green,self.nebulae.blue,15)
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
			love.graphics.line(o.x,o.y, o.x+o.w,o.y)
		end
		
		
			if debugstarfield then
				love.graphics.setFont(fonts.labels)
				love.graphics.setColor(200,255,255)
				love.graphics.print((o.name or ""), o.x,o.y)
				love.graphics.setFont(fonts.default)
			end
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
		starfield.hyperspace, 0,0, 0, game.scale.w/starfield.hyperspace:getWidth(), game.scale.h/starfield.hyperspace:getHeight()
	)
	
	love.graphics.setCanvas()
	love.graphics.push()

		--rotate hack? mode select for sidescroll or vertical scroll?
		if game.rotate then
			love.graphics.translate(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
			love.graphics.rotate(-math.pi/2)
			love.graphics.translate(-love.graphics.getWidth()/2,-love.graphics.getHeight()/2)
		end
				
	love.graphics.setColor(255,255,255,255)
	camera:set()
	love.graphics.draw(self.canvas, x,y,0,love.graphics.getWidth()/starfield.w,love.graphics.getWidth()/starfield.w)
	camera:unset()
	

	
	--overlay  hyperspace effect 

	love.graphics.pop()
			
end

return starfield
