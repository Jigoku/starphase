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

enemies.sound = {}
enemies.sound.hit = love.audio.newSource("sfx/projectiles/hit.wav", "static")
enemies.sound.hit:setVolume(1)
enemies.sound.explode = love.audio.newSource("sfx/projectiles/explode.wav", "static")
enemies.sound.explode:setVolume(0.7)
enemies.shield = love.graphics.newImage("gfx/shield.png")

function enemies:add_delta()

	local gfx = love.graphics.newImage("gfx/starship/6_small.png")
	
	local ny = math.random(0, starfield.h - gfx:getHeight()*4)
	local nx = starfield.w
	
	local xvel = 250
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
				score = 120,
				shield = 100,
				shieldopacity = 0,
			})
		ny = ny + gfx:getHeight()
		nx = nx + gfx:getWidth()
	end
end

function enemies:add_dart()

	local gfx = love.graphics.newImage("gfx/starship/7_small.png")
	
	
	table.insert(self.wave, {
				type = "dart",
				w = gfx:getWidth(),
				h = gfx:getHeight(),
				x = starfield.w,
				y = ship.y+starfield.offset/2+math.random(-200,200),
				yvel = 0,
				xvel = math.random(400,500),
				gfx = gfx or nil,
				score = 120,
				shield = 100,
				shieldopacity = 0,
	})


end


function enemies:add_tri()

	local gfx = love.graphics.newImage("gfx/starship/7_small.png")
	
	local rand = math.random(-200,200)
	table.insert(self.wave, {
			type = "tri",
				w = gfx:getWidth(),
				h = gfx:getHeight(),
				x = starfield.w,
				y = ship.y+starfield.offset/2+rand,
				yvel = math.random(-50,50),
				xvel = 170,
				gfx = gfx or nil,
				score = 120,
				shield = 100,
				angle = 0,
				shieldopacity = 0,
	})

	table.insert(self.wave, {
	type = "tri",
				w = gfx:getWidth(),
				h = gfx:getHeight(),
				x = starfield.w+gfx:getWidth(),
				y = ship.y+starfield.offset/2-gfx:getHeight()/2+rand,
				yvel = math.random(0,50),
				xvel = 150,
				gfx = gfx or nil,
				score = 120,
				shield = 100,
				angle = 0,
				shieldopacity = 0,
	})
	table.insert(self.wave, {
	type = "tri",
				w = gfx:getWidth(),
				h = gfx:getHeight(),
				x = starfield.w+gfx:getWidth(),
				y = ship.y+starfield.offset/2+gfx:getHeight()/2+rand,
				yvel = math.random(-50,0),
				xvel = 150,
				gfx = gfx or nil,
				score = 120,
				shield = 100,
				angle = 0,
				shieldopacity = 0,
	})
end


function enemies:add_large()

	local gfx = love.graphics.newImage("gfx/starship/6_large.png")
	
	
	table.insert(self.wave, {
	type = "large",
				w = gfx:getWidth(),
				h = gfx:getHeight(),
				x = starfield.w,
				y = ship.y+starfield.offset/2+math.random(-200,200),
				yvel = 0,
				xvel = 50,
				gfx = gfx or nil,
				score = 630,
				shield = 500,
				shieldopacity = 0,
	})


end


function enemies:update(dt)
	if paused then return end


	enemies.waveCycle = math.max(0, enemies.waveCycle - dt)
		
	if enemies.waveCycle <= 0 then

	
		local rand = math.random(0,3)
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
		enemies.waveCycle = math.random(2,4)
	end
	
	


	
	for i=#self.wave,1,-1 do
		local e = self.wave[i]
		

		if e.shieldopacity > 0 then
			e.shieldopacity = e.shieldopacity - 200 *dt
		else
			e.shieldopacity = 0
		end
		
		e.x = (e.x - e.xvel *dt)
		e.y= (e.y - e.yvel *dt)
	
		
		
		if not invincible and collision:check(e.x,e.y,e.w,e.h, ship.x,ship.y+starfield.offset/2,ship.w,ship.h) then

			ship.shield = ship.shield - 20
			table.remove(enemies.wave, i)
				
			if enemies.sound.explode:isPlaying() then
				enemies.sound.explode:stop()
			end
			enemies.sound.explode:play()
		end
		
		if e.x < 0  - e.w then
				table.remove(self.wave, i)
		end
		
		for z,p in pairs (ship.projectiles) do
			if collision:check(p.x,p.y,p.w,p.h, e.x,e.y,e.w,e.h) then
				e.shield = e.shield - p.damage
				e.shieldopacity = 100
				table.remove(ship.projectiles, z)
				
				if enemies.sound.hit:isPlaying() then
					enemies.sound.hit:stop()
				end
				enemies.sound.hit:play()
			end
		end
		
		if e.shield <= 0 then
			table.remove(self.wave, i)
			local rand = math.random(0,10)
			if rand > 8 then
				pickups:add(e.x+e.w/2,e.y+e.h/2)
			end
			
			if enemies.sound.explode:isPlaying() then
					enemies.sound.explode:stop()
			end
			enemies.sound.explode:play()
			
			hud.score = hud.score + e.score
		end
	end
	
end

function enemies:drawshield(e)
	if e.shieldopacity > 0 then
		love.graphics.setColor(100,200,255,e.shieldopacity)
		love.graphics.draw(
			enemies.shield,  math.floor(e.x)+e.w/2-enemies.shield:getWidth()/2, 
			math.floor(e.y)+e.h/2-enemies.shield:getHeight()/2, 0, 1, 1		
		)
	end
end

function enemies:draw()
	
	for _, e in pairs (self.wave) do
		local x = math.floor(e.x)
		local y = math.floor(e.y)
	
		if e.angle then
			--rotating face to ship
			e.angle = 0
			love.graphics.push()

			love.graphics.translate(e.x+e.w/2,e.y+e.h/2)
			love.graphics.rotate(math.atan2(starfield.offset/2+ship.y+ship.h/2-e.h/2 - e.y, ship.x+ship.w/2-e.w/2 - e.x))
			love.graphics.translate(-e.x-e.w/2,-e.y-e.h/2)
			
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(
				e.gfx,  x+e.w, 
				y, 0, 1, 1,e.w
				
			)
			enemies:drawshield(e)
			love.graphics.pop()
		else
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(
				e.gfx,  x+e.w, 
				y, 0, -1, 1
				
			)
			enemies:drawshield(e)
		end
		
		

		
		if debug then
			love.graphics.setColor(255,255,255,255)
			love.graphics.print("x:"..x, x-10,y-10)
			love.graphics.print("y:".. y, x-10,y)
			
			love.graphics.print("score : "..e.score, x-10,y+10)
			love.graphics.print("shield: "..e.shield, x-10,y+20)
			love.graphics.setColor(255,155,255,155)
			love.graphics.rectangle("line", x,y, e.w, e.h)
		end
	end
end


