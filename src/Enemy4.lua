Enemy4 = Class{__includes = EnemyBase}

local shootCD = 60

---------------------------------------------------------------------------------------------------------

function Enemy4:init(newAttri)
  local attri = newAttri or {}
  self:initBase(attri)

  self.swing = 0 -- control straight line movement

  self.shootTimer = 1

end

---------------------------------------------------------------------------------------------------------

function Enemy4:update(dt)
  self:updateBase(dt)

  --move in straight line back and forth
  self.swing = (self.swing + 0.02) % (math.pi*2)
  local temp = math.pow(math.abs((math.sin(self.swing))), 1/1.2) * sign(math.sin(self.swing))
  --local temp = math.sin(self.swing)
  local dx = math.cos(self.angle)*self.speed*dt *temp
  local dy = math.sin(self.angle)*self.speed*dt *temp

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

function Enemy4:render()
  love.graphics.setColor(0.9, 0.1, 0.1, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

end

---------------------------------------------------------------------------------------------------------

function Enemy4:shootTheBullet()
  local pi = math.pi

  for i = 0, 2 do
    local move = function(bullet)
      bullet.angle = bullet.angle + 0.01
      bullet.speed = bullet.speed + 10
    end

    local newBulletAttri = {
      x = self.x + self.width/2,
      y = self.y + self.height,
      source = self,
      type = 2,
      specialMove = move,
      angle = i*pi/8 + pi,
      speed = 200
    }
    bullet = Bullet(newBulletAttri)
  end


end

---------------------------------------------------------------------------------------------------------
