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
 
ship = {}
ship.projectiles = {}
ship.sounds = {}



ship.type = 3
ship.gfx = love.graphics.newImage("gfx/starship/"..ship.type.."_small.png") -- default


ship.cannon = {}
ship.cannon.texture = love.graphics.newImage("gfx/projectiles/cannon.png")
ship.cannon.switch = false -- alternating sides

ship.cannon.sound = {}
ship.cannon.sound.shoot = love.audio.newSource("sfx/projectiles/shoot.wav", "static")
ship.cannon.sound.shoot:setVolume(0.3)






function ship:init()
	ship.x = love.graphics.getWidth()/3
	ship.y = love.graphics.getHeight()/2-ship.gfx:getHeight()/2
	ship.w = ship.gfx:getWidth()
	ship.h = ship.gfx:getHeight()
	ship.shield = 100
	ship.shieldmax = 100
	ship.energy = 60
	ship.energymax = 100

	ship.projectileCycle = 0
	ship.projectileDelay = 0.3

	ship.speed = 600
	ship.float = 3
	ship.maxvel = 250
	ship.xvel = 0
	ship.yvel = 0
	ship.idle = true
end

function ship:update(dt)
	if paused then return end
	self.idle = true

	if love.keyboard.isDown(binds.up, binds.altup) then 
		self.yvel = self.yvel - self.speed * dt
		self.idle = false
	end
	if love.keyboard.isDown(binds.down, binds.altdown) then 
		self.yvel = self.yvel + self.speed * dt
		self.idle = false
	end
	if love.keyboard.isDown(binds.left, binds.altleft) then 
		self.xvel = self.xvel - self.speed * dt
		self.idle = false
	end
	if love.keyboard.isDown(binds.right, binds.altright) then 
		self.xvel = self.xvel + self.speed * dt
		self.idle = false
	end



	
	if self.idle then
		if self.yvel ~= 0 then
			if self.yvel > 0 then
				self.yvel = self.yvel - (self.speed/self.float) *dt
				if self.yvel < 0 then self.yvel = 0 end
				
			elseif ship.yvel < 0 then
				self.yvel = self.yvel + (self.speed/self.float) *dt
				if self.yvel > 0 then self.yvel = 0 end
			end
		end

		if self.xvel ~= 0 then
			if self.xvel > 0 then
				self.xvel = self.xvel - (self.speed/self.float) *dt
				if self.xvel < 0 then self.xvel = 0 end
				
			elseif self.xvel < 0 then
				self.xvel = self.xvel + (self.speed/self.float) *dt
				if self.xvel > 0 then self.xvel = 0 end
			end
		end
	end
	
	
	
	if self.yvel > self.maxvel then self.yvel = self.maxvel	end
	if self.xvel > self.maxvel then self.xvel = self.maxvel end
	if self.yvel < -self.maxvel then self.yvel = -self.maxvel end
	if self.xvel < -self.maxvel+(self.maxvel/6) then self.xvel = -self.maxvel+(self.maxvel/6) end


	self.y = self.y + self.yvel * dt
	self.x = self.x + self.xvel * dt

	if self.x < 0 - self.gfx:getWidth()/2  then 
		self.x = 0 - self.gfx:getWidth()/2	
		self.xvel = 0
	end
	if self.x > love.graphics.getWidth()-self.gfx:getWidth()/2  then 
		self.x = love.graphics.getWidth()-self.gfx:getWidth()/2	
		self.xvel = 0
	end
	
	if self.y < 0 - self.gfx:getHeight()/2  then 
		self.y = 0 - self.gfx:getHeight()/2	
		self.yvel = 0
	end
	if self.y > love.graphics.getHeight()-self.gfx:getWidth()/2  then 
		self.y = love.graphics.getHeight()-self.gfx:getWidth()/2	
		self.yvel = 0
	end
	

	
	

	
	
	if love.keyboard.isDown(binds.shoot) or love.mouse.isDown("l") then

		
		self.projectileCycle = math.max(0, self.projectileCycle - dt)
		
		if self.projectileCycle <= 0 then
			if self.cannon.sound.shoot:isPlaying() then
				self.cannon.sound.shoot:stop()
			end
			self.cannon.sound.shoot:play()
		
			ship.cannon.switch = not ship.cannon.switch
		
			local yswitch
			if ship.cannon.switch then
				yswitch = self.y + starfield.offset/2+self.gfx:getHeight()/2-ship.cannon.texture:getHeight()/2 -36
			else
				yswitch = self.y + starfield.offset/2+self.gfx:getHeight()/2-ship.cannon.texture:getHeight()/2 +36
			end
			
			table.insert(self.projectiles, {
				w = ship.cannon.texture:getWidth(),
				h = ship.cannon.texture:getHeight(),
				x = self.x + self.gfx:getWidth()/2,
				y = yswitch,
				xvel = 1000,
				yvel = 0,
				damage = 40,
				r = math.random(150,255),
				g = math.random(150,255),
				b = math.random(150,255),
			})
		
			self.projectileCycle = self.projectileDelay
		end
	end
	
	
	if love.keyboard.isDown(binds.special) then

	end
	
	
	--process projectiles movement
	
	for i=#self.projectiles,1,-1 do
		local p = self.projectiles[i]
		

		p.x = p.x + math.floor(p.xvel *dt)
		
		if p.x + p.w > love.graphics.getWidth() + 256 then
				table.remove(self.projectiles, i)
		end
	end

	
	if ship.shield <= 0 then
		title:init()
		
	end
	


end

function ship:draw()
	

	love.graphics.push()
	love.graphics.setColor(255,255,255,255)
	
	love.graphics.draw(
		self.gfx, self.x, 
		self.y, 0, 1, 1
	)


	if debug then
		love.graphics.setColor(255,255,0,100)
		love.graphics.rectangle("line", self.x,self.y, self.gfx:getWidth(),self.gfx:getHeight())
	end
	
	love.graphics.pop()
end
