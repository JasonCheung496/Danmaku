Border = Class{}
BorderRect = Class{}

local delta = 50

---------------------------------------------------------------------------------------------------------

function Border:init(x, y, width, height)
  self.left = BorderRect(x-delta , y-delta , delta , height+delta*2)
  self.right = BorderRect(x+width , y-delta , delta , height+delta*2)
  self.up = BorderRect(x-delta , y-delta , width+delta*2 , delta)
  self.down = BorderRect(x-delta , y+height , width+delta*2 , delta)

  self.x = x
  self.y = y
  self.width = width
  self.height = height

end

---------------------------------------------------------------------------------------------------------
function Border:update(dt) end
---------------------------------------------------------------------------------------------------------
function Border:render() end
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

function BorderRect:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height

  world:add(self, self.x, self.y, self.width, self.height)

end

---------------------------------------------------------------------------------------------------------

function BorderRect:update(dt)

end

---------------------------------------------------------------------------------------------------------

function BorderRect:render()

  love.graphics.setColor(0.3, 0.2, 0.4, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

end

---------------------------------------------------------------------------------------------------------
