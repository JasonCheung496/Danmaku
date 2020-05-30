Player = Class{}

local speed = 400
local shootCD = 8
local shootCnt = shootCD
local shootMode = 2

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
  --player movement
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
  local actualX, actualY = world:move(self, goalX, goalY, playerFilter)
  self.x, self.y = actualX, actualY

  --press c to shoot the bullet
  if love.keyboard.isDown('c') then
    shootCnt = shootCnt - 1
  end
  if shootCnt <= 0 then
    self:shootTheBullet(shootMode)
    shootCnt = shootCD
  end





end

---------------------------------------------------------------------------------------------------------

function Player:render()
  love.graphics.setColor(0.1, 0.9, 0.9, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

---------------------------------------------------------------------------------------------------------

function Player:shootTheBullet(mode)
  if mode == 1 then
    local randomAngle = (math.random(150, 209) - 180) / 180 * math.pi
    bullet = Bullet(self.x + self.width/2, self.y, randomAngle)
    world:add(bullet, bullet.x, bullet.y, bullet.width, bullet.height)

  elseif mode == 2 then
    for i = -1, 1 do
      bullet = Bullet(self.x + self.width/2, self.y, i*math.pi/7)
      world:add(bullet, bullet.x, bullet.y, bullet.width, bullet.height)
    end


  end

end

---------------------------------------------------------------------------------------------------------
