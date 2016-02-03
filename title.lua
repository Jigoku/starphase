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

title = {}

title.active = "main"
title.maxoptions = 3
title.menu = {}
title.menu.w = 600
title.menu.h = 300
title.menu.x = love.graphics.getWidth()/2
title.menu.y = love.graphics.getHeight()/2-title.menu.h/3
title.menu.canvas = love.graphics.newCanvas(title.menu.w,title.menu.h)
title.menu.selected = 0

title.opacity = 255
title.opacitystep = 200
title.opacitymin = 100
title.opacitymax = 255

title.sounds = {}
title.sounds.option = love.audio.newSource("sfx/menu/option.wav",static)
title.sounds.select = love.audio.newSource("sfx/menu/select.wav",static)
	
	
function title:init()
	mode = "title"
	love.mouse.setVisible(false)
	love.mouse.setGrabbed(true)

	starfield.objects = {}
	enemies.wave = {}
	ship.projectiles = {}
	love.graphics.setBackgroundColor(0,0,0,255)
	
	music:play(1)
end

function title:update(dt)

		title.opacity = (title.opacity - title.opacitystep*dt)
		if title.opacity < title.opacitymin  then
		title.opacity = title.opacitymin
			title.opacitystep = -title.opacitystep
		end
		if title.opacity > title.opacitymax  then
			title.opacity = title.opacitymax
			title.opacitystep = -title.opacitystep
		end
		
end

function title:draw()


		love.graphics.setCanvas(title.menu.canvas)
		title.menu.canvas:clear()
		love.graphics.setColor(255,255,255,255)
	
		love.graphics.setFont(fonts.title_large)
		
		local wrap = 500
			
		--title
		love.graphics.setColor(200,200,200,155)
		love.graphics.printf("Star Phase", 0,0,wrap,"center",0,1,1)
		love.graphics.setColor(200,200,200,105)
		love.graphics.printf("Star Phase", 5,0,wrap,"center",0,1,1)

		--menu
		love.graphics.setFont(fonts.title_select)
		
		if title.active == "main" then
			self:itemselected(0)
			love.graphics.printf("Arcade mode", 300,100,wrap,"left",0,1,1)
			self:itemselected(1)
			love.graphics.printf("Infinite mode", 300,140,wrap,"left",0,1,1)
			self:itemselected(2)
			love.graphics.printf("Settings", 300,180,wrap,"left",0,1,1)
			self:itemselected(3)
			love.graphics.printf("Exit to desktop", 300,220,wrap,"left",0,1,1)
		elseif title.active == "settings" then
			self:itemselected(0)
			love.graphics.printf("Video", 300,100,wrap,"left",0,1,1)
			self:itemselected(1)
			love.graphics.printf("Sound", 300,140,wrap,"left",0,1,1)
			self:itemselected(2)
			love.graphics.printf("About", 300,180,wrap,"left",0,1,1)
			self:itemselected(3)
			love.graphics.printf("Back", 300,220,wrap,"left",0,1,1)
		elseif title.active == "video" then
			self:itemselected(0)
			love.graphics.printf("Back", 300,100,wrap,"left",0,1,1)
		elseif title.active == "sound" then
			self:itemselected(0)
			love.graphics.printf("Back", 300,100,wrap,"left",0,1,1)
		elseif title.active == "about" then
			self:itemselected(0)
			love.graphics.printf("Back", 300,100,wrap,"left",0,1,1)
		end
		love.graphics.setFont(fonts.default)
		love.graphics.setCanvas()

		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(title.menu.canvas,title.menu.x,title.menu.y)

		love.graphics.printf("v0.01-dev (by ricky thomson)",50,love.graphics.getHeight()-50,300,"left",0,1,1)		--version
		if debug then
			love.graphics.rectangle("line", title.menu.x,title.menu.y,title.menu.w,title.menu.h)
		end
end



function title:itemselected(selected)
	if title.menu.selected == selected then
		love.graphics.setColor(-title.opacity,title.opacity,-title.opacity/2,title.opacity)
	else
		love.graphics.setColor(255,255,255,100)
	end
end

function title:keypressed(key)
		if key == "escape" then love.event.quit() end
		

			if key == "up" then 
				title.sounds.option:play() 
				title.menu.selected = title.menu.selected -1 
				title.opacity = 255 
			end
			if key == "down" then 
				title.sounds.option:play() 
				title.menu.selected = title.menu.selected +1 
				title.opacity = 255 
			end
			

			
			if key == "return" then

			
				title.sounds.select:play()
				
				if title.active == "main" then
					if title.menu.selected == 1 then initarcade() end
					if title.menu.selected == 2 then title.active = "settings" title.maxoptions = 3 end
					if title.menu.selected == 3 then love.event.quit() end
				elseif title.active == "settings" then
					if title.menu.selected == 0 then title.active = "video" title.maxoptions = 0 end
					if title.menu.selected == 1 then title.active = "sound" title.maxoptions = 0 end
					if title.menu.selected == 2 then title.active = "about" title.maxoptions = 0 end
					if title.menu.selected == 3 then title.active = "main" title.maxoptions = 3 end
				elseif title.active == "video" then
					if title.menu.selected == 0 then title.active = "settings" title.maxoptions = 3  end
				elseif title.active == "sound" then
					if title.menu.selected == 0 then title.active = "settings" title.maxoptions = 3 end
				elseif title.active == "about" then
					if title.menu.selected == 0 then title.active = "settings" title.maxoptions = 3 end
				end

			end
			
			if title.menu.selected < 0 then title.menu.selected = 0 end
			if title.menu.selected > title.maxoptions then title.menu.selected = title.maxoptions end
		
end
