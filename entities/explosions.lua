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

explosions = {}
explosions.objects = {} --stores the active explosions

explosions.quad = love.graphics.newQuad
explosions.sprite = love.graphics.newImage("gfx/explosion/bleed/explosion.png")
explosions.min = 1
explosions.max = 13
explosions.size = explosions.sprite:getHeight()
explosions.quads = { }
explosions.quads['explosion'] = { }
explosions.red = 255
explosions.green = 255
explosions.blue = 255

local jy = 0
local jx = 0
for n=1,explosions.max do
	--load the sprites from a spritesheet 
	explosions.quads['explosion'][n] = explosions.quad(
		jx, 
		jy, 
		explosions.size, 
		explosions.size,  
		explosions.sprite:getWidth(), 
		explosions.sprite:getHeight()
	)
	
	jx = jx + explosions.size
end


function explosions:addobject(x,y,xvel,yvel)
	table.insert(self.objects, {
		frame = 1,
		delay = 0.05,
		cycle = 0,
		x = x,
		y = y,
		xvel = xvel,
		yvel = yvel,
		w = self.size,
		h = self.size,
	})
end


function explosions:update(dt)
	if paused then return true end
	
	for i=#self.objects,1,-1 do
		local e = self.objects[i]
		
		if e.x > starfield.w  or
			e.x + e.w < 0 or
			e.y + e.h < 0 or
			e.y > starfield.h 
		then
			table.remove(self.objects, i)
		end
		
		e.x = e.x - (e.xvel *dt)
		e.y = e.y - (e.yvel *dt)
		
		e.cycle = math.max(0, e.cycle - dt)
		
		if e.cycle <= 0 then
			e.frame = e.frame +1
			e.cycle = e.delay
			
			if e.frame >= self.max then
				table.remove(self.objects, i)
			end
			
		end
	end
end


function explosions:draw()
	love.graphics.setColor(170,170,255,205)
	
	for i=#self.objects,1,-1 do
		local e = self.objects[i]
		local x = math.floor(e.x)
		local y = math.floor(e.y)
		
		love.graphics.draw(
			self.sprite, self.quads['explosion'][e.frame],
			x,
			y,
			0, 1, 1
		)
		
		if debug then 
			love.graphics.rectangle("line",x,y,e.w,e.h)
		end
	end
	

end
