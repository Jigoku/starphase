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


-- TODO ADD DEBUG HUD FOR SEED PALLETTE (COLOURS)

starfield = {}
starfield.objects = {}

player.y = 0 --? move this.
starfield.offset = 128
	starfield.w = 1920
	starfield.h = 1080+starfield.offset
	
starfield.limit = 1150
--starfield.limit = 200
starfield.speed = 0
starfield.minspeed = 6   --slowest speed
starfield.maxspeed = 600  --fastest speed
starfield.warpspeed = 220 --speed when warp starts

starfield.hyperspace = love.graphics.newImage("gfx/starfield/hyperspace.png")
starfield.warp = love.graphics.newImage("gfx/starfield/warp.png")
starfield.mist = love.graphics.newImage("gfx/starfield/mist.png")

starfield.star = love.graphics.newImage("gfx/starfield/star.png")
starfield.planets = textures:load("gfx/starfield/planets/")

starfield.planets.populate = true
starfield.planets.limit = 1

starfield.nova = {}
starfield.nova.sprite = love.graphics.newImage("gfx/starfield/nova.png")
starfield.nova.limit = 5
starfield.nova.limit = 5

starfield.nebulae = { }
starfield.nebulae.sprite = love.graphics.newImage("gfx/starfield/nebulae/proc_sheet_nebula.png")
starfield.nebulae.min = 1
starfield.nebulae.max = 16
starfield.nebulae.size = 512
starfield.nebulae.quads = textures:loadSprite(starfield.nebulae.sprite, starfield.nebulae.size, starfield.nebulae.max )
starfield.nebulae.red = 1
starfield.nebulae.green = 1
starfield.nebulae.blue = 1
starfield.nebulae.populate = true
--starfield.nebulae.limit = 5
starfield.nebulae.limit = 6

starfield.background = { 0.0, 0.0, 0.0 }

starfield.background_style = {
	{ 0.0, 0.035, 0.06 }, -- blueish
	{ 0.0, 0.055, 0.07 }, -- greenish
	{ 0.055, 0.055, 0.07 }, -- rustic
	{ 0.055, 0.07, 0.07 }, -- greyish
	{ 0.055, 0.0, 0.00 }, -- red
	{ 0.05,0.05,0.02 } --- amber
	
	-- looks better with BG variation -BUT needs to 
	-- "fade to new colour" when changing seed/warping
}

function starfield:setColor(r,g,b)
	starfield.nebulae.red   = (r or love.math.random(0.25,0.42))
	starfield.nebulae.green = (g or love.math.random(0.25,0.42))
	starfield.nebulae.blue  = (b or love.math.random(0.25,0.42))
end

function starfield:populate()

	starfield.background = starfield.background_style[love.math.random(1,#starfield.background_style)]

	starfield.count = {
		nebulae = 0,
		star = 0,
		nova = 0,
		planet = 0,
	}

	--reset all entities
	starfield.objects = {}
	enemies.wave = {}
	explosions.objects = {}
	projectiles.missiles = {}
	pickups.items = {}

	

	
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
	
	for _,e in ipairs(enemies.wave) do
		e.xvel = e.xvel + n
	end
	
	
	for _,p in ipairs(projectiles.missiles) do
		if p.player == false then
			p.xvel = p.xvel - n
		end
	end
	
end


			
function starfield:addStar(x,y)
	--normal star	
	
	local vel =  love.math.random(11,15)/10
	local scale = love.math.random(0.5,1.5)

	table.insert(self.objects, {
		x = x,
		y = y,
		w = self.star:getWidth(),
		h = self.star:getHeight(),
		maxvel = vel,
		minvel = vel,
		type = "star",
		r = love.math.random(0.784,0.960),
		g = love.math.random(0.784,0.960),
		b = love.math.random(0.784,0.960),
		o = love.math.random(5,120) /255,
		gfx = self.star,
		scale = scale,
		
	})
	self.count.star = self.count.star +1
end

function starfield:addNova(x,y)
	
	if self.count.nova < self.nova.limit then
	local vel =  love.math.random(12,15)/10
	table.insert(self.objects, {
		x = x,
		y = y,
		w = self.nova.sprite:getWidth(),
		h = self.nova.sprite:getHeight(),
		maxvel = vel,
		minvel = vel,
		type = "nova",
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
			type = "nebula",
			r = self.nebulae.red/0.95,
			g = self.nebulae.green/0.95,
			b = self.nebulae.blue/0.95,
			o = love.math.random(0.156,0.370),
			gfx = self.nebulae.quads[love.math.random(self.nebulae.min,self.nebulae.max)],
			scale = scale,
			angle = love.math.random(0.0,math.pi*10)/10,
		})
		self.count.nebulae = self.count.nebulae +1
		end
	end
end
	
	
function starfield:addPlanet(x,y)
	if self.planets.populate then
		if  self.count.planet < starfield.planets.limit then
		local scale = love.math.random(5,30)/10
		local vel = love.math.random(12,12)/6
		local gfx  = starfield.planets[love.math.random(1,#starfield.planets)]
		table.insert(self.objects, {
			x = x,
			y = y-(gfx:getHeight()*scale)/2,
			w = gfx:getWidth()*scale,
			h = gfx:getHeight()*scale,
			maxvel = vel,
			minvel = vel,
			type = "planet",
			r = starfield.nebulae.red*1.5,
			g = starfield.nebulae.green*1.5,
			b = starfield.nebulae.blue*1.5,
			o = 1,
			gfx = gfx,
			scale = scale,
			angle =  love.math.random(0.0,math.pi*10)/10,
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
	elseif n == 2  then
		self:addPlanet(x,y)
	else
		self:addStar(x,y)
	end

end


function starfield:setSeed(seed)
	if not seed then 
		game.seed = love.math.random(0,2^52)
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
			self.w,
			love.math.random(self.h)
		)
	end
	
	self.speed = math.max(math.min(self.speed,self.maxspeed),self.minspeed)
	
	if starfield.speed >= starfield.warpspeed then
		starfield.planets.populate = false
		hud.warp = true 
	else
		starfield.planets.populate = true
		hud.warp = false
	end
	
	--if mode == "arcade" then
	--	self.offset = player.y
	--end
	
	--process object movement
	
	
	for i=#self.objects,1,-1 do
		local o = self.objects[i]


		o.x = o.x - ((o.maxvel * self.speed) *dt)

	--[[
		if o.type == "planet" then
			if debugarcade then
			enemies:rotate(o,0.05,dt)
			end
			
		end	
	--]]

		if o.x+(o.w) < 0 then
			table.remove(self.objects, i)
			if o.type == "nova" then
				self.count.nova = self.count.nova -1
			elseif o.type == "nebula" then
				self.count.nebulae = self.count.nebulae -1
			elseif o.type == "planet" then
				self.count.planet = self.count.planet -1
			elseif o.type == "star" then
				self.count.star = self.count.star -1
			end
		end
	end



	--mist overlay
	self.mist_scroll = self.mist_scroll - ((self.speed/2 )* dt)
	if self.mist_scroll > self.mist:getWidth() then
		self.mist_scroll = 0
	end
	self.mist_quad:setViewport(-self.mist_scroll,0,starfield.w,starfield.h )


end


function starfield:draw(x,y)
		

	love.graphics.setCanvas(self.canvas)
	--love.graphics.clear()
	
	--background
	
	if self.speed < self.warpspeed then
		love.graphics.setColor(self.background[1],self.background[2],self.background[3],1)
		love.graphics.rectangle("fill", 0,0,self.w,self.h )
	end



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

		if o.type == "nebula" then
			love.graphics.push()
			
			
			love.graphics.setColor(o.r,o.g,o.b,(self.speed > self.warpspeed*2 and o.o / (self.speed/(self.warpspeed*2)) or o.o))
			
			if o.gfx then
			
				love.graphics.translate(o.x+o.w/2,o.y+o.h/2)
				love.graphics.rotate(o.angle or 0)
				love.graphics.translate(-o.x-o.w/2,-o.y-o.h/2)
				
				love.graphics.draw(
					starfield.nebulae.sprite, o.gfx,  o.x, 
					o.y, 0, o.scale, o.scale	
				)
				
			if debug then
				love.graphics.setColor(0,1,1,0.156)			
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
	love.graphics.setColor(.313,.313,.313,.058)
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
				love.graphics.setColor(0,1,0.39,0.549)			
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
	
	
	--hyperspace warp test
	if self.speed > self.warpspeed then 
	
		--blue/green
		love.graphics.setColor(0.274,0.431,0.607,math.min(2 *starfield.speed/25,1)/255)
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


	love.graphics.setColor(1,1,1,0.1)
	love.graphics.draw(
		starfield.hyperspace, 0,0, 0, self.w/self.hyperspace:getWidth(), self.h/self.hyperspace:getHeight()
	)

	love.graphics.setCanvas()


	love.graphics.setColor(1,1,1,1)


	love.graphics.push()
	--love.graphics.scale(love.graphics.getWidth()/starfield.w,love.graphics.getHeight()/starfield.h)  
	love.graphics.draw(self.canvas, x, -player.y/10)
	love.graphics.pop()
	

	
	--overlay  hyperspace effect 

			
end

return starfield
