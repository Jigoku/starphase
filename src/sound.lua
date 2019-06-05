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
 
sound = {}
sound.enabled = true
sound.volume = 100 -- 0>100 (used when a track is played)

sound.bgm = nil
sound.bgmtrack = nil

sound.music = {
	--[1] =  love.audio.newSource("sfx/music/zhelanov/space.ogg",			"stream"),
	[1] =  love.audio.newSource("sfx/music/zhelanov/ambient.ogg",			"stream"),
	[2] =  love.audio.newSource("sfx/music/maxstack/tst/lose.ogg", 		"stream"),
	[3] =  love.audio.newSource("sfx/music/maxstack/nebula.ogg", 		"stream"),
	[4] =  love.audio.newSource("sfx/music/maxstack/through-space.ogg", "stream"),
	[5] =  love.audio.newSource("sfx/music/maxstack/crystal-space.ogg", "stream"),
	[6] =  love.audio.newSource("sfx/music/maxstack/bazaarnet.ogg", 	"stream"),
	[7] =  love.audio.newSource("sfx/music/maxstack/the-client.ogg", 	"stream"),
	[8] =  love.audio.newSource("sfx/music/maxstack/deprecation.ogg", 	"stream"),
	[9] =  love.audio.newSource("sfx/music/maxstack/inevitable.ogg", 	"stream"),
	[10] = love.audio.newSource("sfx/music/maxstack/mediathreat.ogg", 	"stream"),
	[11] = love.audio.newSource("sfx/music/pablo/thrust.ogg", 			"stream"),
	[12] = love.audio.newSource("sfx/music/pablo/dimensions.ogg",	 	"stream"),
	[13] = love.audio.newSource("sfx/music/pablo/persuit.ogg",		 	"stream"),
	[14] = love.audio.newSource("sfx/music/pablo/vilified.ogg",		 	"stream"),
	[15] = love.audio.newSource("sfx/music/pablo/evasion.ogg",		 	"stream"),
	[16] = love.audio.newSource("sfx/music/qubodup/railjet.ogg", 		"stream"),
	
}

sound.intercom = {
	[1] = love.audio.newSource("sfx/intercom/intercom.ogg", "stream"),
}
sound.intercom[1]:setVolume(0.3)
	
	
	
love.audio.setVolume( 1 )--master volume

function sound:init()
	if sound.enabled then
		love.audio.setVolume( sound.volume/100 )
	else
		love.audio.setVolume( 0 )
	end
end

function sound:toggle()
	sound.enabled = not sound.enabled
	if sound.enabled then
		love.audio.setVolume( sound.volume/100 )
	else
		love.audio.setVolume( 0 )
	end
end

function sound:playbgm(id)
	self.bgm = self.music[id]
	self.bgmtrack = id
	self:stoplooping(self.music)
	--self.bgm:setPitch(0.5)
	--love.audio.rewind( )

	if id ~= 0 then
		self.bgm:setLooping(true)
		self.bgm:setVolume(1)
		self.bgm:play()
	end
end

function sound:play(sfx)
	if sound.muted then return true end
	--fix this, move source definition of effects to this file

	sfx:stop()
	sfx:play()
end

function sound:stoplooping(type)
	for _,t in ipairs(type) do
		t:stop()
	end
end
