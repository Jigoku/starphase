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
starfield.limit = 1140
starfield.speed = 0

starfield.hyperspace = love.graphics.newImage("gfx/starfield/hyperspace.png")
starfield.mist = love.graphics.newImage("gfx/starfield/mist.png")
starfield.nova = love.graphics.newImage("gfx/starfield/nova.png")
starfield.star = love.graphics.newImage("gfx/starfield/star.png")


starfield.planets = textures:load("gfx/starfield/planets/")

starfield.planets.populate = true
starfield.planets.limit = 3

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
starfield.nebulae.limit = 8


-- colour themes
--
-- orange 		255,155,55
-- green/blue 	0,255,255
-- red 			255,55,55
-- pink 		255,100,255
-- blue/orange 	100,100,255



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
	
	local vel =  love.math.random(15,35)/10
	
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
		o = love.math.random(10,200),
		gfx = self.star,
		scale = 1,
	})
	self.count.star = self.count.star +1
end

function starfield:addNova(x,y)
	--dense star
	
	if self.count.nova < starfield.nebulae.limit then
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
		o = love.math.random(30,70),
		gfx = self.nova,
		scale = 1
	})
	self.count.nova = self.count.nova +1
	end
end

function starfield:addDebris(x,y)
	--debris
	if self.speed > 50 then
		local vel = 1500
		table.insert(self.objects, {
			x = x,
			y = y,
			w = self.star:getWidth(),
			h = self.star:getHeight(),
			maxvel = vel,
			minvel = vel,
			type = "debris",
			r = 225,
			g = 225,
			b = 255,
			o = 150,
			gfx = self.star,
			scale = 1
		})
		self.count.debris = self.count.debris +1
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
	if self.planets.populate and self.speed < 100 then
		if self.count.planet < starfield.planets.limit then
		local scale = love.math.random(1,5)/10
		local vel = love.math.random(5,10)
		local gfx  = starfield.planets[love.math.random(1,#starfield.planets)]
		table.insert(self.objects, {
			x = x,
			y = y,
			w = gfx:getWidth()*scale,
			h = gfx:getHeight()*scale,
			maxvel = vel,
			minvel = vel,
			type = "planet",
			r = 100,
			g = love.math.random(150,255),
			b = love.math.random(150,255),
			o = 255,
			gfx = gfx,
			scale = scale,
			rotation = 0.03
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
		--self:addDebris(x,y)
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
	
	self.speed = self.speed + (player.boostspeed or 0)
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
			enemies:rotate(o,o.rotation,dt)
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
	

	
	love.graphics.setColor(255,255,255,255)

	for _, o in ipairs(self.objects) do
		
		if o.type == "star" then
			love.graphics.setColor(o.r,o.g,o.b,o.o)
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
			
			
			love.graphics.setColor(o.r,o.g,o.b,o.o)
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
	love.graphics.setColor(self.nebulae.red,self.nebulae.green,self.nebulae.blue,25)
	--love.graphics.draw(
	--	self.mist, self.mist_quad, 0,0, 0, self.w/self.mist:getWidth(), self.h/self.mist:getHeight()
	--)	


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
			love.graphics.setColor(0,255,255,20)
			love.graphics.line(o.x,o.y, o.x+150,o.y)
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



	
	love.graphics.setCanvas()
	love.graphics.push()

		--rotate hack? mode select for sidescroll or vertical scroll?
		if game.rotate then
			love.graphics.translate(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
			love.graphics.rotate(-math.pi/2)
			love.graphics.translate(-love.graphics.getWidth()/2,-love.graphics.getHeight()/2)
		end
				
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.canvas, x,y,0,love.graphics.getWidth()/starfield.w,love.graphics.getWidth()/starfield.w)

	--overlay  hyperspace effect 
	love.graphics.setColor(255,255,255,20)
	love.graphics.draw(
		starfield.hyperspace, 0,0, 0, game.scale.w/starfield.hyperspace:getWidth(), game.scale.h/starfield.hyperspace:getHeight()
	)
	love.graphics.pop()
end

return starfield
