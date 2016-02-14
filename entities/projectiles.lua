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
 
projectiles = {}

projectiles.missiles = {}

projectiles.cannon = {}
projectiles.cannon.gfx = love.graphics.newImage("gfx/projectiles/cannon.png")
projectiles.cannon.damage = 30
projectiles.cannon.sound = {}
projectiles.cannon.sound.shoot = love.audio.newSource("sfx/projectiles/shoot.wav", "static")
projectiles.cannon.sound.shoot:setVolume(0.3)

function projectiles:update(dt)
	if paused then return end
	--process projectiles movement
	
	for i=#self.missiles,1,-1 do
		local p = self.missiles[i]
		
		--player projectiles
		if p.player then
			if p.type == "cannon" then
				p.x = p.x + math.floor(p.xvel *dt)
			end
			
			if p.x + p.w > starfield.w + p.w then
				table.remove(self.missiles, i)
			end
		--enemy projectiles
		elseif not p.player then
			p.x = p.x - math.floor(p.xvel *dt)
			if p.x - p.w < 0 then
				table.remove(self.missiles, i)
			end
			
			if ship.alive and collision:check(p.x,p.y,p.w,p.h, ship.x,ship.y,ship.w,ship.h) then
				table.remove(self.missiles, i)
				ship.shield = ship.shield - projectiles.cannon.damage
				if enemies.sound.explode:isPlaying() then
					enemies.sound.explode:stop()
				end
				enemies.sound.explode:play()
			end
		end
		
	end
end


function projectiles:draw()
	for _, p in ipairs (projectiles.missiles) do


		if p.player then
			love.graphics.setColor(p.r,p.g,p.b,255)
			if p.type == "cannon" then
				love.graphics.draw(
					projectiles.cannon.gfx,  p.x, 
					p.y, 0, 1, 1				
				)
			end
		elseif not p.player then
			love.graphics.setColor(p.r,p.g,p.b,255)
			love.graphics.draw(
				projectiles.cannon.gfx,  p.x, 
				p.y, 0, -1, 1,p.w				
			)
		end
		
		if debug then
			love.graphics.setColor(p.r,p.g,p.b,140)			
			love.graphics.rectangle(
				"line",
				p.x,
				p.y,
				p.w,
				p.h
			)
		end
		
	end
end
