Enemy = Class{}

local maxHP = 100
local invincibleTime = 1
local shootCD = 30

---------------------------------------------------------------------------------------------------------

function Enemy:init(x, y)
  self.x = x
  self.y = y
  self.width = 50
  self.height = 100

  self.angle = 0
  self.speed = 300
  self.push = 0 --control random movement

  self.shootTimer = 1

  self.HP = maxHP

  self.invincibleTimer = 0

  world:add(self, self.x, self.y, self.width, self.height)

end

---------------------------------------------------------------------------------------------------------

function Enemy:update(dt)
  --move randomly
  if self.push == 0 and math.random(1, 100) == 1 then
    self.push = math.random(70, 100)/100
    self.angle = math.random(0, 359)/180*math.pi
    -- if under 1/3 screen, only move upward
    if self.y > curRoom.y+curRoom.height/3 then
      self.angle = math.random(180, 359)/180*math.pi
    end
  end

  -- 0 <= HP <= maxHP
  self.HP = math.min(maxHP, self.HP)
  self.HP = math.max(0, self.HP)

  -- 0 <= push <= 1
  self.push = math.min(1, self.push)
  self.push = math.max(0, self.push-dt/2)

  -- 0 <= invincibleTimer
  self.invincibleTimer = math.max(0, self.invincibleTimer - dt)

  -- 0 <= angle < 2pi
  self.angle = self.angle % (math.pi*2)

  --shoot the bullet
  self.shootTimer = self.shootTimer - dt*60
  if self.shootTimer <= 0 then
    self:shootTheBullet()
    self.shootTimer = shootCD
  end

  --move the enemy & check collision using bump
  local dx = math.cos(self.angle)*self.speed*self.push*dt
  local dy = math.sin(self.angle)*self.speed*self.push*dt

  local enemyFilter = function(item, other)
    if other.__index == BorderRect then return "slide"
    else return "cross"
    end
  end
  local goalX, goalY = self.x + dx, self.y + dy
  local actualX, actualY = world:move(self, goalX, goalY, enemyFilter)
  self.x, self.y = actualX, actualY

  --destroy itself if HP <= 0
  if self.HP <= 0 then
    world:remove(self)
  end

end

---------------------------------------------------------------------------------------------------------

function Enemy:render()
  love.graphics.setColor(0.9, 0.1, 0.1, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

end

---------------------------------------------------------------------------------------------------------

function Enemy:shootTheBullet()
  local pi = math.pi

  for i = -2, 2 do
    local move = function(bullet)
      bullet.angle = bullet.angle + 0.01*i
    end
    bullet = Bullet(self.x + self.width/2, self.y+self.height, self, i*pi/8 + pi, move, 200)
  end

end

---------------------------------------------------------------------------------------------------------

function Enemy:changeHealth(val)
  self.HP = self.HP + val
end

---------------------------------------------------------------------------------------------------------

function Enemy:hitByBullet(val)
  if self.invincibleTimer <= 0 then
    self:changeHealth(val)
    self.invincibleTimer = invincibleTime
  end
end

---------------------------------------------------------------------------------------------------------
