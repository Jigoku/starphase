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
messagebox.fadespeed = 5
messagebox.textpadding = 10
messagebox.w = 650
messagebox.h = 128
messagebox.canvas = love.graphics.newCanvas(messagebox.w, messagebox.h)


function messagebox.active()
	if #messagebox.screens < 1 then
		return false
	end
	
	return true
end

function messagebox.queue(t)
	messagebox.screens = t
	for _,msg in ipairs(messagebox.screens) do
		msg.fade = 1
	end
	
	sound:play(sound.intercom[1])
end

function messagebox.update(dt)
	if paused then return end
	if #messagebox.screens > 0 then
		
		local msg = messagebox.screens[1]
		if msg.duration <= 0 then
			if msg.fade >= 0 then
				msg.fade = math.max(msg.fade - messagebox.fadespeed *dt,0)
			else
				table.remove(messagebox.screens,1)
				if #messagebox.screens < 1 then
					messagebox.callback()
				end
			end
		else
			if msg.fade < 1 then 
				msg.fade = math.min(msg.fade + messagebox.fadespeed *dt,1)
			else
				msg.duration = math.max(0, msg.duration - dt)
			end
		end
		
	end	
end


function messagebox.draw()
	if paused then return end

	
	if #messagebox.screens > 0 then
	
		love.graphics.setCanvas(messagebox.canvas)
		love.graphics.clear()
		
		local x = love.graphics.getWidth()/2 - messagebox.w/2
		local y = love.graphics.getHeight() - 100  - messagebox.h
		
		local msg = messagebox.screens[1]
	
		--fill
		love.graphics.setColor(0.0,0.05,0.05,0.6/1.5)
		love.graphics.rectangle("fill", 0,0, messagebox.w, messagebox.h)

		
		--face
		love.graphics.setColor(hud.colors.face)
		love.graphics.draw(msg.face,0,0,0,1,1,0,0)
		
				--line
		love.graphics.setColor(0.3,0.3,0.3,0.6)
		love.graphics.rectangle("line", 0,0, messagebox.w, messagebox.h)
		
		--name
		local of = love.graphics.getFont()
		love.graphics.setColor(0.2,0.7,0.6,1)
		love.graphics.setFont(fonts.message_header)
		love.graphics.print(msg.name,0+msg.face:getWidth()+messagebox.textpadding,0)
		
		--text
		love.graphics.setColor(0.7,0.7,0.7,1)
		love.graphics.setFont(fonts.message_content)
		love.graphics.print(msg.text,0+msg.face:getWidth()+messagebox.textpadding,0+30)
		
		love.graphics.setFont(of)
		
		love.graphics.setCanvas()
	
		love.graphics.setColor(1,1,1,msg.fade)
		love.graphics.draw(messagebox.canvas,x,y)
		
	end
	

	
end

return messagebox
