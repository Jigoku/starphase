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
enemies.waveCycle = 0 
enemies.waveDelay = 2 -- delay until next enemy spawn 
enemies.waveDelayMin = 0.2
enemies.waveDelayMod = 0.010


enemies.fadespeed = 3.75 -- texture fade out on death
enemies.spawned = 0

enemies.sound = {}
enemies.sound.hit = love.audio.newSource("sfx/projectiles/hit.ogg", "static")
enemies.sound.hit:setVolume(1)
enemies.sound.explode = love.audio.newSource("sfx/projectiles/explode.ogg", "static")
enemies.sound.explode:setVolume(0.7)

enemies.shield = love.graphics.newImage("gfx/shield_large.png")
enemies.shieldmaxopacity = 0.45

enemies.type = {
	delta = love.graphics.newImage("gfx/enemy/6_small.png"),
	abomination = love.graphics.newImage("gfx/enemy/8_large.png"),
	dart = love.graphics.newImage("gfx/enemy/2_small.png"),
	train = love.graphics.newImage("gfx/enemy/1_small.png"),
	tri = love.graphics.newImage("gfx/enemy/fighter.png"),
	large  = love.graphics.newImage("gfx/enemy/6_large.png"),
	crescent = love.graphics.newImage("gfx/enemy/crescent.png"),
	cruiser = love.graphics.newImage("gfx/enemy/10_small.png"),
	asteroid = love.graphics.newImage("gfx/enemy/asteroid_large.png"),
}



function enemies:add_delta()

	local gfx = self.type.delta
	
	local y = love.math.random(0, starfield.h-gfx:getHeight()*3)
	local x = starfield.w
	
	local xvel = 250
	local yvel = (y < starfield.h/2 and -30 or 30)
	
	
	local projectileOffset = 0.25
	local color = 1
	for i=1, 3 do
		xvel = xvel -10
		
		table.insert(self.wave, {
			w = gfx:getWidth(),
			h = gfx:getHeight(),
			x = x,
			y = y,
			xvel = xvel,
			yvel = yvel,
			gfx = gfx or nil,
			score = 80,
			shield = 80,
			shieldmax = 80,
			shieldopacity = 0,
			shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.8,
			opacity = 1,
			alive = true,
			projectileCycle = projectileOffset,
			projectileDelay = 2,
			projectileGfx = projectiles.cannon.gfx,
			projectileR = 0.39,
			projectileG = 1,
			projectileB = 0.70,
			projectileDamage = 10,
			projectileType = "cannon",
			projectileXvel = 750,
			projectileYvel = love.math.random(-10,10),
			projectileSound = projectiles.cannon.sound.shoot,
			r = color,
			g = color,
			b = color,
			scale = 1,
		})
		y = (y < starfield.h/2 and y - gfx:getHeight() or y + gfx:getHeight())
		x = x + gfx:getWidth()
		projectileOffset = projectileOffset + 0.25
		color = color - 0.1
	end
end

function enemies:add_abomination()
--TODO FIX THIS

	local gfx = self.type.abomination
	
	table.insert(self.wave, {
		type = "abomination",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w,
		y = love.math.random(starfield.h-gfx:getHeight()),
		xvel = 200,
		yvel = 0,
		gfx = gfx or nil,
		score = 10000,
		shield = 8000,
		shieldmax = 8000,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.2,
		opacity = 1,
		alive = true,
		projectileCycle = 5,
		projectileDelay = 0.37,
		projectileGfx = projectiles.plasma.gfx,
		projectileR = 1,
		projectileG = 0.8,
		projectileB = 0.5,
		projectileDamage = 30,
		projectileType = "plasma",
		projectileXvel = 1200,
		projectileYvel = 0,
		projectileSound = projectiles.cannon.sound.shoot,
		r = 1,
		g = 1,
		b = 1,
		scale = 1,
	})


end

function enemies:add_dart()

	local gfx = self.type.dart
	
	
	table.insert(self.wave, {
		type = "dart",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		y = player.y+love.math.random(-200,200),
		x = starfield.w,
		xvel = love.math.random(500,600),
		yvel = 0,
		gfx = gfx or nil,
		score = 10,
		shield = 10,
		shieldmax = 10,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5,
		opacity = 1,
		alive = true,
		r = 1,
		g = 1,
		b = 1,
		scale = 1,
	})


end

function enemies:add_asteroid(x,y,s)
	
	local gfx = self.type.asteroid
	local color = love.math.random(1,3)/10
	
	local scale = s
	if not s then
		-- set random scale if not provided
		if love.math.random(1,4) == 4 then
			scale = love.math.random(10,100)/100
		else
			scale = love.math.random(10,50)/100
		end
	end
	
	table.insert(self.wave, {
		type = "asteroid",
		w = gfx:getWidth()*scale,
		h = gfx:getHeight()*scale,
		x = x or starfield.w,
		y = y or love.math.random(gfx:getHeight()*scale,starfield.h-gfx:getHeight()*scale),
		xvel = love.math.random(50,200),
		yvel = love.math.random(-100,100),
		gfx = gfx,
		score = 10,
		shield = 50,
		shieldmax = 50,
		shieldopacity = 0,
		shieldscale = 0,
		opacity = 1,
		scale = math.round(scale,2),
		alive = true,
		spin = (love.math.random(0,1) == 1 and love.math.random(10,30)/10 or love.math.random(-10,-30)/10),
		r = starfield.nebulae.red*2 + color,
		g = starfield.nebulae.green*2 + color,
		b = starfield.nebulae.blue*2 + color,
		
	})

end


function enemies:add_train()

	local gfx = self.type.train
	
	local x = starfield.w
	local y = love.math.random(-gfx:getHeight(),starfield.h-gfx:getHeight())
	
	for i=1, 4 do
	table.insert(self.wave, {
		type = "train",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = x,
		y = y,
		yvel = love.math.random(-20,20),
		xvel = 400,
		gfx = gfx or nil,
		score = 40,
		shield = 40,
		shieldmax = 40,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5,
		opacity = 1,
		alive = true,
		scale = 1,
		r = 1,
		g = 1,
		b = 1,
	})
	x = x+gfx:getWidth()*1.5
	end

end


function enemies:add_cruiser()

	local gfx = self.type.cruiser
	
	local x = starfield.w
	local y = love.math.random(gfx:getHeight(),starfield.h-gfx:getHeight())
	for i=1, 2 do
	table.insert(self.wave, {
		type = "cruiser",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = x,
		y = y - gfx:getHeight()/2,
		yvel = love.math.random(-40,40),
		xvel = 300-(i*10),
		gfx = gfx or nil,
		score = 90,
		shield = 90,
		shieldmax = 90,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5,
		opacity = 1,
		alive = true,
		r = 1,
		g = 1,
		b = 1,
		scale = 1,
	})
	x = x+gfx:getWidth()
	end

end

function enemies:add_tri()

	local gfx = self.type.tri
	local rand = love.math.random(-100,100)
	
	local y = starfield.h/2 + love.math.random(-400,400)
	local x = starfield.w
	table.insert(self.wave, {
		type = "tri",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = x,
		y = y,
		xvel = 200,
		yvel = love.math.random(-30,30),
		gfx = gfx or nil,
		score = 80,
		shield = 80,
		shieldmax = 80,
		angle = 0,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5,
		opacity = 1,
		alive = true,
		r = 1,
		g = 1,
		b = 1,
		scale = 1,
		
	})

	table.insert(self.wave, {
		type = "tri",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = x+gfx:getWidth(),
		y = y-gfx:getHeight(),
		xvel = 190,
		yvel = love.math.random(0,30),
		gfx = gfx or nil,
		score = 80,
		shield = 80,
		shieldmax = 80,
		angle = 0,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5,
		opacity = 1,
		alive = true,
		r = 0.55,
		g = 0.55,
		b = 0.55,
		scale = 1,
	})
	table.insert(self.wave, {
		type = "tri",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = x+gfx:getWidth(),
		y = y+gfx:getHeight(),
		xvel = 190,
		yvel = love.math.random(-30,0),
		gfx = gfx or nil,
		score = 80,
		shield = 80,
		shieldmax = 80,
		angle = 0,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5,
		opacity = 1,
		alive = true,
		r = 0.55,
		g = 0.55,
		b = 0.55,
		scale = 1,
	})
end


function enemies:add_large()

	local gfx = self.type.large
	local scale = love.math.random(75,100)/100
	local color = love.math.random(1,3)/10
	table.insert(self.wave, {
		type = "large",
		w = gfx:getWidth()*scale,
		h = gfx:getHeight()*scale,
		x = starfield.w,
		y = love.math.random(gfx:getHeight()*scale,starfield.h-(gfx:getHeight()*scale)),
		xvel = love.math.random(50,70),
		yvel = 0,
		gfx = gfx or nil,
		score = 500,
		shield = 600,
		shieldmax = 600,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/(gfx:getWidth()*scale)/1.2,
		opacity = 1,
		alive = true,
		r = 1 -color,
		g = 1 -color,
		b = 1 -color,
		scale = scale,
	})


end


function enemies:add_crescent()
--TODO FIX THIS

	local gfx = self.type.crescent
	
	local y = (love.math.random(0,1) == 1 and 0 or starfield.h - gfx:getHeight())
	table.insert(self.wave, {
		type = "crescent",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w,
		y = y,
		xvel = 800,
		yvel = y < starfield.h/2 and -25 or 25,
		gfx = gfx or nil,
		score = 200,
		shield = 200,
		shieldmax = 200,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/(gfx:getWidth()*1.8),
		opacity = 255,
		alive = true,
		spin = 7,
		angle = 0,
		state = 0,
		scale = 1,
		
		projectileCycle = 3,
		projectileDelay = 1.2,
		projectileGfx = projectiles.plasma.gfx,
		projectileR = 0.5,
		projectileG = 0.8,
		projectileB = 0.31,
		projectileDamage = 20,
		projectileType = "plasma",
		projectileXvel = (y < starfield.h/2 and 25 or -25),
		projectileYvel = 1000,
		projectileSound = projectiles.plasma.sound.shoot,
		
		r = 1,
		g = 1,
		b = 1,
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
		
	while not debugarcade and enemies.waveCycle <= 0 do
		if starfield.speed >= starfield.warpspeed then break end
		
	--	love.math.setRandomSeed( love.math.getRandomSeed()+1 )
		
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
		enemies.waveCycle = enemies.waveDelay
		enemies.spawned = enemies.spawned + 1
	end
	
	enemies.waveDelay = math.max(enemies.waveDelayMin, enemies.waveDelay - enemies.waveDelayMod *dt)
	

	
	for i=#self.wave,1,-1 do
		local e = self.wave[i]
		
		--[[
		if e.scale then
			e.scale = math.max(e.scale - 1 *dt,1)
		end--]]
		
		if e.type == "asteroid" then
			self:rotate(e,e.spin,dt)
		end
	
		if e.type == "crescent" then
			if e.state == 0  then
				if e.x <= player.x+player.w then
					e.xvel = math.max(e.xvel - 3000 *dt,0)
					if e.xvel == 0 then
						e.state = 1
					end
				end
					
			elseif e.state == 1 then
			
				if e.y < starfield.h/2 and (e.angle > math.pi+(math.pi/2) or e.angle == 0) then
						self:rotate(e,-e.spin,dt)
				elseif
					e.y > starfield.h/2 and e.angle < math.pi/2 then
						self:rotate(e,e.spin,dt)
				else 
					e.state = 2
				end
				
			elseif e.state == 2 then
				if e.y < starfield.h/2 then
					e.xvel = 0
					e.yvel = -800
					e.state = 3
				else
					e.xvel = 0
					e.yvel = 800
					e.state = 3
				end
			elseif e.state == 3 then
				--	e.scale = math.max(e.scale - 0.7*dt,0.1)
			
			end
			
		end
	
		if e.type == "tri" then
			e.angle = -math.atan2(player.x+player.w/2-e.x-e.w/2, player.y+player.h/2-e.y-e.h/2)
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
					x = e.x + e.gfx:getWidth()/2 - e.projectileGfx:getWidth()/2,
					y = e.y + e.gfx:getHeight()/2,
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
			e.shieldopacity = e.shieldopacity - 1.275 *dt
		else
			e.shieldopacity = 0
		end
	
		
		-- test basic enemy boss
		if e.type == "abomination" then
			if e.xvel > 0 then
				e.xvel = e.xvel - (50 *dt)
			else
				e.xvel = 0 
					
				local speed = 600
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
		
		
		if e.x+e.w < 0 or
			e.y > starfield.h or
			e.y+e.h < 0
		then
			table.remove(self.wave, i)
		end
		
		for z,p in ipairs (projectiles.missiles) do
			if p.player then
				if collision:check(p.x,p.y,p.w,p.h, e.x,e.y,e.w,e.h) then

					e.shield = e.shield - p.damage
					e.shieldopacity = enemies.shieldmaxopacity
						
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
				explosions:addLarge(
					e.x+e.w/2,e.y+e.h/2,e.xvel/2,e.yvel/2
				)
				
				
				if e.type == "asteroid" then
					if e.scale > 0.25 then
						local spawn = love.math.random(2,4)
							if spawn == 4 then
								for i=1,4 do
									enemies:add_asteroid(
										e.x+e.w/2,
										e.y+e.h/2,
										love.math.random((e.scale/2.5)*10, (e.scale/3)*10)/10
									)
								end
							elseif spawn == 3 then
								for i=1,3 do
									enemies:add_asteroid(
										e.x+e.w/2,
										e.y+e.h/2,
										love.math.random((e.scale/2)*10, (e.scale/2.5)*10)/10
									)
								end
							elseif spawn == 2 then
								for i=1,2 do
									enemies:add_asteroid(
										e.x+e.w/2,
										e.y+e.h/2,
										love.math.random((e.scale/1.5)*10, (e.scale/2)*10)/10
									)
								end
							end
						
							
						
						
						
					end
									
				end
			end
			
			e.shield = 0
			e.opacity = e.opacity - self.fadespeed *dt
			
			if e.opacity <= 0 then
				table.remove(self.wave, i)
			
				local rand = love.math.random(0,pickups.chance)
				--local rand = 9
				if rand > pickups.chance -1 then
					pickups:add(e.x+e.w/2,e.y+e.h/2)
				end
				player.score = player.score + e.score
				player.kills = player.kills + 1
				sound:play(enemies.sound.explode)			
			
			end
		end
	end
	
end

function enemies:drawshield(e)
	if e.shieldopacity > 0 and e.alive then
		
		love.graphics.setColor(0.39,0.823,1,e.shieldopacity)
		
		local shake = 5
		love.graphics.draw(
			enemies.shield,  
			love.math.random(-shake,shake) + math.floor(e.x)+e.w/2, 
			love.math.random(-shake,shake) + math.floor(e.y)+e.h/2, 
			love.math.random(0,math.pi), 
			1/e.shieldscale, 
			1/e.shieldscale,
			enemies.shield:getWidth()/2,
			enemies.shield:getHeight()/2
		)
	end
end

function enemies:draw()
	
	for _, e in pairs (self.wave) do
	
	--[[ -- maybe not needed
		if e.type == "asteroid" then
			love.graphics.push()
				love.graphics.translate(e.x+e.w/2,e.y+e.h/2)
				love.graphics.rotate(e.angle)
				love.graphics.translate(-e.x-e.w/2,-e.y-e.h/2)
			love.graphics.pop()
		end
	--]]
		
		love.graphics.push()
			
		if e.angle then
			love.graphics.translate(e.x+e.w/2,e.y+e.h/2)
			love.graphics.rotate(e.angle)
			love.graphics.translate(-e.x-e.w/2,-e.y-e.h/2)
		end
	
		love.graphics.setColor(e.r,e.g,e.b,e.opacity)
		--love.graphics.setColor(1,1,1,e.opacity)
		love.graphics.draw(
			e.gfx,  e.x, 
			e.y, 0, (e.scale or 1), (e.scale or 1)		
		)
		
		enemies:drawshield(e)
		
		love.graphics.pop()
		
		
	end
	
	--draw this on top everything else
	for _, e in pairs (self.wave) do
		local x = math.floor(e.x)
		local y = math.floor(e.y)
			
		
		
		if debug then
		
			-- center point of sprite
			love.graphics.setColor(1,0.75,0.2,0.3)
			love.graphics.circle("fill", e.x+e.w/2,e.y+e.h/2, 10)
			
		
			if e.shield > 0 then
				--health bar
				local barheight = 6
				love.graphics.setColor(0.15,0.15,0.15,0.20)
				love.graphics.rectangle("fill", x+e.w/1.5/4,y-20,e.w/1.5,barheight)
		
				love.graphics.setColor(0.215,0.607,0.607,0.215)
				love.graphics.rectangle("fill", x+e.w/1.5/4,y-20,(e.shield/e.shieldmax)*(e.w/1.5),barheight)
		
				love.graphics.setColor(0.607,1,1,0.215)
				love.graphics.rectangle("line", x+e.w/1.5/4,y-20,e.w/1.5,barheight)
			end
			
			love.graphics.setColor(1,1,1,1)
			love.graphics.print("x pos:"..x, x-10,y-10)
			love.graphics.print("y pos:".. y, x-10,y)
			love.graphics.print("angle:"..math.floor(math.deg((e.angle or 0))), x-10,y+10)
			love.graphics.print("shield: "..math.floor(e.shield) .. "/" ..e.shieldmax, x-10,y+20)
			love.graphics.print("scale: "..e.scale, x-10,y+30)
			love.graphics.setColor(1,0.607,1,0.607)
			love.graphics.rectangle("line", x,y, e.w, e.h)
		end
	end
end


function enemies:rotate(e,n,dt)
	if not e.angle then e.angle = 0 end
	e.angle = e.angle + dt * n
	e.angle = e.angle % (2*math.pi)
end
