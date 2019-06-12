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
 
hud = {}
hud.life_gfx = love.graphics.newImage("gfx/life.png")

--cyan theme
hud.colors = {
	["frame"] = {0.607,1,1,0.196},
	["face"] = {0.607,1,1,0.9},
	["frame_dark"] = {0.039,0.039,0.039,0.65},
	["lives"] = {0.39,0.745,0.784,0.470},
}


--pink/purple
--[[
hud.colors = {
	["frame"] = {1,0.607,1,0.196},
	["face"] = {1,0.607,1},
	["frame_dark"] = {0.039,0.039,0.039,0.39},
	["lives"] = {0.745,0.39,0.784,0.470},
}
--]]





function hud:init()
	hud.display = {
		w = 900,
		h = 30,
		offset = 30,
		canvas = love.graphics.newCanvas(w, h),
		progress = 0.0,
		progress_speed = 1.5, -- 1 minute
		progress_speed = 1.0, -- 1 minute 30 seconds
		timer = os.time(),
	}	
	hud.warp = false
	hud.time = 0
	
	hud.warning = false
	hud.warninggfx = love.graphics.newImage("gfx/warning.png")
	hud.warning_quad = love.graphics.newQuad(0,0, love.graphics.getWidth(), love.graphics.getHeight(), hud.warninggfx:getDimensions() )
	hud.warningmin = 0
	hud.warningmax = 0.5
	hud.warningspeed = 1.0
	hud.warning_text = "SHIELD LOW"
	
	
end


hud.console = {
	w = 720,
	h = 250,
	x = 10,
	y = -250,
	canvas = love.graphics.newCanvas(w, h),
	speed = 400,
	opacity = 1,
}




function hud:update(dt)

	if hud.display.progress > hud.display.w then
		hud.display.progress = hud.display.w
		print ("reached destination")
		--implement scoreboard / statistic screen
	end

	if paused then return end
	hud.display.progress = hud.display.progress + hud.display.progress_speed *dt
	hud.time = hud.time + 1 *dt
	
	
	if hud.warp then

	end
	
	if hud.warning then
		if hud.warningmin <=0 then 
			hud.warningmin = hud.warningmax
		else
			hud.warningmin = hud.warningmin - hud.warningspeed *dt
		end
	end
	
end


function hud:updateconsole(dt)
	if debug then

		hud.console.y = hud.console.y + hud.console.speed *dt
		if hud.console.y >= 0 then
			hud.console.y = 0
		end

	else
		hud.console.y = hud.console.y - hud.console.speed *dt
		if hud.console.y  <= -hud.console.h then
			hud.console.y = -hud.console.h
		end
	end

end

function hud:drawFrames()

	if hud.warp then
		love.graphics.setColor(hud.colors["frame"][1],hud.colors["frame"][2],hud.colors["frame"][3],hud.colors["frame"][4])
	else
		love.graphics.setColor(hud.colors["frame"][1],hud.colors["frame"][2],hud.colors["frame"][3],hud.colors["frame"][4])
	end
		--dynamic decor/lines
		--[[love.graphics.setColor(
			starfield.nebulae.red,
			starfield.nebulae.green,
			starfield.nebulae.blue,
			50
		)--]]
	
	love.graphics.setLineWidth(2)
	love.graphics.setLineStyle("smooth")
	
	--left side
	love.graphics.line(
		60,love.graphics.getHeight()-20,
		20,love.graphics.getHeight()-40
	)
	love.graphics.line(
		love.graphics.getWidth()/5+1,love.graphics.getHeight()-20,
		love.graphics.getWidth()/5+40,love.graphics.getHeight()-40
	)	
	love.graphics.line(
		61,love.graphics.getHeight()-20,
		love.graphics.getWidth()/5,love.graphics.getHeight()-20
	)
	
	love.graphics.line(
		20,41,
		20,love.graphics.getHeight()-41
	)
	
	
	love.graphics.line(
		60,20,
		20,40
	)
	love.graphics.line(
		love.graphics.getWidth()/5+1,20,
		love.graphics.getWidth()/5+40,40
	)	
	love.graphics.line(
		61,20,
		love.graphics.getWidth()/5,20
	)
	
	
	--right side
	love.graphics.line(
		love.graphics.getWidth()-60,love.graphics.getHeight()-20,
		love.graphics.getWidth()-20,love.graphics.getHeight()-40
	)
	love.graphics.line(
		love.graphics.getWidth()-love.graphics.getWidth()/5-1,love.graphics.getHeight()-20,
		love.graphics.getWidth()-love.graphics.getWidth()/5-40,love.graphics.getHeight()-40
	)
	love.graphics.line(
		love.graphics.getWidth()-61,love.graphics.getHeight()-20,
		love.graphics.getWidth()-love.graphics.getWidth()/5,love.graphics.getHeight()-20
	)
	
	love.graphics.line(
		love.graphics.getWidth()-20,41,
		love.graphics.getWidth()-20,love.graphics.getHeight()-41
	)


	love.graphics.line(
		love.graphics.getWidth()-60,20,
		love.graphics.getWidth()-20,40
	)
	
	love.graphics.line(
		love.graphics.getWidth()-love.graphics.getWidth()/5-1,20,
		love.graphics.getWidth()-love.graphics.getWidth()/5-40,40
	)
	love.graphics.line(
		love.graphics.getWidth()-61,20,
		love.graphics.getWidth()-love.graphics.getWidth()/5,20
	)
	
	
	-- hud frame for bottom of screen
	local w = 510
	local a = 20
	
	local points = {
		love.graphics.getWidth()/2-w,love.graphics.getHeight()+1,
		love.graphics.getWidth()/2-w+a,love.graphics.getHeight()-70,
		love.graphics.getWidth()/2+w-a,love.graphics.getHeight()-70,
		love.graphics.getWidth()/2+w,love.graphics.getHeight()+1
	}
	
	love.graphics.setColor(hud.colors["frame_dark"][1],hud.colors["frame_dark"][2],hud.colors["frame_dark"][3],hud.colors["frame_dark"][4])
	love.graphics.polygon("fill", points)
	
	love.graphics.setColor(hud.colors["frame"][1],hud.colors["frame"][2],hud.colors["frame"][3],hud.colors["frame"][4])
	love.graphics.polygon("line", points)
	
	love.graphics.setLineWidth(1)
	
end 

function hud:draw()
	
	if hud.warning then
		love.graphics.setColor(1,0,0,hud.warningmin)
		love.graphics.draw(
			hud.warninggfx, hud.warning_quad, 0,0, 0, love.graphics.getWidth()/hud.warninggfx:getWidth(), love.graphics.getHeight()/hud.warninggfx:getHeight()
		)	

	end


	if paused and not debug then 

		love.graphics.setColor(0,0,0,0.549)
		love.graphics.rectangle("fill",0,0,love.graphics.getWidth(), love.graphics.getHeight())
    
		love.graphics.setFont(fonts.paused_large)
		love.graphics.setColor(1,1,1,0.784)
		love.graphics.printf("PAUSED", love.graphics.getWidth()/2-150,love.graphics.getHeight()/3,300,"center")
		love.graphics.setFont(fonts.default)
		local wrap = 200
		love.graphics.setFont(fonts.paused_small)
		love.graphics.setColor(1,1,1,0.784)
		love.graphics.printf("Press "..string.upper(binds.pausequit).." to quit", love.graphics.getWidth()/2-wrap/2,love.graphics.getHeight()/3+50,wrap,"center",0,1,1)
		love.graphics.setFont(fonts.default)
		return
	
	end
	
  --hud
	--decor / lines
	if not debug then
		hud:drawFrames()
	end
	
	
	if debugarcade then
		love.graphics.setFont(fonts.default)
		love.graphics.setColor(0.588,1,1,0.784)
		love.graphics.print("DEBUG:\npress M for message system\npress [ or ] to adjust starfield speed\npress 1-9 to spawn enemies\npress space to set new starfield seed\npress ` for console/debug overlay\npress k to spawn powerup", 30, starfield.h-400)
	end
	

	--warning text
	if hud.warning then
		love.graphics.setFont(fonts.hud_warning)
		love.graphics.setColor(1,0.2,0.2,1-hud.warningmin)	
		love.graphics.print(hud.warning_text,love.graphics.getWidth()-350,love.graphics.getHeight()-80)
		love.graphics.setColor(1,1,1,hud.warningmin)
		love.graphics.print(hud.warning_text,love.graphics.getWidth()-350+5,love.graphics.getHeight()-80)
	end
	
	
	
	--time
	love.graphics.setColor(1,1,1,0.4)
	love.graphics.setFont(fonts.timer)
	love.graphics.printf(misc:formatTime(hud.time), love.graphics.getWidth()/2-150,20,300,"center",0,1,1)
	love.graphics.setFont(fonts.default)
	
	--lives (temporary)

	love.graphics.printf("lives: ", love.graphics.getWidth()/2,60,0,"center",0,1,1)
	for i=1,player.lives do
		love.graphics.setColor(
			hud.colors["lives"][1],hud.colors["lives"][2],hud.colors["lives"][3],hud.colors["lives"][4]
		)
		love.graphics.draw(hud.life_gfx,(25*i)+50,love.graphics.getHeight()-80,0,1,1)
	end
	
	--display 
	love.graphics.setCanvas(hud.display.canvas)
	love.graphics.clear()

	love.graphics.setColor(1,1,1,1)

	hud:drawProgress()
	
	
	love.graphics.setFont(fonts.hud)
		
	--progress
	love.graphics.setColor(1,1,1,0.607)
	love.graphics.print("Wave Progress : " .. math.floor(hud.display.progress/hud.display.w*100).."%", 10,hud.display.h)	
	--score
	love.graphics.setColor(1,1,1,0.607)
	love.graphics.print("Score : " .. player.score, 10+hud.display.w/4,hud.display.h)
		


		
	--shield bar
	love.graphics.setLineWidth(5)
	love.graphics.setColor(1,1,1,0.607)
	love.graphics.print("shield", 10+hud.display.w-400,hud.display.h)
	love.graphics.setColor(0.39,0.784,0.39,0.3)
	love.graphics.rectangle("fill", 70+hud.display.w-400,hud.display.h+10,hud.display.w/8, hud.display.h/3,5,5)
	love.graphics.setColor(0.39,0.784,0.39,0.7)
	love.graphics.rectangle("fill", 70+hud.display.w-400,hud.display.h+10,player.shield/player.shieldmax*(hud.display.w/8), hud.display.h/3,5,5)
	
	love.graphics.setColor(0.607,1,1,0.3)
	love.graphics.rectangle("line", 70+hud.display.w-400,hud.display.h+10,hud.display.w/8, hud.display.h/3,5,5)
		
	--energy bar
	love.graphics.setColor(1,1,1,0.607)
	love.graphics.print("energy", 10+hud.display.w-200,hud.display.h)
	love.graphics.setColor(0.39,0.784,0.39,0.3)
	love.graphics.rectangle("fill", 70+hud.display.w-200,hud.display.h+10,hud.display.w/8, hud.display.h/3,5,5)
	love.graphics.setColor(0.39,0.745,0.784,0.7)
	love.graphics.rectangle("fill", 70+hud.display.w-200,hud.display.h+10,player.energy/player.energymax*(hud.display.w/8), hud.display.h/3,5,5)
		
	love.graphics.setColor(0.607,1,1,0.3)
	love.graphics.rectangle("line", 70+hud.display.w-200,hud.display.h+10,hud.display.w/8, hud.display.h/3,5,5)

	
	love.graphics.setFont(fonts.default)

	

	
	love.graphics.setCanvas()

	love.graphics.setColor(1,1,1,1)
	
	love.graphics.draw(hud.display.canvas, 
		love.graphics.getWidth()/2-hud.display.w/2,
		love.graphics.getHeight()-hud.display.h-hud.display.offset
	)
  
    love.graphics.setLineWidth(1)
end


function hud:drawProgress()
	--wave progress marker
	love.graphics.setColor(0.607,1,1,0.607)
	for i=0,hud.display.w, hud.display.w/10 do
		love.graphics.line(i+1,10, i,hud.display.h-1)
	end
	
	--progress marker
	love.graphics.setLineWidth(1)
  	for i=0,hud.display.w, hud.display.w/100 do
		if i < hud.display.progress then 
			love.graphics.setColor(0,1,0.607,1)
		else
			love.graphics.setColor(0.607,1,1,0.784)
			
		end
		love.graphics.line(i,hud.display.h/3, i,hud.display.h/2)
		

	end
	
	--wave progress bar indicator
	love.graphics.setColor(0.607,1,1,0.4)
	love.graphics.rectangle("fill", 0,hud.display.h/2, hud.display.progress ,5)
	
	--progress marker arrow
  	love.graphics.setColor(0,1,0.588,1)
  	love.graphics.setLineWidth(2)
	love.graphics.line(hud.display.progress,hud.display.h/3, hud.display.progress-3,6)
	love.graphics.line(hud.display.progress,hud.display.h/3, hud.display.progress+3,6)
	
end



function hud:drawconsole()
	love.graphics.setFont(fonts.default)
	
	if hud.console.y  > -hud.console.h then
	love.graphics.setCanvas(hud.console.canvas)
	love.graphics.clear()
	love.graphics.setColor(1,1,1,1)

	--debug console
		--frame
		love.graphics.setColor(0.04,0.05,0.08,0.75)
		--love.graphics.rectangle("fill", hud.console.x,hud.console.y, hud.console.w,hud.console.h)
	
		local points = {
			hud.console.x, hud.console.y,
			hud.console.x+hud.console.w, hud.console.y,
			hud.console.x+hud.console.w, hud.console.y+hud.console.h-40,
			hud.console.x+hud.console.w-40, hud.console.y+hud.console.h,
			hud.console.x, hud.console.y+hud.console.h,
		}
		love.graphics.polygon("fill", points)
		love.graphics.setColor(0.039,0.235,0.235,0.607)
		
		love.graphics.setLineWidth(2)
		love.graphics.polygon("line", points)
		love.graphics.setColor(0.607,1,1,0.39)
		love.graphics.line(hud.console.x,hud.console.y+hud.console.h, hud.console.x+hud.console.w-40,hud.console.y+hud.console.h)
		love.graphics.setLineWidth(1)
		--sysinfo
		
		love.graphics.setColor(0.784,0.39,0.784,1)
		love.graphics.print(
			"fps: " .. love.timer.getFPS() .. 
			" | vsync: " ..tostring(game.flags.vsync)..
			" | res: ".. love.graphics.getWidth().."x"..love.graphics.getHeight() .. 
			" | garbage: " ..  gcinfo() .. "kB" ..
			string.format(" | vram: %.2fMB", love.graphics.getStats().texturememory / 1024 / 1024),
			hud.console.x+10,hud.console.y+10
		)

		
		love.graphics.setColor(0.784,0.784,0.39,1)
		love.graphics.print("bgmtrack: #" .. tostring(sound.bgmtrack) .. " | snd srcs: "..love.audio.getActiveSourceCount() .. " | [Seed: "..love.math.getRandomSeed().."]",hud.console.x+10,hud.console.y+30)
		
	
		--
		--divider
		love.graphics.setColor(0.607,1,1,0.39)
		love.graphics.line(hud.console.x+10,hud.console.y+60, hud.console.x+hud.console.w-10,hud.console.y+60)


		--player info
		if mode == "arcade" then
		love.graphics.setColor(0.39,0.745,0.784,1)
		love.graphics.print("player yvel: " .. math.round(player.yvel,4),hud.console.x+10,hud.console.y+70)
		love.graphics.print("player xvel: " .. math.round(player.xvel,4),hud.console.x+10,hud.console.y+90)
		love.graphics.print("player posx: " .. math.round(player.x,4),hud.console.x+10,hud.console.y+110)
		love.graphics.print("player posy: " .. math.round(player.y,4),hud.console.x+10,hud.console.y+130)
		love.graphics.print("player idle: " .. tostring(player.idle),hud.console.x+10,hud.console.y+150)
		end
		
		--divider
		love.graphics.setColor(0.607,1,1,0.39)
		love.graphics.line(hud.console.x+10,hud.console.y+180, hud.console.x+200,hud.console.y+180)

		--mission info
		if mode == "arcade" then
			love.graphics.setColor(0.39,0.745,0.784,1)
			love.graphics.print("progress  : " .. string.format("%.2f",hud.display.progress/hud.display.w*100,4) .."%",hud.console.x+10,hud.console.y+190)
			love.graphics.print("elapsed   : " .. misc:formatTime(hud.time), hud.console.x+10,hud.console.y+210)
			love.graphics.print("wave delay: " .. string.format("%.3f",enemies.waveDelay), hud.console.x+10,hud.console.y+230)
		end
		--vertical divider
		love.graphics.setColor(0.607,1,1,0.39)
		love.graphics.line(hud.console.x+201,hud.console.y+60, hud.console.x+201,hud.console.y+249)
		
		--arena info
		love.graphics.setColor(0.39,0.745,0.784,1)

		love.graphics.print("[starfield:" .. string.format("%04d",#starfield.objects) .. 
			"|st:" .. string.format("%04d",starfield.count.star) .. 
			"|no:" .. string.format("%02d",starfield.count.nova) .. 
			"|ne:" .. string.format("%02d",starfield.count.nebulae) .. 
			"|pl:" .. string.format("%02d",starfield.count.planet) ..
			"][speed:" .. string.format("%04d",starfield.speed) ..
			"]"
			,hud.console.x+215,hud.console.y+70
		)
		
		if mode == "arcade" then
		love.graphics.print("projectiles: " .. #projectiles.missiles,hud.console.x+215,hud.console.y+90)
		love.graphics.print("enemies    : " .. #enemies.wave,hud.console.x+215,hud.console.y+110)
		love.graphics.print("pickups    : " .. #pickups.items,hud.console.x+215,hud.console.y+130)
		love.graphics.print("explosions : " .. #explosions.objects,hud.console.x+215,hud.console.y+150)
		love.graphics.print("kill/spawn : " .. player.kills.."/"..enemies.spawned,hud.console.x+215,hud.console.y+170)
		end
		
	
	love.graphics.setCanvas()

	love.graphics.setColor(1,1,1,hud.console.opacity)
	love.graphics.draw(hud.console.canvas,hud.console.x,hud.console.y)
	end
	
	love.graphics.setFont(fonts.default)
end
