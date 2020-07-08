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

load = {}

load.w = love.graphics.getWidth()/2
load.h = 60
load.x = love.graphics.getWidth()/2-load.w/2
load.y = love.graphics.getHeight()-load.h*2
load.pad = 8
load.canvas = love.graphics.newCanvas(load.w, load.h)
load.font = love.graphics.newFont(20)
load.corner = 20

function load:images(images, path)
	local t = {}
	local supported = { ".png", ".bmp", ".jpg", ".tga" }

	for _,file in ipairs(love.filesystem.getDirectoryItems(path)) do
		for _,ext in ipairs(supported) do
			if file:find(ext) then
				table.insert(t, path..file)
			end
		end
	end
    
    load.files = t
    load.count = 0
    load.total = #t
    load.callback = images
end

function load:draw()
    if #load.files > 0 then
        lw = love.graphics.getLineWidth()
        love.graphics.setLineWidth(3)

        love.graphics.setCanvas(load.canvas)
        love.graphics.clear()
    
        -- progress bar
        love.graphics.setColor(0.1, 0.1, 0.1, 1)
        love.graphics.rectangle("fill", load.pad, load.pad, load.w-load.pad*2, load.h-load.pad*2, load.corner, load.corner)
        love.graphics.setColor(0.1, 0.25, 0.25, 1)
        love.graphics.rectangle("fill", load.pad, load.pad, (load.count/load.total)*(load.w-load.pad/2), load.h-load.pad*2, load.corner, load.corner)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("line", load.pad, load.pad, load.w-load.pad*2, load.h-load.pad*2, load.corner, load.corner)
        
        -- file name / percentage
        love.graphics.setColor(0.50, 0.75, 0.75, 1)
        love.graphics.setFont(load.font)
        love.graphics.printf(load.name, load.pad*2, load.h/2-load.font:getHeight()/2, load.w, "left")
        love.graphics.printf( 
                string.format("%02d%s", math.floor((load.count/load.total)*100), "%"), 
                0,
                load.h/2-load.font:getHeight()/2, 
                load.w-load.pad*2, 
                "right"
        )

        love.graphics.setCanvas()

        love.graphics.setLineWidth(lw)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(load.canvas, load.x, load.y)
    end
end

function load:update(dt)
    -- loading loop
    if #load.files > 0 then
        file = table.remove(load.files,1)
        table.insert(load.callback, love.graphics.newImage(file))
        load.name = load.files[1]
        load.count = load.count + 1
        return
    end
end

return load