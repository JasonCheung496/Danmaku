Player = Class{}

local speed = 400

---------------------------------------------------------------------------------------------------------

function Player:init()
  self.x = 100
  self.y = 200
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

  local goalX, goalY = player.x + player.dx, player.y + player.dy
  actualX, actualY = world:move(player, goalX, goalY)
  player.x, player.y = actualX, actualY

end

---------------------------------------------------------------------------------------------------------

function Player:render()
  love.graphics.setColor(0.1, 0.9, 0.9, 1)
  love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
end

---------------------------------------------------------------------------------------------------------
