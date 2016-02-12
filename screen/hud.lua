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

hud.console = {
	w = 700,
	h = 250,
	x = 10,
	y = -250,
	canvas = love.graphics.newCanvas(w, h),
	speed = 400,
}

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
	hud.score = 0
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
	

end


function hud:updateconsole(dt)
	if debug then
		if mode == "title" then
			hud.console.h = 50
		else
			hud.console.h = 250
		end

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
		love.graphics.rectangle("fill",0,0,love.graphics.getWidth(), love.graphics.getHeight())
    
		love.graphics.setFont(fonts.paused_large)
		love.graphics.setColor(255,255,255,200)
		love.graphics.printf("PAUSED", love.graphics.getWidth()/2,love.graphics.getHeight()/3,0,"center",0,1,1)
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
	love.graphics.setColor(155,255,255,50)
	
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
	
	--time
	love.graphics.setColor(255,255,255,100)
	love.graphics.setFont(fonts.timer)
	love.graphics.printf(misc:formatTime(hud.time), love.graphics.getWidth()/2,20,0,"center",0,1,1)
	love.graphics.setFont(fonts.default)
	
	--display 
	love.graphics.setCanvas(hud.display.canvas)
	hud.display.canvas:clear()

	love.graphics.setColor(255,255,255,255)

	--wave progress marker
	love.graphics.setColor(155,255,255,155)
	for i=0,hud.display.w, hud.display.w/4 do
		love.graphics.line(i+1,10, i,hud.display.h-1)
	end
	
	--progress marker
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
	love.graphics.line(hud.display.progress,hud.display.h/3, hud.display.progress-3,6)
	love.graphics.line(hud.display.progress,hud.display.h/3, hud.display.progress+3,6)
	
	
	
	love.graphics.setFont(fonts.hud)
		
	--progress
	love.graphics.setColor(255,255,255,155)
	love.graphics.print("progress : " .. math.floor(hud.display.progress/hud.display.w*100).."%", 10,hud.display.h-10)	
	--score
	love.graphics.setColor(255,255,255,155)
	love.graphics.print("score: " .. hud.score, 10+hud.display.w/4,hud.display.h-10)
		

	--shield bar
	love.graphics.setColor(255,255,255,155)
	love.graphics.print("shield", 10+hud.display.w/4*2,hud.display.h-10)
	love.graphics.setColor(100,200,100,100)
	love.graphics.rectangle("fill", 65+hud.display.w/4*2,hud.display.h-5,hud.display.w/8, hud.display.h/3)
	love.graphics.setColor(100,200,100,155)
	love.graphics.rectangle("fill", 65+hud.display.w/4*2,hud.display.h-5,ship.shield/ship.shieldmax*(hud.display.w/8), hud.display.h/3)
		
	--energy bar
	love.graphics.setColor(255,255,255,155)
	love.graphics.print("energy", 10+hud.display.w/4*3,hud.display.h-10)
	love.graphics.setColor(100,190,200,100)
	love.graphics.rectangle("fill", 65+hud.display.w/4*3,hud.display.h-5,hud.display.w/8, hud.display.h/3)
	love.graphics.setColor(100,190,200,155)
	love.graphics.rectangle("fill", 65+hud.display.w/4*3,hud.display.h-5,ship.energy/ship.energymax*(hud.display.w/8), hud.display.h/3)
		
	love.graphics.setFont(fonts.default)

	
	love.graphics.setCanvas()

	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(hud.display.canvas, 
		love.graphics.getWidth()/2-hud.display.w/2,
		love.graphics.getHeight()-hud.display.h-hud.display.offset
	)
  
  
end



function hud:drawconsole()
	if hud.console.y  > -hud.console.h then
	love.graphics.setCanvas(hud.console.canvas)
	hud.console.canvas:clear()
	love.graphics.setColor(255,255,255,255)

	--debug console
		--frame
		love.graphics.setColor(10,20,20,155)
		love.graphics.rectangle("fill", hud.console.x,hud.console.y, hud.console.w,hud.console.h)
		love.graphics.setColor(10,60,60,155)
		love.graphics.rectangle("line", hud.console.x,hud.console.y-1, hud.console.w,hud.console.h)
		love.graphics.setColor(155,255,255,100)
		love.graphics.line(hud.console.x,hud.console.y+hud.console.h, hud.console.x+hud.console.w,hud.console.y+hud.console.h)
		
		--sysinfo
		love.graphics.setColor(200,100,200,255)
		love.graphics.print(
			"fps: " .. love.timer.getFPS() .. 
			" | vsync: " ..tostring(game.flags.vsync)..
			" | res: ".. love.graphics.getWidth().."x"..love.graphics.getHeight() .. 
			" | garbage (kB): " ..  gcinfo(),hud.console.x+10,hud.console.y+10
		)

		
		love.graphics.setColor(200,100,100,255)
		love.graphics.print("music track: " .. tostring(music.track) .." ("..tostring(music[music.track])..")",hud.console.x+10,hud.console.y+30)
		
	
		if mode == "arcade" then
		--divider
		love.graphics.setColor(155,255,255,100)
		love.graphics.line(hud.console.x+10,hud.console.y+60, hud.console.x+500,hud.console.y+60)


		--ship info
		love.graphics.setColor(100,190,200,255)
		love.graphics.print("ship yvel: " .. math.round(ship.yvel,4),hud.console.x+10,hud.console.y+70)
		love.graphics.print("ship xvel: " .. math.round(ship.xvel,4),hud.console.x+10,hud.console.y+90)
		love.graphics.print("ship posx: " .. math.round(ship.x,4),hud.console.x+10,hud.console.y+110)
		love.graphics.print("ship posy: " .. math.round(ship.y,4),hud.console.x+10,hud.console.y+130)
		love.graphics.print("ship idle: " .. tostring(ship.idle),hud.console.x+10,hud.console.y+150)
		
		--divider
		love.graphics.setColor(155,255,255,100)
		love.graphics.line(hud.console.x+10,hud.console.y+180, hud.console.x+200,hud.console.y+180)

		--mission info
		love.graphics.setColor(100,190,200,255)
		love.graphics.print("progress: " ..math.round(hud.display.progress/hud.display.w*100,4) .."%",hud.console.x+10,hud.console.y+190)
		love.graphics.print("elapsed: " .. 
			misc:formatTime(hud.time),
			hud.console.x+10,hud.console.y+210
		)
		
		--vertical divider
		love.graphics.setColor(155,255,255,100)
		love.graphics.line(hud.console.x+201,hud.console.y+60, hud.console.x+201,hud.console.y+249)
		
		--arena info
		love.graphics.setColor(100,190,200,255)
		love.graphics.print("starfield objects: " .. #starfield.objects,hud.console.x+215,hud.console.y+70)
		love.graphics.print("projectiles: " .. #ship.projectiles,hud.console.x+215,hud.console.y+90)
		love.graphics.print("enemies    : " .. #enemies.wave,hud.console.x+215,hud.console.y+110)
		love.graphics.print("pickups    : " .. #pickups.items,hud.console.x+215,hud.console.y+130)
		end
	love.graphics.setCanvas()

	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(hud.console.canvas,hud.console.x,hud.console.y)
	end
end
