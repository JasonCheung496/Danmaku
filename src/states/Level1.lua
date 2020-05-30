Level1 = Class{__includes = BaseState}

---------------------------------------------------------------------------------------------------------

function Level1:enter()
  world = bump.newWorld()

  player = Player()
  world:add(player, player.x, player.y, player.width, player.height)



  items = world:getItems()

end

---------------------------------------------------------------------------------------------------------

function Level1:update(dt)
  items = world:getItems()

  for key, item in pairs(items) do
    item:update(dt)
  end


end

---------------------------------------------------------------------------------------------------------

function Level1:render()
  love.graphics.setColor(0.1, 0.8, 0.3, 1)
  love.graphics.setFont(love.graphics.newFont(40))
  love.graphics.print("This is level1")

  local i = 1
  for key, item in pairs(items) do
    item:render()
    love.graphics.print(tostring(item), 0, i*100)
    i = i + 1
  end

end

---------------------------------------------------------------------------------------------------------
