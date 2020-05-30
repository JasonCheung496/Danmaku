Player = Class{}

local speed = 400

---------------------------------------------------------------------------------------------------------

function Player:init()
  self.x = GAME_WIDTH/2 - 100
  self.y = GAME_HEIGHT - 200
  self.width = 50
  self.height = 100

  self.dx = 0
  self.dy = 0

end

---------------------------------------------------------------------------------------------------------

function Player:update(dt)
  self.dx, self.dy = 0, 0
  if love.keyboard.isDown("right") then
    self.dx = speed * dt
  end
  if love.keyboard.isDown("left") then
    self.dx = -speed * dt
  end
  if love.keyboard.isDown("down") then
    self.dy = speed * dt
  end
  if love.keyboard.isDown("up") then
    self.dy = -speed * dt
  end

  --check collision using bump
  local playerFilter = function(item, other)
    if other.__index == Bullet then return "cross"
    else return "slide"
    end
  end

  local goalX, goalY = self.x + self.dx, self.y + self.dy
  actualX, actualY = world:move(self, goalX, goalY, playerFilter)
  self.x, self.y = actualX, actualY

  --press c to shoot the bullet
  if inputTable["c"] then
    Player:shootTheBullet()
  end

end

---------------------------------------------------------------------------------------------------------

function Player:render()
  love.graphics.setColor(0.1, 0.9, 0.9, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

---------------------------------------------------------------------------------------------------------

function Player:shootTheBullet()
  local randomAngle = (math.random(0, 359) - 180) / 180 * math.pi
  bullet = Bullet(800, 700, randomAngle)
  world:add(bullet, bullet.x, bullet.y, bullet.width, bullet.height)

end

---------------------------------------------------------------------------------------------------------
