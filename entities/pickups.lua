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
pickups.texture = love.graphics.newImage("gfx/pickups/template_small.png")


pickups.type = {
	shield = love.graphics.newImage("gfx/pickups/shield.png"),
	energy = love.graphics.newImage("gfx/pickups/energy.png"),
	speed = love.graphics.newImage("gfx/pickups/speed.png"),
	mystery = love.graphics.newImage("gfx/pickups/mystery.png"),
}

pickups.items = {} --active pickups on the starfield


function pickups:draw()
	
	for _, p in ipairs(pickups.items) do
		local x = math.floor(p.x)
		local y = math.floor(p.y)
	
		--love.graphics.setColor(p.r,p.g,p.b)
		love.graphics.setColor(255,255,255,255)
		
		if 		   p.type == 1 then love.graphics.draw(pickups.type.shield, x,y)
			elseif p.type == 2 then love.graphics.draw(pickups.type.energy, x,y)
			elseif p.type == 3 then love.graphics.draw(pickups.type.speed, x,y)
			elseif p.type == 4 then love.graphics.draw(pickups.type.mystery, x,y)
		end
		
		if debug then
			love.graphics.rectangle("line", x,y,p.w,p.h)
			love.graphics.print(p.xvel .. " " ..p.yvel,x-20,y-20)
		end
		
	end
end

function pickups:add(x,y)

	table.insert(pickups.items, {
		type = math.random(1,misc:count(pickups.type)),
		x = x,
		y = y,
		w = pickups.texture:getWidth(),
		h = pickups.texture:getHeight(),
		xvel =  math.random(-70,70),
		yvel =  math.random(-70,70),
		r = math.random(100,255),
		g = math.random(100,255),
		b = math.random(100,255),
	})
end

function pickups:update(dt)
	if paused then return end
	
	for i, p in ipairs(pickups.items) do
		p.x = p.x + p.xvel *dt
		p.y = p.y + p.yvel *dt
		
		if p.x+p.w > love.graphics.getWidth() then
			p.xvel = -p.xvel
		end
		if p.x < 0 then
			p.xvel = -p.xvel
		end
		if p.y > starfield.h then
			p.yvel = -p.yvel
		end
		if p.y < 0 then
			p.yvel = -p.yvel
		end
		
		if ship.alive and collision:check(p.x,p.y,p.w,p.h,ship.x,ship.y,ship.w,ship.h) then
			table.remove(pickups.items, i)
		end
	end

		
end

