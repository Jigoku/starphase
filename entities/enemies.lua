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
 
enemies = {}

enemies.wave = {}
enemies.waveCycle = 0 -- delay until first wave start
enemies.waveDelay = 3
enemies.fadespeed = 1000 -- fade out on death

enemies.sound = {}
enemies.sound.hit = love.audio.newSource("sfx/projectiles/hit.ogg", "static")
enemies.sound.hit:setVolume(1)
enemies.sound.explode = love.audio.newSource("sfx/projectiles/explode.ogg", "static")
enemies.sound.explode:setVolume(0.7)

enemies.shield = love.graphics.newImage("gfx/shield_large.png")


enemies.type = {
	delta = love.graphics.newImage("gfx/enemy/6_small.png"),
	abomination = love.graphics.newImage("gfx/enemy/8_large.png"),
	dart = love.graphics.newImage("gfx/enemy/2_small.png"),
	train = love.graphics.newImage("gfx/enemy/1_small.png"),
	tri = love.graphics.newImage("gfx/enemy/fighter.png"),
	large  = love.graphics.newImage("gfx/enemy/6_large.png"),
	crescent = love.graphics.newImage("gfx/enemy/crescent.png"),
	cruiser = love.graphics.newImage("gfx/enemy/10_small.png"),
	asteroids = {
		love.graphics.newImage("gfx/enemy/asteroid_large.png"),
		love.graphics.newImage("gfx/enemy/asteroid_small.png"),
		love.graphics.newImage("gfx/enemy/asteroid_tiny.png"),
	}
}



function enemies:add_delta()

	local gfx = self.type.delta
	
	local ny = love.math.random(0, starfield.h - gfx:getHeight()*4)
	local nx = starfield.w
	
	local xvel = 400
	local projectileOffset = 0.25
	for i=1, starfield.h, starfield.h/4 do
		xvel = xvel -10

		table.insert(self.wave, {
			w = gfx:getWidth(),
			h = gfx:getHeight(),
			x = nx,
			y = ny,
			yvel = 30,
			xvel = xvel,
			gfx = gfx or nil,
			score = 80,
			shield = 80,
			shieldmax = 80,
			shieldopacity = 0,
			shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.8,
			opacity = 255,
			alive = true,
			projectileCycle = projectileOffset,
			projectileDelay = 2,
			projectileGfx = projectiles.cannon.gfx,
			projectileR = 255,
			projectileG = 180,
			projectileB = 100,
			projectileDamage = 10,
			projectileType = "cannon",
			projectileXvel = 800,
			projectileYvel = 0,
			projectileSound = projectiles.cannon.sound.shoot,
			
		})
		ny = ny + gfx:getHeight()
		nx = nx + gfx:getWidth()
		projectileOffset = projectileOffset + 0.25
	end
end

function enemies:add_abomination()

	local gfx = self.type.abomination
	
	table.insert(self.wave, {
		type = "abomination",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w,
		y = love.math.random(gfx:getHeight(),starfield.h-gfx:getHeight()),		
		yvel = 0,
		xvel = 100,
		gfx = gfx or nil,
		score = 100000,
		shield = 15000,
		shieldmax = 15000,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5,
		opacity = 255,
		alive = true,
		projectileCycle = 5,
		projectileDelay = 0.35,
		projectileGfx = projectiles.plasma.gfx,
		projectileR = 255,
		projectileG = 150,
		projectileB = 100,
		projectileDamage = 35,
		projectileType = "plasma",
		projectileXvel = 1100,
		projectileYvel = 0,
		projectileSound = projectiles.plasma.sound.shoot,
	})


end

function enemies:add_dart()

	local gfx = self.type.dart
	
	
	table.insert(self.wave, {
		type = "dart",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w,
		y = player.y+starfield.offset/2+love.math.random(-200,200),
		yvel = 0,
		xvel = love.math.random(700,800),
		gfx = gfx or nil,
		score = 10,
		shield = 10,
		shieldmax = 10,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5,
		opacity = 255,
		alive = true,
	})


end

function enemies:add_asteroid()
	
	local gfx = self.type.asteroids[love.math.random(1,#self.type.asteroids)]
	table.insert(self.wave, {
		type = "asteroid",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w,
		y = love.math.random(0,starfield.h),
		yvel = 0,
		xvel = love.math.random(100,300),
		gfx = gfx,
		score = 10,
		shield = 50,
		shieldmax = 50,
		shieldopacity = 0,
		shieldscale = 0,
		opacity = 255,
		alive = true,
		spin = (love.math.random(0,1) == 1 and 1 or -1),
	})


end

function enemies:add_train()

	local gfx = self.type.train
	
	local x = starfield.w
	local y = love.math.random(0,starfield.h)
	for i=1, 5 do
	table.insert(self.wave, {
		type = "train",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = x,
		y = y,
		yvel = love.math.random(-20,20),
		xvel = 700,
		gfx = gfx or nil,
		score = 40,
		shield = 40,
		shieldmax = 40,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5,
		opacity = 255,
		alive = true,
	})
	x=x+gfx:getWidth()+30
	end

end


function enemies:add_cruiser()

	local gfx = self.type.cruiser
	
	local x = starfield.w
	local y = love.math.random(0,starfield.h)
	for i=1, 3 do
	table.insert(self.wave, {
		type = "cruiser",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = x,
		y = y,
		yvel = love.math.random(-40,40),
		xvel = 500,
		gfx = gfx or nil,
		score = 180,
		shield = 180,
		shieldmax = 180,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5,
		opacity = 255,
		alive = true,
	})
	x=x+gfx:getWidth()+30
	end

end

function enemies:add_tri()

	local gfx = self.type.tri
	local rand = love.math.random(-200,200)
	table.insert(self.wave, {
		type = "tri",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w,
		y = player.y+starfield.offset/2+rand,
		yvel = love.math.random(-50,50),
		xvel = 340,
		gfx = gfx or nil,
		score = 80,
		shield = 80,
		shieldmax = 80,
		angle = 0,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5,
		opacity = 255,
		alive = true,
	})

	table.insert(self.wave, {
		type = "tri",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w+gfx:getWidth(),
		y = player.y+starfield.offset/2-gfx:getHeight()/2+rand,
		yvel = love.math.random(0,50),
		xvel = 330,
		gfx = gfx or nil,
		score = 80,
		shield = 80,
		shieldmax = 80,
		angle = 0,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5,
		opacity = 255,
		alive = true,
	})
	table.insert(self.wave, {
		type = "tri",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w+gfx:getWidth(),
		y = player.y+starfield.offset/2+gfx:getHeight()/2+rand,
		yvel = love.math.random(-50,0),
		xvel = 330,
		gfx = gfx or nil,
		score = 80,
		shield = 80,
		shieldmax = 80,
		angle = 0,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5,
		opacity = 255,
		alive = true,
	})
end


function enemies:add_large()

	local gfx = self.type.large
	
	
	table.insert(self.wave, {
		type = "large",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w,
		y = love.math.random(gfx:getHeight(),starfield.h-gfx:getHeight()),
		yvel = 0,
		xvel = 200,
		gfx = gfx or nil,
		score = 500,
		shield = 500,
		shieldmax = 500,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.2,
		opacity = 255,
		alive = true,
	})


end


function enemies:add_crescent()

	local gfx = self.type.crescent
	
	local y = (love.math.random(0,1) == 1 and 0 or starfield.h - gfx:getHeight())
	table.insert(self.wave, {
		type = "crescent",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w,
		y = y,
		yvel = y < starfield.h/2 and -25 or 25,
		xvel = 450,
		gfx = gfx or nil,
		score = 200,
		shield = 200,
		shieldmax = 200,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/(gfx:getWidth()*2),
		opacity = 255,
		alive = true,
		spin = (y < starfield.h/2 and 2 or -2),
		angle = math.pi,
		state = 0,
		--[[
		projectileCycle = 3,
		projectileDelay = 1.2,
		projectileGfx = projectiles.plasma.gfx,
		projectileR = 255,
		projectileG = 50,
		projectileB = 80,
		projectileDamage = 20,
		projectileType = "plasma",
		projectileXvel = 1000,
		projectileYvel = (y < starfield.h/2 and -25 or -25),
		projectileSound = projectiles.plasma.sound.shoot
		--]]
	})


end


function enemies:update(dt)
	
	if paused then return end


	
	--	enemies.waveCycle = math.max(0, enemies.waveCycle - dt)
	--	
	--	if enemies.waveCycle <= 0 then
		
	--		--[[ ENEMY TYPE --]]
	--		self:add_asteroid()
	--		
	--		enemies.waveCycle = love.math.random(0.1,1)
	--	end
	--	
	--end
	
	
	
	
	enemies.waveCycle = math.max(0, enemies.waveCycle - dt)
		
	if not debugarcade and enemies.waveCycle <= 0 then
		
		love.math.setRandomSeed( love.math.getRandomSeed()+1 )
		
		local rand = love.math.random(0,15)
		if rand == 0 then
			self:add_dart()
		end
		if rand == 1 then
			self:add_delta()
		end
		if rand == 2 then
			self:add_tri()
		end
		if rand == 3 then
			self:add_large()
		end
		if rand == 4 then
			self:add_train()
		end
		if rand == 5 then
			--fix this so only one exists at a time
			--self:add_abomination()
		end
		if rand == 6 then
			self:add_crescent()
		end
		if rand == 7 then
			self:add_cruiser()
		end
		if rand > 7 then
			self:add_asteroid()
		end
		enemies.waveCycle = love.math.random(0.25,1)
	end
	
	
	

	
	for i=#self.wave,1,-1 do
		local e = self.wave[i]
		
		if e.type == "asteroid" then
			self:rotate(e,e.spin,dt)
		end
	
		if e.type == "crescent" then
			if e.state == 0 and e.x < player.x+e.gfx:getWidth()*4 then
				if e.y < starfield.h/2 and e.angle > math.pi/2 then
					self:rotate(e,-e.spin,dt)
				elseif
					e.y > starfield.h/2 and e.angle < math.pi+math.pi/2 then
					self:rotate(e,-e.spin,dt)
				else
					e.state = 1 
				end
			elseif e.state == 1 then
				if e.y < starfield.h/2 then
					e.xvel = 0 
					e.yvel = -700
					e.state = 2
				else
					e.xvel = 0 
					e.yvel = 700
					e.state = 2
				end
			elseif state == 2 then
				e.scale = e.scale - 1*dt
			
			end
			
		end
	
		if e.type == "tri" then
			e.angle = math.atan2(player.y+player.h/2-e.h/2 - e.y, player.x+player.w/2-e.w/2 - e.x)
		end
				
		if e.projectileCycle and player.alive then
			e.projectileCycle = math.max(0, e.projectileCycle - dt)
			
			if e.projectileCycle <= 0 then
				sound:play(e.projectileSound)
				
				table.insert(projectiles.missiles, {
					player = false,
					type = e.projectileType,
					gfx = e.projectileGfx,
					w = e.projectileGfx:getWidth(),
					h = e.projectileGfx:getHeight(),
					x = e.x + e.gfx:getWidth()/2 - e.projectileGfx:getWidth(),
					y = e.y + e.gfx:getHeight()/2 - e.projectileGfx:getHeight()/2,
					xvel = -e.projectileXvel,
					yvel = e.projectileYvel,
					damage = e.projectileDamage,
					r = e.projectileR,
					g = e.projectileG,
					b = e.projectileB,
				})
				
				e.projectileCycle = e.projectileDelay
			end
		end
		

		if e.shieldopacity > 0 then
			e.shieldopacity = e.shieldopacity - 200 *dt
		else
			e.shieldopacity = 0
		end
	
		
		-- test basic enemy movements
		if e.type == "abomination" then
			if e.x < love.graphics.getWidth() - love.graphics.getWidth()/5 and e.xvel >= 0 then
				e.xvel = e.xvel - (50 *dt)
			
				
				if e.xvel <= 0 then 
					e.xvel = 0 
				
					local speed = 800
					if player.y + player.h/2 < e.y + e.h/2 then
						e.yvel = e.yvel + (speed *dt)
					elseif player.y + player.h/2 > e.y + e.h/2 then
						e.yvel = e.yvel - (speed *dt)
					end
					
					if e.yvel > speed/2 then 
						e.yvel = speed/2 
					end
					
					
					if e.yvel < -speed/2 then 
						e.yvel = -speed/2 
					end
				end
				
			end
		end
		
		
		e.x = e.x - (e.xvel *dt)
		e.y = e.y - (e.yvel *dt)
		
		if player.alive and e.alive then
			if collision:check(e.x,e.y,e.w,e.h, player.x,player.y,player.w,player.h) then
				table.remove(enemies.wave, i)
				explosions:addLarge(
						e.x+e.w/2,e.y+e.h/2,e.xvel,e.yvel
				)
				
				if not cheats.invincible then
					player.shield = player.shield - 20
				end
				
				sound:play(enemies.sound.explode)
			end
		end
		
		
		if e.x + e.w < 0 or
			e.y + e.h < 0 or
			e.y > starfield.h 
		then
			table.remove(self.wave, i)
		end
		
		for z,p in ipairs (projectiles.missiles) do
			if p.player then
				if collision:check(p.x,p.y,p.w,p.h, e.x,e.y,e.w,e.h) then

					e.shield = e.shield - p.damage
					e.shieldopacity = 100
						
					if p.type == "rocket" then
						sound:play(projectiles.rocket.sound.explode)
						explosions:addLarge(
							p.x+p.w/2,p.y+p.h/2,-p.xvel/8,-p.yvel/8
						)
					end
						
					if p.type == "radial" then
						sound:play(projectiles.rocket.sound.explode)
						explosions:addSmall(
							p.x+p.w/2,p.y+p.h/2,0,0
						)
					end
					
					if not p.collide then
						table.remove(projectiles.missiles, z)
					end
				
					sound:play(enemies.sound.hit)

				end
			end
		end
		
		if e.shield <= 0 then
			if e.alive then
				e.alive = false
				e.shield = 0
				explosions:addLarge(
					e.x+e.w/2,e.y+e.h/2,e.xvel/2,e.yvel/2
				)
			end
			
			e.opacity = e.opacity - self.fadespeed *dt
			
			if e.opacity <= 0 then
				table.remove(self.wave, i)
			
				local rand = love.math.random(0,pickups.chance)
				--local rand = 9
				if rand > pickups.chance -1 then
					pickups:add(e.x+e.w/2,e.y+e.h/2)
				end
				player.score = player.score + e.score
				sound:play(enemies.sound.explode)			
			
			end
		end
	end
	
end

function enemies:drawshield(e)
	if e.shieldopacity > 0 and e.alive then
		
		love.graphics.setColor(100,200,255,e.shieldopacity)
		love.graphics.draw(
			enemies.shield,  math.floor(e.x)+e.w/2-(enemies.shield:getWidth()/2/e.shieldscale), 
			math.floor(e.y)+e.h/2-(enemies.shield:getHeight()/2/e.shieldscale), 0, 1/e.shieldscale, 1/e.shieldscale
		)
	end
end

function enemies:draw()
	
	for _, e in pairs (self.wave) do
	
		if e.type == "asteroid" then
			love.graphics.push()
				love.graphics.translate(e.x+e.w/2,e.y+e.h/2)
				love.graphics.rotate(e.angle)
				love.graphics.translate(-e.x-e.w/2,-e.y-e.h/2)
			love.graphics.pop()
		end
	
		if e.angle then
			--rotating face to player
			love.graphics.push()

			love.graphics.translate(e.x+e.w/2,e.y+e.h/2)
			love.graphics.rotate(e.angle)
			love.graphics.translate(-e.x-e.w/2,-e.y-e.h/2)
			
			love.graphics.setColor(255,255,255,e.opacity)
			love.graphics.draw(
				e.gfx,  e.x+e.w, 
				e.y, 0, 1, 1,e.w
				
			)
			enemies:drawshield(e)
			love.graphics.pop()
		else
			love.graphics.setColor(255,255,255,e.opacity)
			love.graphics.draw(
				e.gfx,  e.x+e.w, 
				e.y, 0, -1, 1
				
			)
			enemies:drawshield(e)
		end
	end
	
	--draw this on top everything else
	for _, e in pairs (self.wave) do
		local x = math.floor(e.x)
		local y = math.floor(e.y)
			
		
		
		if debug then
		
			if e.shield > 0 then
				--health bar
				local barheight = 6
				love.graphics.setColor(40,40,40,50)
				love.graphics.rectangle("fill", x+e.w/1.5/4,y-20,e.w/1.5,barheight)
		
				love.graphics.setColor(55,155,155,50)
				love.graphics.rectangle("fill", x+e.w/1.5/4,y-20,(e.shield/e.shieldmax)*(e.w/1.5),barheight)
		
				love.graphics.setColor(155,255,255,50)
				love.graphics.rectangle("line", x+e.w/1.5/4,y-20,e.w/1.5,barheight)
			end
			
			love.graphics.setColor(255,255,255,255)
			love.graphics.print("x:"..x, x-10,y-10)
			love.graphics.print("y:".. y, x-10,y)
			love.graphics.print("a:"..(e.angle or "nil"), x-10,y+10)
			love.graphics.print("shield: "..math.floor(e.shield) .. "/" ..e.shieldmax, x-10,y+20)
			
			love.graphics.setColor(255,155,255,155)
			love.graphics.rectangle("line", x,y, e.w, e.h)
		end
	end
end


function enemies:rotate(e,n,dt)
	if not e.angle then e.angle = 0 end
	e.angle = e.angle + dt * n
	e.angle = e.angle % (2*math.pi)
end
