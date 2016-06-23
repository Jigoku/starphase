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
 
player = {}
player.sounds = {}

player.cannon = {}
player.cannon.switch = false -- alternating sides

function player:init(playersel)
	player.type = playersel
	player.gfx = love.graphics.newImage("gfx/starship/"..player.type.."_small.png") -- default

	player.x = love.graphics.getWidth()/3
	player.y = love.graphics.getHeight()/2-player.gfx:getHeight()/2
	player.w = player.gfx:getWidth()
	player.h = player.gfx:getHeight()
	player.shield = 100
	player.shieldmax = 100
	player.energy = 100
	player.energymax = 100
	player.speed = 1500
	player.speedmax = 3000
	
	player.lives = 3
	player.projectileCycle = 0
	player.projectileDelay = 0.14
	player.secondaryCycle = 0
	player.secondaryDelay = 0.05
	
	player.respawnCycle = 3
	player.respawnDelay = 3
	player.alive = true
	player.float = 2
	player.maxvel = 400
	player.xvel = 0
	player.yvel = 0
	player.idle = true
	player.invincible = false
	
	if cheats.invincible then player.invincible = true end
end



function player:update(dt)
	if paused then return end
	self.idle = true
	
	
	if not player.alive then 
			self.respawnCycle = math.max(0, self.respawnCycle - dt)
			if self.respawnCycle <= 0 then
				self.respawnCycle = self.respawnDelay
				
				if player.lives < 0 then
					title:init()
				else
					self.alive = true
					player.shield = player.shieldmax
				end
			end
		return
	end
	
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
				
			elseif player.yvel < 0 then
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
	if self.xvel < -self.maxvel then self.xvel = -self.maxvel end


	self.y = self.y + self.yvel * dt
	self.x = self.x + self.xvel * dt

	if self.x < 0   then 
		self.x = 0
		self.xvel = 0
	end
	if self.x > starfield.w-self.w  then 
		self.x = starfield.w-self.w
		self.xvel = 0
	end
	
	if self.y < 0  then 
		self.y = 0
		self.yvel = 0
	end
	if self.y > starfield.h-self.h  then 
		self.y = starfield.h-self.h
		self.yvel = 0
	end
	

	for i,p in ipairs(pickups.items) do
		if player.alive and collision:check(p.x,p.y,p.w,p.h,player.x,player.y,player.w,player.h) then
			sound:play(pickups.sound)
			
			if 		   p.type == 1 then player.shield = player.shield + 20
				elseif p.type == 2 then player.energy = player.energy + 20
				elseif p.type == 3 then player.speed = player.speed + 200
				elseif p.type == 4 then --
			end
			
			if player.shield > player.shieldmax then player.shield = player.shieldmax	end
			if player.energy > player.energymax then player.energy = player.energymax	end
			if player.speed > player.speedmax then player.speed = player.speedmax	end

			
			table.remove(pickups.items, i)
		end
	end


	if love.keyboard.isDown(binds.shoot) 
	or love.mouse.isDown("l") then
		self:shootPrimary(dt)
	end

	if love.keyboard.isDown(binds.special) 
	or love.mouse.isDown("r") then
		self:shootSecondary(dt)
	end	
	
	
	if player.shield <= 0 then
		player.shield = 0
		self.alive = false
		player.lives = player.lives -1
		if player.lives < 0 then sound:playbgm(2) end
	end
	if self.energy < 0 then self.energy = 0 end

end

function player:draw()


	if not player.alive then return end
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



function player:shootPrimary(dt)
	self.projectileCycle = math.max(0, self.projectileCycle - dt)
		
	if self.projectileCycle <= 0 then
		sound:play(projectiles.cannon.sound.shoot)
		
		player.cannon.switch = not player.cannon.switch
		
		local yswitch
		if player.cannon.switch then
			yswitch = self.y + self.gfx:getHeight()/2-projectiles.cannon.gfx:getHeight()/2 -28
		else
			yswitch = self.y + self.gfx:getHeight()/2-projectiles.cannon.gfx:getHeight()/2 +28
		end
			
		table.insert(projectiles.missiles, {
			player = true,
			type = "cannon",
			gfx = projectiles.cannon.gfx,
			w = projectiles.cannon.gfx:getWidth(),
			h = projectiles.cannon.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2,
			y = yswitch,
			xvel = 1000,
			yvel = 0,
			damage = projectiles.cannon.damage,
			r = math.random(150,255),
			g = math.random(150,255),
			b = math.random(150,255),
		})
		
		self.projectileCycle = self.projectileDelay
	end
end


function player:shootSecondary(dt)
	
		self.secondaryCycle = math.max(0, self.secondaryCycle - dt)
		
		if self.secondaryCycle <= 0 and self.energy > 0 then
			sound:play(projectiles.beam.sound.shoot)
		
			self.energy = self.energy - 3
			
			table.insert(projectiles.missiles, {
				player = true,
				type = "beam",
				gfx = projectiles.beam.gfx,
				w = projectiles.beam.gfx:getWidth(),
				h = projectiles.beam.gfx:getHeight(),
				x = self.x + self.gfx:getWidth(),
				y = self.y + self.gfx:getHeight()/2-(projectiles.beam.gfx:getHeight()/2),
				xvel = 900,
				yvel = 0,
				damage = projectiles.beam.damage,
				r = 255,
				g = 100,
				b = 155,
			})
			self.secondaryCycle = self.secondaryDelay
		
	end		
end
