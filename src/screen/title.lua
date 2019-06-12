--[[
 * Copyright (C) 2016-2019 Ricky K. Thomson
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
title.splash = true
title.splash_logo = love.graphics.newImage("gfx/artsoftware.png")
title.splashDelay = 2
title.splashCycle = 2
title.splashOpacity = 1

title.active = "main"
title.menu = {}
title.menu.w = 600
title.menu.h = 400
title.menu.x = love.graphics.getWidth() - title.menu.w
title.menu.y = title.menu.h - title.menu.h/4
title.menu.canvas = love.graphics.newCanvas(title.menu.w,title.menu.h)
title.menu.selected = 1

title.opacity = 1
title.opacitystep = 1
title.opacitymin = 0.4
title.opacitymax = 1

title.overlay = {}
title.overlay.opacity = 0
title.overlay.fadeout = false
title.overlay.fadein = false
title.overlay.fadespeed = 0.58

title.scene_timer = 0
title.scene_delay = 5

title.sounds = {}
title.sounds.option = love.audio.newSource("sfx/menu/option.ogg","static")
title.sounds.select = love.audio.newSource("sfx/menu/select.ogg","static")
title.sounds.option:setVolume(0.75)
title.sounds.select:setVolume(0.75)
	
title.ship1 = love.graphics.newImage("gfx/player/1_large.png")
title.ship2 = love.graphics.newImage("gfx/player/2_large.png")
title.ship3 = love.graphics.newImage("gfx/player/3_large.png")


title.gradient = love.graphics.newImage("gfx/gradient_black.png")


function title:init()
	starfield:setSeed()
	title.overlay.fadein = true
	title.overlay.opacity = 1
	title.maxoptions = 6
	paused = false
	mode = "title"
	title.active = "main"
	love.mouse.setVisible(true)
	love.mouse.setGrabbed(true)
	starfield.offset = 0  
	starfield.speed = 0
	starfield.minspeed = 10
	starfield.maxspeed = 1000
	starfield:populate()
	love.graphics.setBackgroundColor(0,0,0,1)
	
	sound:playbgm(1)
end

function title:update(dt)
	


	if title.splash then
		title.splashCycle = math.max(0, title.splashCycle - dt)
		
		if title.splashCycle <= 0 then
			if title.splashOpacity > 0 then
				title.splashOpacity = title.splashOpacity - 0.4 *dt
			else
				title.overlay.fadein = true
				title.splashCycle = title.splashDelay
				title.splash = false
			end
		end
	
		return
	
	end

--[[ debugging
	title.scene_timer = math.max(0, title.scene_timer - dt)
	if title.scene_timer <= 0 then
		title.scene_timer = title.scene_delay
		
		starfield:setSeed()
		starfield:populate()
		
	end
	--]]
	
	--main title sequence
	

	title.opacity = (title.opacity - title.opacitystep*dt)
	if title.opacity < title.opacitymin  then
	title.opacity = title.opacitymin
		title.opacitystep = -title.opacitystep
	end
	if title.opacity > title.opacitymax  then
		title.opacity = title.opacitymax
		title.opacitystep = -title.opacitystep
	end		
	
	if title.overlay.fadeout then
		title.overlay.opacity = title.overlay.opacity +title.overlay.fadespeed *dt
		
		if title.overlay.opacity > 1 then
			title.overlay.opacity = 0
			title.overlay.fadeout = false
		end
	end
	
	if title.overlay.fadein then
		title.overlay.opacity = title.overlay.opacity -title.overlay.fadespeed *dt
		
		if title.overlay.opacity < 0 then
			title.overlay.opacity = 0
			title.overlay.fadein = false
		end
	end
	
	starfield:update(dt)

end

function title:draw()
	if title.splash then
		love.graphics.setColor(1,1,1,title.splashOpacity)
		love.graphics.draw(title.splash_logo,love.graphics.getWidth()/2-title.splash_logo:getWidth()/2, love.graphics.getHeight()/2-title.splash_logo:getHeight()/2)
		return
	end
	
	starfield:draw(0,0)

	

	if debugstarfield then	
		love.graphics.setColor(1,1,1,0.8)
		--love.graphics.setFont(fonts.title_select)
		love.graphics.setFont(fonts.labels)
		love.graphics.print("Press [tab] to reseed, [escape] to quit", 20, 10)		
		return 
	 end

	
	
	
	
	love.graphics.setColor(1,1,1,1)
	for i=0, love.graphics.getHeight(), 1 do
		love.graphics.draw(title.gradient, love.graphics.getWidth()-title.gradient:getWidth()/2,i,0,0.5,1)
	end
			
	love.graphics.setCanvas(title.menu.canvas)
	love.graphics.clear()
	

	love.graphics.setFont(fonts.title_large)		
	local wrap = 500
			
	--title
	love.graphics.setColor(1,1,1,0.9)
	love.graphics.printf("Star Phase", 0,0,wrap,"center",0,1,1)
	love.graphics.setColor(1,1,1,0.4)
	love.graphics.printf("Star Phase", 10,0,wrap,"center",0,1,1)

	--menu
	love.graphics.setFont(fonts.title_select)
		
	if title.active == "main" then
		self:itemselected(1)
		love.graphics.printf("Infinite mode", 300,100,wrap,"left",0,1,1)
		self:itemselected(2)
		love.graphics.printf("Debug mode", 300,140,wrap,"left",0,1,1)
		self:itemselected(3)
		love.graphics.printf("Settings", 300,180,wrap,"left",0,1,1)
		self:itemselected(4)
		love.graphics.printf("Space Viewer", 300,220,wrap,"left",0,1,1)
		self:itemselected(5)
		love.graphics.printf("Credits", 300,260,wrap,"left",0,1,1)
		self:itemselected(6)
		love.graphics.printf("Exit to desktop", 300,300,wrap,"left",0,1,1)
	elseif title.active == "settings" then
		self:itemselected(1)
		love.graphics.printf("Video", 300,100,wrap,"left",0,1,1)
		self:itemselected(2)
		love.graphics.printf("Sound", 300,140,wrap,"left",0,1,1)
		self:itemselected(3)
		love.graphics.printf("Controls", 300,180,wrap,"left",0,1,1)
		self:itemselected(4)
		love.graphics.printf("Back", 300,220,wrap,"left",0,1,1)
	elseif title.active == "video" then
		self:itemselected(1)
		love.graphics.printf("Back", 300,100,wrap,"left",0,1,1)
	elseif title.active == "sound" then
		self:itemselected(1)
		love.graphics.printf("Back", 300,100,wrap,"left",0,1,1)
	elseif title.active == "controls" then
		self:itemselected(1)
		love.graphics.printf("Back", 300,100,wrap,"left",0,1,1)
	elseif title.active == "ship_selection" then
		self:itemselected(1)
		love.graphics.printf("Ship 1", 300,100,wrap,"left",0,1,1)
		self:itemselected(2)
		love.graphics.printf("Ship 2", 300,140,wrap,"left",0,1,1)
		self:itemselected(3)
		love.graphics.printf("Ship 3", 300,180,wrap,"left",0,1,1)
		self:itemselected(4)
		love.graphics.printf("Back", 300,220,wrap,"left",0,1,1)
	end
	
			
	love.graphics.setColor(1,1,1,1)
	if title.active == "ship_selection" then
		if title.menu.selected == 1 then
			love.graphics.draw(title.ship3, 50,100, 0,0.5)
		elseif title.menu.selected == 2 then
			love.graphics.draw(title.ship1, 50,100, 0,0.5)
		elseif title.menu.selected == 3 then
			love.graphics.draw(title.ship2, 50,100, 0,0.5)
		end
	end
	
	
	love.graphics.setCanvas()

	--border bars
	local h = 200
	love.graphics.setColor(0,0,0,1)
	love.graphics.rectangle("fill",0,love.graphics.getHeight()-h,love.graphics.getWidth(),h)
	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),h)
	
	love.graphics.setColor(0.3,0.3,0.3,0.5)
	love.graphics.line(0,love.graphics.getHeight()-h,love.graphics.getWidth(),love.graphics.getHeight()-h)
	love.graphics.line(0,h,love.graphics.getWidth(),h)
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(title.menu.canvas,title.menu.x,title.menu.y)
	
	
	love.graphics.setColor(1,1,1,0.4)
	love.graphics.setFont(fonts.default)
	local infostr = "v"..version..build.." ("..love.system.getOS() ..") by "..author
	love.graphics.printf(infostr,10,love.graphics.getHeight()-20,love.graphics.getWidth(),"center",0,1,1)		--version
	
	love.graphics.setColor(0,0,0,title.overlay.opacity)
	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
	
	

	
	if debug then
		love.graphics.rectangle("line", title.menu.x,title.menu.y,title.menu.w,title.menu.h)
	end
	


end


function title:navigate(d)
	sound:play(title.sounds.option)
	title.menu.selected = math.min(title.maxoptions,math.max(1,title.menu.selected + d))
	title.opacity = 1 
	starfield:setSeed()
	starfield:populate()
end


function title:itemselected(selected)
	if title.menu.selected == selected then
		love.graphics.setColor(title.opacity*2,title.opacity*2,title.opacity*2,title.opacity)
	else
		love.graphics.setColor(0.5,0.5,0.5,0.5)
	end
end

function title:keypressed(key)

	if debugstarfield then
		if key == "escape" then 
			title.menu.selected = 4
			debugstarfield = false
		elseif key == "tab" then
			starfield:setSeed()
			starfield:setColor()
			starfield:populate()		
		end
		return
	end
	
	if key == "escape" then 
		love.event.quit() 		
	end
	
	
	if title.splash then 
		if key == "space" then 
			title.splash = false 
			
			return 
		end
	end
	
	if key == "up" then 
		self:navigate(-1)
	end
	if key == "down" then 
		self:navigate(1)
	end
		
		
	
	

	
	
	
	if key == "return" then

		sound:play(title.sounds.select)
				
		if title.active == "main" then
			if title.menu.selected == 1 then title.active = "ship_selection" title.maxoptions = 4 end
			if title.menu.selected == 2 then initdebugarcade(3) end
			if title.menu.selected == 3 then title.active = "settings" title.maxoptions = 4 end
			if title.menu.selected == 4 then debugstarfield = not debugstarfield end
			if title.menu.selected == 6 then love.event.quit() end
		elseif title.active == "settings" then
			if title.menu.selected == 1 then title.active = "video" title.maxoptions = 1 end
			if title.menu.selected == 2 then title.active = "sound" title.maxoptions = 1 end
			if title.menu.selected == 3 then title.active = "controls" title.maxoptions = 1 end
			if title.menu.selected == 4 then title.active = "main" title.maxoptions = 6 end
		elseif title.active == "video" then
			if title.menu.selected == 1 then title.active = "settings" title.maxoptions = 4  end
		elseif title.active == "sound" then
			if title.menu.selected == 1 then title.active = "settings" title.maxoptions = 4 end
		elseif title.active == "controls" then
			if title.menu.selected == 1 then title.active = "settings" title.maxoptions = 4 end
		elseif title.active == "ship_selection" then
			if title.menu.selected == 1 then initarcade(3) end
			if title.menu.selected == 2 then initarcade(1) end
			if title.menu.selected == 3 then initarcade(2) end
			if title.menu.selected == 4 then title.active = "main" title.maxoptions = 6 end
		end
				
		title.menu.selected = 1
	end
			
	if title.menu.selected < 1 then title.menu.selected = 1 end
	if title.menu.selected > title.maxoptions then title.menu.selected = title.maxoptions end
		
end
