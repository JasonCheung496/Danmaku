Player = Class{}

local speed = 400
local maxHP = 100
local totalShootMode = 2
local invincibleTime = 1
local shootCD = { 4 , 12 }

---------------------------------------------------------------------------------------------------------

function Player:init(x, y, mode)
  self.x = x
  self.y = y
  self.width = 10
  self.height = 10

  self.visible = {
    width = 50,
    height = 100
  }
  self.visible.x = self.x + self.width/2 - self.visible.width/2
  self.visible.y = self.y + self.height/2 - self.visible.height/2

  self.dx = 0
  self.dy = 0

  self.shootMode = mode or 1
  self.shootTimer = 1

  self.HP = maxHP

  self.invincibleTimer = 0

  world:add(self, self.x, self.y, self.width, self.height)

end

---------------------------------------------------------------------------------------------------------

function Player:update(dt)

  -- 0 <= HP <= maxHP
  self.HP = math.min(maxHP, self.HP)
  self.HP = math.max(0, self.HP)

  -- 1 <= shootMode <= totalShootMode
  self.shootMode = (self.shootMode-1) % totalShootMode + 1

  -- 0 <= invincibleTimer
  self.invincibleTimer = math.max(0, self.invincibleTimer - dt)

  --input c to shoot the bullet
  if love.keyboard.isDown('c') then
    self.shootTimer = self.shootTimer - dt*60
  end
  if self.shootTimer <= 0 then
    self:shootTheBullet(self.shootMode)
    self.shootTimer = shootCD[self.shootMode]
  end


  --input player movement
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

  --move the player & check collision using bump
  local playerFilter = function(item, other)
    if other.__index == Bullet then return "cross"
    else return "slide"
    end
  end

  local goalX, goalY = self.x + self.dx, self.y + self.dy
  local actualX, actualY = world:move(self, goalX, goalY, playerFilter)
  self.x, self.y = actualX, actualY

  --input to change shootMode
  if inputTable["w"] then
    self.shootMode = self.shootMode - 1
  end
  if inputTable["e"] then
    self.shootMode = self.shootMode + 1
  end

  --update player sprite
  self.visible.x = self.x + self.width/2 - self.visible.width/2
  self.visible.y = self.y + self.height/2 - self.visible.height/2


  if love.keyboard.isDown("s") then
    self.HP = self.HP - 10*dt
  end
  if love.keyboard.isDown("d") then
    self.HP = self.HP + 10*dt
  end



end

---------------------------------------------------------------------------------------------------------

function Player:render()
  love.graphics.setColor(0.1, 0.7, 0.7, 0.7)
  love.graphics.rectangle("fill", self.visible.x, self.visible.y, self.visible.width, self.visible.height)
  love.graphics.setColor(0.1, 0.9, 0.9, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

end

---------------------------------------------------------------------------------------------------------

function Player:shootTheBullet(mode)
  if mode == 1 then
    local randomAngle = (math.random(150, 209) - 180) / 180 * math.pi
    local move = function(bullet)
      bullet.speed = bullet.speed + 15
    end
    bullet = Bullet(self.x + self.width/2, self.y, self, randomAngle, move, 100)

  elseif mode == 2 then
    for i = -1, 1 do
      bullet = Bullet(self.x + self.width/2, self.y, self, i*math.pi/7)
    end
  end

end

---------------------------------------------------------------------------------------------------------

function Player:changeHealth(val)
  self.HP = self.HP + val

end

---------------------------------------------------------------------------------------------------------

function Player:hitByBullet(val)
  if self.invincibleTimer <= 0 then
    self:changeHealth(val)
    self.invincibleTimer = invincibleTime
  end
end

---------------------------------------------------------------------------------------------------------
