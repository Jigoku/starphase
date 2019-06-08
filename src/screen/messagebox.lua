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

messagebox.scanline = true
messagebox.scanlinepos = 0
messagebox.scanlinespeed = 50
messagebox.scanlineh = 20


function messagebox.active()
	if #messagebox.screens < 1 then
		return false
	end
	return true
end

function messagebox.queue(t)
	messagebox.screens = t
	for _,msg in ipairs(messagebox.screens) do
		msg.x = love.graphics.getWidth()/2 - messagebox.w/2
		msg.y = love.graphics.getHeight() - 100  - messagebox.h
		msg.w = messagebox.w
		msg.h = messagebox.h/2
		msg.fade = 0
	end
	sound:play(sound.intercom[1])
end

function messagebox.update(dt)
	if paused then return end
	if #messagebox.screens > 0 then
		
		local msg = messagebox.screens[1]	
		messagebox.scanlinepos = messagebox.scanlinepos + messagebox.scanlinespeed *dt
		if messagebox.scanlinepos > (msg.h+messagebox.scanlineh)*2 then messagebox.scanlinepos = -messagebox.scanlineh end

		if msg.duration <= 0 then
			if msg.h > 0 then
				msg.h = math.min(messagebox.h, msg.h - 300 *dt)
			end	
			
			if msg.fade > 0 then
				msg.fade = math.max(msg.fade - messagebox.fadespeed *dt,0)	
			else
				table.remove(messagebox.screens,1)
				sound:play(sound.intercom[1])
				if #messagebox.screens < 1 then
					messagebox.callback()
				end
			end
		else
		
			if msg.h < messagebox.h-2 then
				msg.h = math.max(0,msg.h + 300 *dt)
			end
			
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
		
		local msg = messagebox.screens[1]

		--background box
		love.graphics.setColor(hud.colors["frame_dark"])
		love.graphics.rectangle("fill", 0,0, msg.w, msg.h)
		
		love.graphics.setLineWidth(4)
		love.graphics.setColor(hud.colors["frame"])
		love.graphics.rectangle("line", 0,0, msg.w, msg.h)
		
		
		--face/event portrait
		love.graphics.setColor(hud.colors.face)
		love.graphics.draw(msg.face,love.math.random(-0.5,0.5),0,0,1,msg.h/msg.face:getHeight(),0,0)
		
		--dividing line
		love.graphics.setLineWidth(2)
		love.graphics.setColor(hud.colors["frame"])
		love.graphics.line(msg.face:getWidth()+1,2,msg.face:getWidth()+1,msg.h-2)
		
		--white noise
		love.graphics.setColor(0.5,0.5,0.5,1)
		for i=1, 100 do
			love.graphics.points(love.math.random(0,msg.face:getWidth()), love.math.random(0,msg.h))
		end
		
		--scan line effects
		love.graphics.setLineWidth(4)
		love.graphics.setColor(0.1,0.3,0.3,0.3)
		for i=1, 10 do
			local h = love.math.random(0,msg.h)
			love.graphics.line(0,h, msg.face:getWidth(), h)
		end
		love.graphics.setLineWidth(love.math.random(2,messagebox.scanlineh))
		love.graphics.setColor(hud.colors["frame"])
		love.graphics.line(0,messagebox.scanlinepos, msg.face:getWidth(), messagebox.scanlinepos)
		
		--set elsewhere?
		love.graphics.setLineWidth(2)
		
		--name
		local of = love.graphics.getFont()
		love.graphics.setColor(hud.colors["frame"][1]/2,hud.colors["frame"][2],hud.colors["frame"][3]*2,1)
		love.graphics.setFont(fonts.message_header)
		love.graphics.print(msg.name,0+msg.face:getWidth()+messagebox.textpadding,0)
		
		--text
		love.graphics.setColor(0.7,0.7,0.7,1)
		love.graphics.setFont(fonts.message_content)
		love.graphics.print(msg.text,0+msg.face:getWidth()+messagebox.textpadding,0+30)
		
		love.graphics.setFont(of)
		
		love.graphics.setCanvas()
	
		love.graphics.setColor(1,1,1,msg.fade)
		love.graphics.draw(messagebox.canvas,msg.x,msg.y)		
	end
end

return messagebox
