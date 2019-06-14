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
 
pickups = {}
--pickups.texture = love.graphics.newImage("data/gfx/pickups/template_small.png")
pickups.sound = love.audio.newSource("data/sfx/pickups/collect.ogg", "static")
pickups.chance = 15 --chance of a pickup being dropped

pickups.textures = {}

pickups.type = {
	[1] = love.graphics.newImage("data/gfx/pickups/shield.png"),
	[2] = love.graphics.newImage("data/gfx/pickups/energy.png"),
	[3] = love.graphics.newImage("data/gfx/pickups/orb.png"),
	[4] = love.graphics.newImage("data/gfx/pickups/blaster.png"),
	[5] = love.graphics.newImage("data/gfx/pickups/wave.png"),
	[6] = love.graphics.newImage("data/gfx/pickups/plasma.png"),
	[7] = love.graphics.newImage("data/gfx/pickups/beam.png"),
	[8] = love.graphics.newImage("data/gfx/pickups/rocket.png"),
	[9] = love.graphics.newImage("data/gfx/pickups/radial.png"),
	[10] = love.graphics.newImage("data/gfx/pickups/barrier.png"),
	
}



pickups.items = {} --active pickups on the starfield


function pickups:draw()
	
	for _, p in ipairs(pickups.items) do
		
		love.graphics.push()
		--love.graphics.setColor(p.r,p.g,p.b)
		love.graphics.setColor(1,1,1,1)
		love.graphics.translate(p.x+p.w/2,p.y+p.h/2)
		love.graphics.rotate(p.angle or 0)
		love.graphics.translate(-p.x-p.w/2,-p.y-p.h/2)
		
		 love.graphics.draw(pickups.type[p.type], p.x,p.y)
		
		love.graphics.pop()
		
		if debug then
			love.graphics.rectangle("line", p.x,p.y,p.w,p.h)
			love.graphics.print(p.xvel .. " " ..p.yvel,p.x-20,p.y-20)
		end
		
	end
end

function pickups:add(x,y)
	local n = love.math.random(1,#pickups.type)
	
	table.insert(pickups.items, {
		type = n,
		x = x,
		y = y,
		w = pickups.type[n]:getWidth(),
		h = pickups.type[n]:getHeight(),
		xvel =  love.math.random(-70,70),
		yvel =  love.math.random(-70,70),
		spin = (love.math.random(0,1) == 1 and 1 or -1)
	})
end

function pickups:update(dt)
	if paused then return end
	
	for i, p in ipairs(pickups.items) do
		p.x = p.x + (p.xvel *dt)
		p.y = p.y + (p.yvel *dt)
		
		
		enemies:rotate(p,p.spin,dt)
		
		if p.x+p.w > starfield.w then
			p.xvel = -p.xvel
		end
		if p.x < 0 then
			p.xvel = -p.xvel
		end
		if p.y +p.h > starfield.h then
			p.yvel = -p.yvel
		end
		if p.y < 0 then
			p.yvel = -p.yvel
		end


		if player.alive and collision:check(p.x,p.y,p.w,p.h,player.x,player.y,player.w,player.h) then
			sound:play(pickups.sound)
			
			if  p.type == 1 then 
					player.shield = player.shield + 20
					player.score = player.score + 150
				elseif p.type == 2 then 
					player.energy = player.energy + 20
					player.score = player.score + 150
					
				elseif p.type == 3 then 
					player.hasorb = true
					player.score = player.score + 500
					
				elseif p.type == 4 then 
					player.hasblaster = true
					player.score = player.score + 500
					
				elseif p.type == 5 then 
					player.haswave = true
					player.score = player.score + 500
					
				elseif p.type == 6 then 
					player.hasplasma = true
					player.score = player.score + 500
					
				elseif p.type == 7 then 
					player.hasbeam = true
					player.score = player.score + 500
					
				elseif p.type == 8 then 
					player.hasrocket = true
					player.score = player.score + 500
					
				elseif p.type == 9 then 
					player.hasradial = true
					player.score = player.score + 500
				
				elseif p.type == 10 then 
					player:addBarrier(dt)
					player.score = player.score + 500
						
			end
		


				
			table.remove(pickups.items, i)
		end

	end
end
