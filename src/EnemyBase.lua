EnemyBase = Class{}

---------------------------------------------------------------------------------------------------------

function EnemyBase:initBase(attri)
  self.x = attri.x
  self.y = attri.y
  self.width = attri.width or 50
  self.height = attri.height or 100

  self.angle = attri.angle or 0
  self.speed = attri.speed or 300

  self.HP = attri.HP or 100

  world:add(self, self.x, self.y, self.width, self.height)

end

---------------------------------------------------------------------------------------------------------

function EnemyBase:updateBase(dt)
  -- 0 <= HP
  self.HP = math.max(0, self.HP)

  -- 0 <= push <= 1
  self.push = math.min(1, self.push)
  self.push = math.max(0, self.push-dt/2)

  -- 0 <= angle < 2pi
  self.angle = self.angle % (math.pi*2)

end

---------------------------------------------------------------------------------------------------------

function EnemyBase:renderBase()
  

end

---------------------------------------------------------------------------------------------------------

function EnemyBase:changeHealth(val)
  self.HP = self.HP + val
end

---------------------------------------------------------------------------------------------------------

function EnemyBase:hitByBullet(val)
  self:changeHealth(val)
end

---------------------------------------------------------------------------------------------------------
