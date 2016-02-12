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

function projectiles:update(dt)
	if paused then return end
	--process projectiles movement
	
	for i=#self,1,-1 do
		local p = self[i]
		
		if p.player then
			if p.type == "cannon" then
				p.x = p.x + math.floor(p.xvel *dt)
			end
			
			if p.x + p.w > starfield.w + p.w then
				table.remove(self, i)
			end
			
		end
	end
end


function projectiles:draw()
	for _, p in ipairs (projectiles) do
		love.graphics.setColor(p.r,p.g,p.b,255)


		if p.player then
			if p.type == "cannon" then
				love.graphics.draw(
					ship.cannon.texture,  p.x, 
					p.y, 0, 1, 1				
				)
			end
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
