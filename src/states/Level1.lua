Level1 = Class{__includes = BaseState}

---------------------------------------------------------------------------------------------------------

function Level1:enter()
  world = bump.newWorld(64)

  player = Player()
  world:add(player, player.x, player.y, player.width, player.height)


end

---------------------------------------------------------------------------------------------------------

function Level1:update(dt)

  items, len2 = world:getItems()
  for key, item in pairs(items) do
    item:update(dt)
  end




end

---------------------------------------------------------------------------------------------------------

function Level1:render()
  love.graphics.setColor(0.1, 0.8, 0.3, 1)
  love.graphics.setFont(love.graphics.newFont(40))
  love.graphics.print("This is level1")

  for key, item in pairs(items) do
    item:render(dt)
  end

end

---------------------------------------------------------------------------------------------------------
