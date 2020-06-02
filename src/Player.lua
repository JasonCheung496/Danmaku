Player = Class{}

--define how the player shoots and the shootCD
playerSet = {
  {
    maxHP = 30,
    CD = 4,
    shoot = function (player)
      local randomAngle = (math.random(170, 189) - 180) / 180 * math.pi
      local move = function(bullet)
        bullet.speed = bullet.speed + 10
      end
      local newBulletAttri = {
        x = player.x + player.width/2,
        y = player.y,
        source = player,
        type = 1,
        specialMove = move,
        angle = randomAngle,
        speed = 200
      }

      bullet = Bullet(newBulletAttri)
    end
  },

  {
    maxHP = 30,
    CD = 12,
    shoot = function (player)
      for i = -1, 1 do
        local newBulletAttri = {
          x = player.x + player.width/2,
          y = player.y,
          source = player,
          type = 1,
          angle = i*math.pi/7
        }

        bullet = Bullet(newBulletAttri)
      end
    end
  },

  {
    maxHP = 30,
    CD = 3,
    shoot = function (player)
      local randomAngle = (math.random(170, 189) - 180) / 180 * math.pi
      local move = function(bullet)
        bullet.register[1] = bullet.register[1] and bullet.register[1] + 1 or -20
        bullet.speed = bullet.speed + bullet.register[1]
      end
      local newBulletAttri = {
        x = player.x + player.width/2,
        y = player.y,
        source = player,
        type = 1,
        specialMove = move,
        angle = randomAngle,
        speed = 300
      }

      bullet = Bullet(newBulletAttri)

    end
  }
}

local speed = 400
local invincibleTime = 1
local totalType = #playerSet

---------------------------------------------------------------------------------------------------------

function Player:init(newAttri)
  local attri = newAttri or {}

  self.x = attri.x or GAME_WIDTH/2
  self.y = attri.y  or GAME_HEIGHT/2
  self.width = 10
  self.height = 10

  self.visible = {
    width = 50,
    height = 100
  }
  self.visible.x = self.x + self.width/2 - self.visible.width/2
  self.visible.y = self.y + self.height/2 - self.visible.height/2

  self.speed = attri.speed or speed
  self.dx = 0
  self.dy = 0

  self.type = attri.type or 1
  self.shootTimer = 1

  self.HP = attri.HP or playerSet[self.type].maxHP

  self.invincibleTimer = 0

  world:add(self, self.x, self.y, self.width, self.height)

end

---------------------------------------------------------------------------------------------------------

function Player:update(dt)
  -- 1 <= type <= totalType
  self.type = (self.type-1) % totalType + 1

  -- 0 <= HP <= maxHP
  self.HP = math.min(playerSet[self.type].maxHP, self.HP)
  self.HP = math.max(0, self.HP)

  -- 0 <= invincibleTimer
  self.invincibleTimer = math.max(0, self.invincibleTimer - dt)

  --input c to shoot the bullet
  if love.keyboard.isDown('c') then
    self.shootTimer = self.shootTimer - dt*60
  end
  if self.shootTimer <= 0 then
    playerSet[self.type].shoot(self)
    self.shootTimer = playerSet[self.type].CD
  end


  --input player movement
  self.dx, self.dy = 0, 0
  if love.keyboard.isDown("right") then
    self.dx = self.speed * dt
  end
  if love.keyboard.isDown("left") then
    self.dx = -self.speed * dt
  end
  if love.keyboard.isDown("down") then
    self.dy = self.speed * dt
  end
  if love.keyboard.isDown("up") then
    self.dy = -self.speed * dt
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

  --input to change type
  if inputTable["w"] then
    self.type = self.type - 1
  end
  if inputTable["e"] then
    self.type = self.type + 1
  end

  --update player sprite
  self.visible.x = self.x + self.width/2 - self.visible.width/2
  self.visible.y = self.y + self.height/2 - self.visible.height/2


  if love.keyboard.isDown("s") then
    self.HP = self.HP - 40*dt
  end
  if love.keyboard.isDown("d") then
    self.HP = self.HP + 40*dt
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
