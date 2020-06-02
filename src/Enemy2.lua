Enemy2 = Class{__includes = EnemyBase}
Enemy2.__group = "enemy"

local shootCD = 30

---------------------------------------------------------------------------------------------------------

function Enemy2:init(newAttri)
  local attri = newAttri or {}

  self:initBase(attri)
  self.push = 0 --control random movement

  self.shootTimer = 1

end

---------------------------------------------------------------------------------------------------------

function Enemy2:update(dt)
  self:updateBase(dt)

  -- 0 <= push <= 1
  self.push = math.min(1, self.push)
  self.push = math.max(0, self.push-dt/2)

  --move randomly
  if self.push == 0 and math.random(1, 100) == 1 then
    self.push = math.random(70, 100)/100
    self.angle = math.random(0, 359)/180*math.pi
    -- if under 1/3 screen, only move upward
    if curRoom ~= nil and self.y > curRoom.y+curRoom.height/3 then
      self.angle = math.random(180, 359)/180*math.pi
    end
  end
  local dx = math.cos(self.angle)*self.speed*dt *self.push
  local dy = math.sin(self.angle)*self.speed*dt *self.push

  --shoot the bullet
  self.shootTimer = self.shootTimer - dt*60
  if self.shootTimer <= 0 then
    self:shootTheBullet()
    self.shootTimer = shootCD
  end

  --move the enemy & check collision using bump
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

function Enemy2:render()
  love.graphics.setColor(0.8, 0.5, 0.1, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

end

---------------------------------------------------------------------------------------------------------

function Enemy2:shootTheBullet()
  local pi = math.pi
  local randFact = math.random(-5, 5)/1000

  local a = 2
  for i = -a, a do
    local move = function(bullet)
      bullet.register[1] = bullet.register[1] and bullet.register[1] + 0.1 or 0
      bullet.angle = bullet.angle + math.cos(bullet.register[1]) -- + randFact
    end
    local newBulletAttri = {
      x = self.x + self.width/2,
      y = self.y + self.height,
      source = self,
      type = 2,
      specialMove = move,
      angle = pi*2/(a*2+1)*i,--i*pi/8 + pi,
      speed = 600
    }

    bullet = Bullet(newBulletAttri)
  end

end

---------------------------------------------------------------------------------------------------------
