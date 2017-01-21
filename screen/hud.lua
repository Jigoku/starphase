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
 
hud = {}
hud.life_gfx = love.graphics.newImage("gfx/life.png")

hud.colors = {
	["frame"] = {155,255,255,50},
	["lives"] = {100,190,200,120},
	["hsl_frame"] = 0,
}

-- HSL color for HUD when warping (not implemeneted)
hud.warp = false

hud.console = {
	w = 720,
	h = 250,
	x = 10,
	y = -250,
	canvas = love.graphics.newCanvas(w, h),
	speed = 400,
	opacity = 220,
}


-- https://love2d.org/wiki/HSL_color
function hud:HSL(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m)*255,(g+m)*255,(b+m)*255,a
end


function hud:init()
	hud.display = {
		w = 700,
		h = 30,
		offset = 30,
		canvas = love.graphics.newCanvas(w, h),
		progress = 0.0,
		timer = os.time(),
	}	
	
	hud.time = 0
end



function hud:update(dt)

	if hud.display.progress > hud.display.w then
		hud.display.progress = hud.display.w
		print ("reached destination")
		--implement scoreboard / statistic screen
	end

	if paused then return end
	hud.display.progress = hud.display.progress + 1 *dt
	hud.time = hud.time + 1 *dt
	
	if hud.warp then
		if hud.colors["hsl_frame"] < 256 then
			hud.colors["hsl_frame"] = hud.colors["hsl_frame"] + 500 *dt
		else
			hud.colors["hsl_frame"] = 0
		end
	end
	
end


function hud:updateconsole(dt)
	if debug then
		--if mode == "title" then
		--	hud.console.h = 50
		--else
		--	hud.console.h = 250
		--end

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


function hud:draw()
	if paused and not debug then 
		
		love.graphics.setColor(0,0,0,140)
		--love.graphics.rectangle("fill",0,0,love.graphics.getWidth(), love.graphics.getHeight())
    
		love.graphics.setFont(fonts.paused_large)
		love.graphics.setColor(255,255,255,200)
		love.graphics.printf("PAUSED", love.graphics.getWidth()/2-150,love.graphics.getHeight()/3,300,"center")
		love.graphics.setFont(fonts.default)
		local wrap = 200
		love.graphics.setFont(fonts.paused_small)
		love.graphics.setColor(255,255,255,200)
		love.graphics.printf("Press "..string.upper(binds.pausequit).." to quit", love.graphics.getWidth()/2-wrap/2,love.graphics.getHeight()/3+50,wrap,"center",0,1,1)
		love.graphics.setFont(fonts.default)
		return
	end
	
  --hud
	--decor / lines
	if not debug then
	
	if hud.warp then
		love.graphics.setColor(hud:HSL(hud.colors["hsl_frame"],100,80))
	else
		love.graphics.setColor(
			hud.colors["frame"][1],hud.colors["frame"][2],hud.colors["frame"][3],hud.colors["frame"][4]
		)
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
		love.graphics.getWidth()/4+1,love.graphics.getHeight()-20,
		love.graphics.getWidth()/4+40,love.graphics.getHeight()-40
	)	
	love.graphics.line(
		61,love.graphics.getHeight()-20,
		love.graphics.getWidth()/4,love.graphics.getHeight()-20
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
		love.graphics.getWidth()/4+1,20,
		love.graphics.getWidth()/4+40,40
	)	
	love.graphics.line(
		61,20,
		love.graphics.getWidth()/4,20
	)
	
	
	--right side
	love.graphics.line(
		love.graphics.getWidth()-60,love.graphics.getHeight()-20,
		love.graphics.getWidth()-20,love.graphics.getHeight()-40
	)
	love.graphics.line(
		love.graphics.getWidth()-love.graphics.getWidth()/4-1,love.graphics.getHeight()-20,
		love.graphics.getWidth()-love.graphics.getWidth()/4-40,love.graphics.getHeight()-40
	)
	love.graphics.line(
		love.graphics.getWidth()-61,love.graphics.getHeight()-20,
		love.graphics.getWidth()-love.graphics.getWidth()/4,love.graphics.getHeight()-20
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
		love.graphics.getWidth()-love.graphics.getWidth()/4-1,20,
		love.graphics.getWidth()-love.graphics.getWidth()/4-40,40
	)
	love.graphics.line(
		love.graphics.getWidth()-61,20,
		love.graphics.getWidth()-love.graphics.getWidth()/4,20
	)
	end
	
	
	
	--time
	love.graphics.setColor(255,255,255,100)
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

	love.graphics.setColor(255,255,255,255)

	--wave progress marker
	love.graphics.setColor(155,255,255,155)
	for i=0,hud.display.w, hud.display.w/4 do
		love.graphics.line(i+1,10, i,hud.display.h-1)
	end
	
	--progress marker
	love.graphics.setLineWidth(1)
  	for i=0,hud.display.w, hud.display.w/100 do
		if i < hud.display.progress then 
			love.graphics.setColor(0,255,150,255)
		else
			love.graphics.setColor(155,255,255,200)
			
		end
		love.graphics.line(i,hud.display.h/3, i,hud.display.h/2)
	end
	
	--progress marker arrow
  	love.graphics.setColor(0,255,150,255)
  	love.graphics.setLineWidth(2)
	love.graphics.line(hud.display.progress,hud.display.h/3, hud.display.progress-3,6)
	love.graphics.line(hud.display.progress,hud.display.h/3, hud.display.progress+3,6)
	
	
	
	love.graphics.setFont(fonts.hud)
		
	--progress
	love.graphics.setColor(255,255,255,155)
	love.graphics.print("progress : " .. math.floor(hud.display.progress/hud.display.w*100).."%", 10,hud.display.h-10)	
	--score
	love.graphics.setColor(255,255,255,155)
	love.graphics.print("score: " .. player.score, 10+hud.display.w/4,hud.display.h-10)
		


		
	--shield bar
	love.graphics.setColor(255,255,255,155)
	love.graphics.print("shield", 10+hud.display.w/4*2,hud.display.h-10)
	love.graphics.setColor(100,200,100,100)
	love.graphics.rectangle("fill", 65+hud.display.w/4*2,hud.display.h-5,hud.display.w/8, hud.display.h/3)
	love.graphics.setColor(100,200,100,155)
	love.graphics.rectangle("fill", 65+hud.display.w/4*2,hud.display.h-5,player.shield/player.shieldmax*(hud.display.w/8), hud.display.h/3)
	
		love.graphics.setColor(155,255,255,50)
		love.graphics.rectangle("line", 65+hud.display.w/4*2,hud.display.h-5,hud.display.w/8, hud.display.h/3)
		
	--energy bar
	love.graphics.setColor(255,255,255,155)
	love.graphics.print("energy", 10+hud.display.w/4*3,hud.display.h-10)
		love.graphics.setColor(100,200,100,100)
	love.graphics.rectangle("fill", 65+hud.display.w/4*3,hud.display.h-5,hud.display.w/8, hud.display.h/3)
	love.graphics.setColor(100,190,200,155)
	love.graphics.rectangle("fill", 65+hud.display.w/4*3,hud.display.h-5,player.energy/player.energymax*(hud.display.w/8), hud.display.h/3)
		
		love.graphics.setColor(155,255,255,50)
		love.graphics.rectangle("line", 65+hud.display.w/4*3,hud.display.h-5,hud.display.w/8, hud.display.h/3)

	
	love.graphics.setFont(fonts.default)

	

	
	love.graphics.setCanvas()

	love.graphics.setColor(255,255,255,255)
	
	love.graphics.draw(hud.display.canvas, 
		love.graphics.getWidth()/2-hud.display.w/2,
		love.graphics.getHeight()-hud.display.h-hud.display.offset
	)
  
    love.graphics.setLineWidth(1)
end



function hud:drawconsole()
	love.graphics.setFont(fonts.default)
	
	if hud.console.y  > -hud.console.h then
	love.graphics.setCanvas(hud.console.canvas)
	love.graphics.clear()
	love.graphics.setColor(255,255,255,255)

	--debug console
		--frame
		love.graphics.setColor(10,12,20,155)
		--love.graphics.rectangle("fill", hud.console.x,hud.console.y, hud.console.w,hud.console.h)
	
		local points = {
			hud.console.x, hud.console.y,
			hud.console.x+hud.console.w, hud.console.y,
			hud.console.x+hud.console.w, hud.console.y+hud.console.h-40,
			hud.console.x+hud.console.w-40, hud.console.y+hud.console.h,
			hud.console.x, hud.console.y+hud.console.h,
		}
		love.graphics.polygon("fill", points)
		love.graphics.setColor(10,60,60,155)
		
		love.graphics.setLineWidth(2)
		love.graphics.polygon("line", points)
		love.graphics.setColor(155,255,255,100)
		love.graphics.line(hud.console.x,hud.console.y+hud.console.h, hud.console.x+hud.console.w-40,hud.console.y+hud.console.h)
		love.graphics.setLineWidth(1)
		--sysinfo
		
		love.graphics.setColor(200,100,200,255)
		love.graphics.print(
			"fps: " .. love.timer.getFPS() .. 
			" | vsync: " ..tostring(game.flags.vsync)..
			" | res: ".. love.graphics.getWidth().."x"..love.graphics.getHeight() .. 
			" | garbage: " ..  gcinfo() .. "kB" ..
			string.format(" | vram: %.2fMB", love.graphics.getStats().texturememory / 1024 / 1024),
			hud.console.x+10,hud.console.y+10
		)

		
		love.graphics.setColor(200,100,100,255)
		love.graphics.print("bgmtrack: #" .. tostring(sound.bgmtrack) .. " | sources: "..love.audio.getSourceCount() .. " | [Seed: "..love.math.getRandomSeed().."]",hud.console.x+10,hud.console.y+30)
		
	
		--
		--divider
		love.graphics.setColor(155,255,255,100)
		love.graphics.line(hud.console.x+10,hud.console.y+60, hud.console.x+hud.console.w-10,hud.console.y+60)


		--player info
		if mode == "arcade" then
		love.graphics.setColor(100,190,200,255)
		love.graphics.print("player yvel: " .. math.round(player.yvel,4),hud.console.x+10,hud.console.y+70)
		love.graphics.print("player xvel: " .. math.round(player.xvel,4),hud.console.x+10,hud.console.y+90)
		love.graphics.print("player posx: " .. math.round(player.x,4),hud.console.x+10,hud.console.y+110)
		love.graphics.print("player posy: " .. math.round(player.y,4),hud.console.x+10,hud.console.y+130)
		love.graphics.print("player idle: " .. tostring(player.idle),hud.console.x+10,hud.console.y+150)
		end
		
		--divider
		love.graphics.setColor(155,255,255,100)
		love.graphics.line(hud.console.x+10,hud.console.y+180, hud.console.x+200,hud.console.y+180)

		--mission info
		if mode == "arcade" then
		love.graphics.setColor(100,190,200,255)
		love.graphics.print("progress: " ..math.round(hud.display.progress/hud.display.w*100,4) .."%",hud.console.x+10,hud.console.y+190)
		love.graphics.print("elapsed: " .. 
			misc:formatTime(hud.time),
			hud.console.x+10,hud.console.y+210
		)
		end
		--vertical divider
		love.graphics.setColor(155,255,255,100)
		love.graphics.line(hud.console.x+201,hud.console.y+60, hud.console.x+201,hud.console.y+249)
		
		--arena info
		love.graphics.setColor(100,190,200,255)

		love.graphics.print("[starfield:" .. string.format("%04d",#starfield.objects) .. 
			"|st:" .. string.format("%04d",starfield.count.star) .. 
			"|no:" .. string.format("%02d",starfield.count.nova) .. 
			"|ne:" .. string.format("%02d",starfield.count.nebulae) .. 
			"|de:" .. string.format("%02d",starfield.count.debris) ..
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
		end
		--end
	love.graphics.setCanvas()

	love.graphics.setColor(255,255,255,hud.console.opacity)
	love.graphics.draw(hud.console.canvas,hud.console.x,hud.console.y)
	end
	
	love.graphics.setFont(fonts.default)
end
