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

--
   --add laser beam weapon... follows ship whilst activated
   --rename current weapons
--


function player:init(playersel)
	player.type = playersel
	player.gfx = love.graphics.newImage("gfx/player/"..player.type.."_small.png") -- default

	player.x = love.graphics.getWidth()/3
	player.y = (starfield.h+starfield.offset)/2-player.gfx:getHeight()
	player.w = player.gfx:getWidth()
	player.h = player.gfx:getHeight()
	player.score = 0
	player.lives = 9
	player.shield = 100
	player.shieldmax = 100
	player.energy = 100
	player.energymax = 100
	player.speed = 1700
	player.speedmax = 3000
	player.maxvel = 550
	player.xvel = 0
	player.yvel = 0
	player.drift = 1.1
	player.respawnCycle = 3
	player.respawnDelay = 3
	player.alive = true
	player.idle = true
	player.invincible = false
	
	
	player.cannon = {
		switch = false,
		cycle = 0,
		delay = 0.14,
	}
	
	player.plasma = {
		switch = false,
		cycle = 0,
		delay = 0.5,
	}
	
	player.radial = {
		switch = nil,
		cycle = 0,
		delay = 1.75,
	}

	player.rocket = {
		switch = false,
		cycle = 0,
		delay = 0.8,
	}
	
	player.wave = {
		switch = false,
		cycle = 0,
		delay = 0.05,
	}

	player.blaster = {
		switch = nil,
		cycle = 0,
		delay = 0.25,
	}
	
	player.beam = {
		switch = nil,
		cycle = 0,
		delay = 0.02,
	}
	

	
	--weapon powerups
	player.hascannon = true --default
	player.hasplasma = false 
	player.hasradial = false
	player.hasrocket = false
	player.haswave = false
	player.hasblaster = false
	player.hasbeam = false

		
	
	if cheats.invincible then player.invincible = true end
end



function player:update(dt)
	if paused then return end
	
	
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
	
	self:move(dt)
	self:checkShield(dt)
	self:checkEnergy(dt)
	self:shoot(dt)

end

function player:move(dt)
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
				self.yvel = self.yvel - (self.speed/self.drift) *dt
				if self.yvel < 0 then self.yvel = 0 end
				
			elseif player.yvel < 0 then
				self.yvel = self.yvel + (self.speed/self.drift) *dt
				if self.yvel > 0 then self.yvel = 0 end
			end
		end

		if self.xvel ~= 0 then
			if self.xvel > 0 then
				self.xvel = self.xvel - (self.speed/self.drift) *dt
				if self.xvel < 0 then self.xvel = 0 end
				
			elseif self.xvel < 0 then
				self.xvel = self.xvel + (self.speed/self.drift) *dt
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
end

function player:checkEnergy(dt)
	if self.energy < 0 then self.energy = 0 end
end

function player:checkShield(dt)

	if player.shield <= 0 and player.alive then
		explosions:addLarge(
			player.x+player.w/2,player.y+player.h/2,0,0
		)
		
		player.shield = 0
		player.xvel = 0
		player.yvel = 0
		player.lives = player.lives -1
		self.alive = false
		if player.lives < 0 then sound:playbgm(2) end
		
	end
end


function player:shoot(dt)
	if love.keyboard.isDown(binds.shoot) 
	or love.mouse.isDown("l") then
		if player.hascannon then self:fireCannon(dt) end
		if player.hasplasma then self:firePlasma(dt) end
		if player.hasradial then self:fireRadial(dt) end
		if player.hasblaster then self:fireBlaster(dt) end
		if player.hasrocket then self:fireRocket(dt) end
		if player.haswave then self:fireWave(dt) end
		if player.hasbeam then self:fireBeam(dt) end
		
	end

	if love.keyboard.isDown(binds.special) 
	or love.mouse.isDown("r") then

			-- decide whether energy should be used for special attacks
			-- possibly remove this and just have powerups added automatically
	end	
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

function player:fireCannon(dt)
	self.cannon.cycle = math.max(0, self.cannon.cycle - dt)
		
	if self.cannon.cycle <= 0 then
		sound:play(projectiles.cannon.sound.shoot)
		
		player.cannon.switch = not player.cannon.switch
			
		table.insert(projectiles.missiles, {
			player = true,
			type = "cannon",
			gfx = projectiles.cannon.gfx,
			w = projectiles.cannon.gfx:getWidth(),
			h = projectiles.cannon.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2,
			y = self.y + self.gfx:getHeight()/2-projectiles.cannon.gfx:getHeight()/2 +(player.cannon.switch and -28 or 28),
			xvel = 2000,
			yvel = 0,
			damage = projectiles.cannon.damage,
			r = math.random(150,255),
			g = math.random(150,255),
			b = math.random(150,255),
		})
		self.cannon.cycle = self.cannon.delay
	end
end


function player:fireBlaster(dt)
	self.blaster.cycle = math.max(0, self.blaster.cycle - dt)
		
	if self.blaster.cycle <= 0 then
		sound:play(projectiles.blaster.sound.shoot)
			
		table.insert(projectiles.missiles, {
			player = true,
			type = "blaster",
			gfx = projectiles.blaster.gfx,
			w = projectiles.blaster.gfx:getWidth(),
			h = projectiles.blaster.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2,
			y = self.y + self.gfx:getHeight()/2-(projectiles.blaster.gfx:getHeight()/2),
			xvel = 1250,
			yvel = 0,
			damage = projectiles.blaster.damage,
			r = 0,
			g = 255,
			b = 140,
		})
		self.blaster.cycle = self.blaster.delay
	end
end

function player:fireWave(dt)
	self.wave.cycle = math.max(0, self.wave.cycle - dt)
		
	if self.wave.cycle <= 0 then
		sound:play(projectiles.wave.sound.shoot)
		
		table.insert(projectiles.missiles, {
			player = true,
			type = "wave",
			gfx = projectiles.wave.gfx,
			w = projectiles.wave.gfx:getWidth(),
			h = projectiles.wave.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2,
			y = self.y + self.gfx:getHeight()/2-(projectiles.wave.gfx:getHeight()/2),
			switch = true,
			xvel = 750,
			yvel = 0,
			damage = projectiles.wave.damage,
			r = 255,
			g = 50,
			b = 220,
		})
		
		
		table.insert(projectiles.missiles, {
			player = true,
			type = "wave",
			gfx = projectiles.wave.gfx,
			w = projectiles.wave.gfx:getWidth(),
			h = projectiles.wave.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2,
			y = self.y + self.gfx:getHeight()/2-(projectiles.wave.gfx:getHeight()/2),
			switch = false,
			xvel = 750,
			yvel = 0,
			damage = projectiles.wave.damage,
			r = 255,
			g = 50,
			b = 220,
		})
		
		self.wave.cycle = self.wave.delay
	end
end

function player:fireRadial(dt)
	self.radial.cycle = math.max(0, self.radial.cycle - dt)
		
	if self.radial.cycle <= 0 then
		sound:play(projectiles.radial.sound.shoot)
		
		local r, g, b
		r = 255
		g = 255
		b = 255
		
		local timer =  1
		local vel = 400
		--east
		table.insert(projectiles.missiles, {
			player = true,
			type = "radial",
			gfx = projectiles.radial.gfx,
			w = projectiles.radial.gfx:getWidth(),
			h = projectiles.radial.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2-(projectiles.radial.gfx:getWidth()/2),
			y = self.y + self.gfx:getHeight()/2-(projectiles.radial.gfx:getHeight()/2),
			xvel = vel,
			yvel = 0,
			damage = projectiles.radial.damage,
			timer = timer,
			r = r,
			g = g,
			b = b,
		})
		
		--west
		table.insert(projectiles.missiles, {
			player = true,
			type = "radial",
			gfx = projectiles.radial.gfx,
			w = projectiles.radial.gfx:getWidth(),
			h = projectiles.radial.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2-(projectiles.radial.gfx:getWidth()/2),
			y = self.y + self.gfx:getHeight()/2-(projectiles.radial.gfx:getHeight()/2),
			xvel = -vel,
			yvel = 0,
			damage = projectiles.radial.damage,
			timer = timer,
			r = r,
			g = g,
			b = b,
		})
		
		--south
		table.insert(projectiles.missiles, {
			player = true,
			type = "radial",
			gfx = projectiles.radial.gfx,
			w = projectiles.radial.gfx:getWidth(),
			h = projectiles.radial.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2-(projectiles.radial.gfx:getWidth()/2),
			y = self.y + self.gfx:getHeight()/2-(projectiles.radial.gfx:getHeight()/2),
			xvel = 0,
			yvel = vel,
			damage = projectiles.radial.damage,
			timer = timer,
			r = r,
			g = g,
			b = b,
		})
		
		--north
		table.insert(projectiles.missiles, {
			player = true,
			type = "radial",
			gfx = projectiles.radial.gfx,
			w = projectiles.radial.gfx:getWidth(),
			h = projectiles.radial.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2-(projectiles.radial.gfx:getWidth()/2),
			y = self.y + self.gfx:getHeight()/2-(projectiles.radial.gfx:getHeight()/2),
			xvel = 0,
			yvel = -vel,
			damage = projectiles.radial.damage,
			timer = timer,
			r = r,
			g = g,
			b = b,
		})
		
		--north east
		table.insert(projectiles.missiles, {
			player = true,
			type = "radial",
			gfx = projectiles.radial.gfx,
			w = projectiles.radial.gfx:getWidth(),
			h = projectiles.radial.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2-(projectiles.radial.gfx:getWidth()/2),
			y = self.y + self.gfx:getHeight()/2-(projectiles.radial.gfx:getHeight()/2),
			xvel = vel-(vel/4),
			yvel = -(vel-(vel/4)),
			damage = projectiles.radial.damage,
			timer = timer,
			r = r,
			g = g,
			b = b,
		})
		
		--south east
		table.insert(projectiles.missiles, {
			player = true,
			type = "radial",
			gfx = projectiles.radial.gfx,
			w = projectiles.radial.gfx:getWidth(),
			h = projectiles.radial.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2-(projectiles.radial.gfx:getWidth()/2),
			y = self.y + self.gfx:getHeight()/2-(projectiles.radial.gfx:getHeight()/2),
			xvel = vel-(vel/4),
			yvel = vel-(vel/4),
			damage = projectiles.radial.damage,
			timer = timer,
			r = r,
			g = g,
			b = b,
		})
		
		--south west
		table.insert(projectiles.missiles, {
			player = true,
			type = "radial",
			gfx = projectiles.radial.gfx,
			w = projectiles.radial.gfx:getWidth(),
			h = projectiles.radial.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2-(projectiles.radial.gfx:getWidth()/2),
			y = self.y + self.gfx:getHeight()/2-(projectiles.radial.gfx:getHeight()/2),
			xvel = -(vel-(vel/4)),
			yvel = vel-(vel/4),
			damage = projectiles.radial.damage,
			timer = timer,
			r = r,
			g = g,
			b = b,
		})
		
		--north west
		table.insert(projectiles.missiles, {
			player = true,
			type = "radial",
			gfx = projectiles.radial.gfx,
			w = projectiles.radial.gfx:getWidth(),
			h = projectiles.radial.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2-(projectiles.radial.gfx:getWidth()/2),
			y = self.y + self.gfx:getHeight()/2-(projectiles.radial.gfx:getHeight()/2) ,
			xvel = -(vel-(vel/4)),
			yvel = -(vel-(vel/4)),
			damage = projectiles.radial.damage,
			timer = timer,
			r = r,
			g = g,
			b = b,
		})
	
	
		self.radial.cycle = self.radial.delay
	end
end


function player:firePlasma(dt)

	self.plasma.cycle = math.max(0, self.plasma.cycle - dt)
		
	if self.plasma.cycle <= 0 then
		sound:play(projectiles.plasma.sound.shoot)
		
		player.plasma.switch = not player.plasma.switch
		
		table.insert(projectiles.missiles, {
			player = true,
			type = "plasma",
			gfx = projectiles.plasma.gfx,
			w = projectiles.plasma.gfx:getWidth(),
			h = projectiles.plasma.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2,
			y = self.y + self.gfx:getHeight()/2-projectiles.plasma.gfx:getHeight()/2 +(player.plasma.switch and -28 or 28),
			xvel = 750,
			yvel = 0,
			damage = projectiles.plasma.damage,
			r = 100,
			g = 230,
			b = 250,
		})
		
		self.plasma.cycle = self.plasma.delay
	end

end


function player:fireRocket(dt)

	self.rocket.cycle = math.max(0, self.rocket.cycle - dt)
		
	if self.rocket.cycle <= 0 then
		sound:play(projectiles.rocket.sound.shoot)
		
		player.rocket.switch = not player.rocket.switch
		
		table.insert(projectiles.missiles, {
			player = true,
			type = "rocket",
			gfx = projectiles.rocket.gfx,
			w = projectiles.rocket.gfx:getWidth(),
			h = projectiles.rocket.gfx:getHeight(),
			x = self.x + self.gfx:getWidth()/2-(projectiles.rocket.gfx:getWidth()/2),
			y = self.y + (player.rocket.switch and self.gfx:getHeight()/2-(projectiles.rocket.gfx:getHeight()/2) or self.gfx:getHeight()/2+(projectiles.rocket.gfx:getHeight()/2)),
			switch = player.rocket.switch,
			trigger = 150,
			launched = false,
			xvel = 950,
			yvel = (player.rocket.switch and -400 or 400),
			damage = projectiles.rocket.damage,
			r = 155,
			g = 155,
			b = 155,
		})
		
		self.rocket.cycle = self.rocket.delay
	end

end


function player:fireBeam(dt)
	
	self.beam.cycle = math.max(0, self.beam.cycle - dt)
		
	if self.beam.cycle <= 0 and self.energy > 0 then
		sound:play(projectiles.beam.sound.shoot)
		
		--self.energy = self.energy - 3
			
		table.insert(projectiles.missiles, {
			player = true,
			collide = false, -- whether particle dissapears on collision
			type = "beam",
			gfx = projectiles.beam.gfx,
			w = projectiles.beam.gfx:getWidth(),
			h = projectiles.beam.gfx:getHeight(),
			x = self.x + self.gfx:getWidth(),
			y = self.y + self.gfx:getHeight()/2-(projectiles.beam.gfx:getHeight()/2),
			xvel = 800,
			yvel = 0,
			damage = projectiles.beam.damage,
			r = 50,
			g = 200,
			b = 255,
		})
		self.beam.cycle = self.beam.delay
	end		
end



function player:addBarrier(dt)

	table.insert(projectiles.missiles, {
		player = true,
		type = "barrier",
		gfx = projectiles.barrier.gfx,
		w = projectiles.barrier.gfx:getWidth(),
		h = projectiles.barrier.gfx:getHeight(),
		x = self.x + self.gfx:getWidth()/2,
		y = self.y + self.gfx:getHeight()/2-projectiles.barrier.gfx:getHeight()/2,
		xvel = 750,
		yvel = 0,
		damage = projectiles.barrier.damage,
		r = 255,
		g = 255,
		b = 255,
	})

end
