PlayerDemo = Class{}

---------------------------------------------------------------------------------------------------------

function PlayerDemo:init(newAttri)
  local attri = newAttri or {}

  self.x = attri.x or 0
  self.y = attri.y  or 0
  self.width = 10
  self.height = 10
  self.type = attri.type or 1

  self.image = playerSet[self.type].image
  self.visible = {
    width = self.image:getWidth(),
    height = self.image:getHeight()
  }
  self.visible.x = self.x + self.width/2 - self.visible.width/2
  self.visible.y = self.y + self.height/2 - self.visible.height/2

  self.shootTimer = 1

end

---------------------------------------------------------------------------------------------------------

function PlayerDemo:update(dt)
  --auto shoot bullet
  self.shootTimer = self.shootTimer - dt*60
  if self.shootTimer <= 0 then
    playerSet[self.type].shoot(self)
    self.shootTimer = playerSet[self.type].CD
  end

  --update player sprite
  self.visible.x = self.x + self.width/2 - self.visible.width/2
  self.visible.y = self.y + self.height/2 - self.visible.height/2

end

---------------------------------------------------------------------------------------------------------

function PlayerDemo:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.image, self.visible.x, self.visible.y)
  love.graphics.setColor(0.1, 0.9, 0.9, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

end

---------------------------------------------------------------------------------------------------------

function PlayerDemo:changeType(type)
  local t = (type-1) % #playerSet + 1
  self.type = t

end

---------------------------------------------------------------------------------------------------------
