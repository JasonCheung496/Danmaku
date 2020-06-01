Bullet = Class{}

local defaultSpeed = 400
local defaultDamage = -10
local bulletSet = {
  {
    image = love.graphics.newImage("Sprite/bullet.png"),
    width = 9, height = 15
  },
  {
    image = love.graphics.newImage("Sprite/bullet2.png"),
    width = 11, height = 11
  }
}


---------------------------------------------------------------------------------------------------------
--!!x, y, source are necessary. others are optional
function Bullet:init(attri)
  self.x = attri.x
  self.y = attri.y
  self.source = attri.source

  self.type = attri.type
  self.image = bulletSet[self.type].image
  self.width = bulletSet[self.type].width
  self.height = bulletSet[self.type].height

  self.specialMove = attri.specialMove and function() attri.specialMove(self) end or function() end

  -- -pi <= angle < pi
  -- angle = 0: face upward
  -- -pi <= angle < 0: face left
  -- 0 < angle < pi: face right
  self.angle = attri.angle
  self.speed = attri.speed or defaultSpeed

  self.damage = attri.damage or defaultDamage
  self.lifetime = 2000

  self.visible = { x = self.x, y = self.y, angle = self.angle }

  --for special move
  self.register = {}

  world:add(self, self.x, self.y, self.width, self.height)


end

---------------------------------------------------------------------------------------------------------

function Bullet:update(dt)
  --special move, also allows customize angle
  self.visible.angle = nil
  self.specialMove()
  self.visible.angle = self.visible.angle or self.angle
  if self.speed < 0 then
    self.visible.angle = self.visible.angle + math.pi
  end

  -- -pi <= angle < pi
  local pi = math.pi
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
      if cols[i].other.hitByBullet ~= nil then
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
  self.visible.x = self.x + self.width/2 - r*math.cos(theta + self.visible.angle)
  self.visible.y = self.y + self.height/2 - r*math.sin(theta + self.visible.angle)



end

---------------------------------------------------------------------------------------------------------

function Bullet:render()
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.draw(self.image, self.visible.x, self.visible.y, self.visible.angle)
  --love.graphics.rectangle("line", self.x, self.y, self.width, self.height)


end

---------------------------------------------------------------------------------------------------------
