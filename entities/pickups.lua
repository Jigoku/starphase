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

pickups.items = {}

function pickups:draw()
	
	for _, p in ipairs(pickups.items) do
		local x = math.floor(p.x)
		local y = math.floor(p.y)
	
		love.graphics.setColor(p.r,p.g,p.b)
		love.graphics.draw(pickups.texture, x,y)
		if debug then
			love.graphics.rectangle("line", x,y,p.w,p.h)
		end
		
	end
end

function pickups:setvelocity()
    local rand = math.random(-70,70)
    if rand > -20 and rand < 20 then
        self:setvelocity()
    end
    return rand
end

function pickups:add(x,y)
	local gfx = pickups.texture
	table.insert(pickups.items, {
		gfx = gfx,
		x = x,
		y = y,
		w = pickups.texture:getWidth(),
		h = pickups.texture:getHeight(),
		xvel = pickups:setvelocity(),
		yvel = pickups:setvelocity(),
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

