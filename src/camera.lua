camera = {}
camera.x = 0
camera.y = 0

camera.scale = 1

camera.rotation = 0

function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scale, 1 / self.scale)
  love.graphics.translate(-self.x,-self.y)
  --love.graphics.translate(-self.x+(game.width/2*camera.scaleX), -self.y+(game.height/2*camera.scaleX))
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end


function camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function camera:setScale(s)
  self.scale = s or self.scale
end


