Bullet = Class{}

local speed = 400
local image = love.graphics.newImage("Sprite/bullet.png")

---------------------------------------------------------------------------------------------------------

function Bullet:init(x, y, theta)
  self.x = x
  self.y = y
  self.width = image:getWidth()
  self.height = image:getHeight()

  -- -pi <= angle < pi
  --angle = 0: face upward
  -- -pi <= angle < 0: face left
  -- 0 < angle < pi: face right
  local pi = math.pi
  self.angle = (theta + pi) % (pi*2) - pi

end

---------------------------------------------------------------------------------------------------------

function Bullet:update(dt)
  -- -pi <= angle < pi
  local pi = math.pi
  self.angle = (self.angle + pi) % (pi*2) - pi

  --move in its direction
  local goalX = self.x + speed * math.sin(self.angle) * dt
  local goalY = self.y - speed * math.cos(self.angle) * dt

  --check collision using bump
  local bulletFilter = function(item, other)
    return "cross"
  end
  actualX, actualY = world:move(self, goalX, goalY, bulletFilter)
  self.x, self.y = actualX, actualY

  --auto destroy itself if out of screen
  if (self.x < -100 and self.angle <= 0) or --left side
  (self.x > GAME_WIDTH + 100 and self.angle >= 0) or -- right side
  (self.y < -100 and self.angle >= -pi/2 and self.angle <= pi/2) or --up side
  (self.y > GAME_HEIGHT + 100 and (self.angle <= -pi/2 or self.angle >= pi/2)) then -- down side
    world:remove(self)
  end




end

---------------------------------------------------------------------------------------------------------

function Bullet:render()
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.draw(image, self.x, self.y, self.angle)

end

---------------------------------------------------------------------------------------------------------
