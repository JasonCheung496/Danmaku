Enemy3 = Class{__includes = EnemyBase}

local shootCD = 60

---------------------------------------------------------------------------------------------------------

function Enemy3:init(newAttri)
  local attri = newAttri or {}
  self:initBase(attri)

  self.shootTimer = 1

end

---------------------------------------------------------------------------------------------------------

function Enemy3:update(dt)
  self:updateBase(dt)

  --move in circle
  self.angle = self.angle + 0.05

  --shoot the bullet
  self.shootTimer = self.shootTimer - dt*60
  if self.shootTimer <= 0 then
    self:shootTheBullet()
    self.shootTimer = shootCD
  end

  --move the enemy & check collision using bump
  local dx = math.cos(self.angle)*self.speed*dt
  local dy = math.sin(self.angle)*self.speed*dt

  local enemyFilter = function(item, other)
    if other.__index == BorderRect then return "slide"
    else return "cross"
    end
  end
  local goalX, goalY = self.x + dx, self.y + dy
  local actualX, actualY = world:move(self, goalX, goalY, enemyFilter)
  self.x, self.y = actualX, actualY

  --destroy itself if HP <= 0, gameScore+ if exists
  if self.HP <= 0 then
    world:remove(self)
    if gameScore ~= nil then
      gameScore = gameScore + self.score
    end
  end

end

---------------------------------------------------------------------------------------------------------

function Enemy3:render()
  love.graphics.setColor(0.9, 0.1, 0.1, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

end

---------------------------------------------------------------------------------------------------------

function Enemy3:shootTheBullet()
  --[[
  local pi = math.pi
  local randFact = math.random(-5, 5)/1000

  for i = -2, 2 do
    local move = function(bullet)
      bullet.angle = bullet.angle + randFact + 0.01*i
      bullet.speed = bullet.speed - 10
    end

    local newBulletAttri = {
      x = self.x + self.width/2,
      y = self.y + self.height,
      source = self,
      type = 2,
      specialMove = move,
      angle = i*pi/8 + pi,
      speed = 300
    }
    bullet = Bullet(newBulletAttri)
  end]]

end

---------------------------------------------------------------------------------------------------------
