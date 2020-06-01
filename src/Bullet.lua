Bullet = Class{}

local defaultSpeed = 400
local defaultDamage = -10
local bulletSet = {
  {
    index = 1,
    image = love.graphics.newImage("Sprite/bullet.png"),
    width = 9, height = 15
  },
  {
    index = 2,
    image = love.graphics.newImage("Sprite/bullet2.png"),
    width = 11, height = 11
  }
}


---------------------------------------------------------------------------------------------------------
--!!x, y, from are necessary. others are optional
function Bullet:init(x, y, from, type, specialMove, theta, speed, damage)
  self.x = x
  self.y = y
  self.source = from

  self.type = type
  self.image = bulletSet[self.type].image
  self.width = bulletSet[self.type].width
  self.height = bulletSet[self.type].height

  self.specialMove = specialMove and function() specialMove(self) end or function() end

  -- -pi <= angle < pi
  -- angle = 0: face upward
  -- -pi <= angle < 0: face left
  -- 0 < angle < pi: face right
  local pi = math.pi
  self.angle = theta and (theta + pi) % (pi*2) - pi or 0
  self.speed = speed or defaultSpeed

  self.damage = damage or defaultDamage
  self.lifetime = 2000

  self.visible = { x = self.x, y = self.y }

  world:add(self, self.x, self.y, self.width, self.height)


end

---------------------------------------------------------------------------------------------------------

function Bullet:update(dt)
  --special move
  self.specialMove()

  -- speed >= 0
  --if speed is -ve, flip the direction
  local pi = math.pi
  if self.speed < 0 then
    self.speed = -self.speed
    self.angle = self.angle + math.pi
  end

  -- -pi <= angle < pi
  self.angle = (self.angle + pi) % (pi*2) - pi

  --move in its direction
  local goalX = self.x + self.speed * math.sin(self.angle) * dt
  local goalY = self.y - self.speed * math.cos(self.angle) * dt

  --check collision using bump
  local bulletFilter = function(item, other)
    return "cross"
  end
  actualX, actualY, cols, len = world:move(self, goalX, goalY, bulletFilter)
  self.x, self.y = actualX, actualY

  --if hit player/enemy
  for i = 1, len do
    if cols[i].other.__index ~= self.source.__index then
      if cols[i].other.__index == Enemy or cols[i].other.__index == Player then
        world:remove(self)
        cols[i].other:hitByBullet(-10)
        break
      end
    end
  end

  --auto destroy itself if out of screen or lifetime <= 0
  if (self.x < -100 and self.angle <= 0) or --left side
  (self.x > GAME_WIDTH + 100 and self.angle >= 0) or -- right side
  (self.y < -100 and self.angle >= -pi/2 and self.angle <= pi/2) or --up side
  (self.y > GAME_HEIGHT + 100 and (self.angle <= -pi/2 or self.angle >= pi/2)) or -- down side
  self.lifetime <= 0 then -- lifetime <= 0
    world:remove(self)
  end
  self.lifetime = self.lifetime - 1

  --correct visual sprite
  local r = math.sqrt(math.pow(self.width, 2) + math.pow(self.height, 2))/2
  local theta = math.atan2(self.height, self.width)
  self.visible.x = self.x + self.width/2 - r*math.cos(theta + self.angle)
  self.visible.y = self.y + self.height/2 - r*math.sin(theta + self.angle)



end

---------------------------------------------------------------------------------------------------------

function Bullet:render()
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.draw(self.image, self.visible.x, self.visible.y, self.angle)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)


end

---------------------------------------------------------------------------------------------------------
