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

local messagebox = {}

messagebox.screens = {}
messagebox.callback = function() return end
messagebox.fadespeed = 1000
messagebox.padding = 10
messagebox.x = 100
messagebox.y = 100
messagebox.w = 200
messagebox.h = 64

function messagebox.active()
	if #messagebox.screens < 1 then
		return false
	end
	
	return true
end

function messagebox.queue(table)
	messagebox.screens = table
	for _,splash in ipairs(messagebox.screens) do
		splash.fade = 0
	end
end

function messagebox.update(dt)
	if #messagebox.screens > 0 then
		
		local msg = messagebox.screens[1]
		if msg.duration <= 0 then
			if msg.fade > 0 then
				msg.fade = math.max(msg.fade - messagebox.fadespeed *dt,0)
			else
				table.remove(messagebox.screens,1)
				if #messagebox.screens < 1 then
					messagebox.callback()
				end
			end
		else
			if msg.fade < 255 then 
				msg.fade = math.min(msg.fade + messagebox.fadespeed *dt,255)
			else
				msg.duration = math.max(0, msg.duration - dt)
			end
		end
		
	end	
end


function messagebox.draw()
	if #messagebox.screens > 0 then
	
		local msg = messagebox.screens[1]
	
		--fill
		love.graphics.setColor(0,0,0,msg.fade-100)
		love.graphics.rectangle("fill", messagebox.x,messagebox.y, messagebox.w, messagebox.h)
		
		--face
		love.graphics.setColor(255,255,255,msg.fade)
		love.graphics.draw(msg.face,messagebox.x,messagebox.y)
		
		--name
		love.graphics.print(msg.name,messagebox.x+msg.face:getWidth()+messagebox.padding,messagebox.y)
		
		--text
		love.graphics.print(msg.text,messagebox.x+msg.face:getWidth()+messagebox.padding,messagebox.y+20)
	end
	
end

return messagebox
