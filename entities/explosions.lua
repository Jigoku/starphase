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

explosions.sounds = {
	[1] = love.audio.newSource("sfx/explosions/unnamed/explosion01.ogg"),
	[2] = love.audio.newSource("sfx/explosions/unnamed/explosion02.ogg"),
	[3] = love.audio.newSource("sfx/explosions/unnamed/explosion03.ogg"),
	[4] = love.audio.newSource("sfx/explosions/unnamed/explosion04.ogg"),
	[5] = love.audio.newSource("sfx/explosions/unnamed/explosion05.ogg"),
	[6] = love.audio.newSource("sfx/explosions/unnamed/explosion06.ogg"),
	[7] = love.audio.newSource("sfx/explosions/unnamed/explosion07.ogg"),
	[8] = love.audio.newSource("sfx/explosions/unnamed/explosion08.ogg"),
	[9] = love.audio.newSource("sfx/explosions/unnamed/explosion09.ogg"),
}

explosions.large_sprite = love.graphics.newImage("gfx/explosion/bleed/explosion.png")
explosions.large_size = explosions.large_sprite:getHeight()
explosions.large_min = 1
explosions.large_max = 13
explosions.large_quads = loadsprite(explosions.large_sprite, explosions.large_size, explosions.large_max )


explosions.small_sprite = love.graphics.newImage("gfx/explosion/jswars/explosion2.png")
explosions.small_size = explosions.small_sprite:getHeight()
explosions.small_min = 1
explosions.small_max = 17
explosions.small_quads = loadsprite(explosions.small_sprite, explosions.small_size, explosions.small_max )



function explosions:addLarge(x,y,xvel,yvel)
	table.insert(self.objects, {
		type = "large",
		frame = self.large_min,
		maxframes = self.large_max,
		delay = 0.05,
		cycle = 0,
		x = x-self.large_size/2,
		y = y-self.large_size/2,
		xvel = xvel,
		yvel = yvel,
		w = self.large_size,
		h = self.large_size,
	})
end

function explosions:addSmall(x,y,xvel,yvel)
	table.insert(self.objects, {
		type = "small",
		frame = self.small_min,
		maxframes = self.small_max,
		delay = 0.04,
		cycle = 0,
		x = x-self.small_size/2,
		y = y-self.small_size/2,
		xvel = xvel,
		yvel = yvel,
		w = self.small_size,
		h = self.small_size,
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
			
			if e.frame >= e.maxframes then
				table.remove(self.objects, i)
			end
			
		end
	end
end


function explosions:draw()
	
	for i=#self.objects,1,-1 do
		local e = self.objects[i]
		local x = math.floor(e.x)
		local y = math.floor(e.y)
		
		if e.type == "large" then
			love.graphics.setColor(170,170,255,205)
			love.graphics.draw(
				self.large_sprite, self.large_quads[e.frame],
				x,
				y,
				0, 1, 1
			)
		elseif e.type == "small" then
			love.graphics.setColor(160,255,255,250)
			love.graphics.draw(
				self.small_sprite, self.small_quads[e.frame],
				x,
				y,
				0, 1, 1
			)
		end
		
		if debug then 
			love.graphics.setColor(255,190,70,140)
			love.graphics.rectangle("line",x,y,e.w,e.h)
		end
	end
	

end
