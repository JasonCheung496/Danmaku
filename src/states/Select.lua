Select = Class{__includes = BaseState}

local totalType = #playerSet

---------------------------------------------------------------------------------------------------------

function Select:enter()
  world = bump.newWorld()
  typeSelected = 1 -- 1 to 3

  -- new playerDemo
  local newPlayerDemoAttri = {
    x = GAME_WIDTH/4*3,
    y = GAME_HEIGHT/3*2,
    type = typeSelected
  }
  playerDemo = PlayerDemo(newPlayerDemoAttri)

  selectionMenu = {}

  items = world:getItems()

end

---------------------------------------------------------------------------------------------------------

function Select:update(dt)
  items = world:getItems()
  -- update all items
  for key, item in pairs(items) do
    item:update(dt)
  end

  -- select type
  -- 1 <= typeSelected <= totalType
  if inputTable["up"] then
    typeSelected = (typeSelected-2) % totalType + 1
  elseif inputTable["down"] then
    typeSelected = typeSelected % totalType + 1
  end

  -- calculate selectionMenu
  local x, y = GAME_WIDTH/4-20, 300
  selectionMenu = {}
  for i = 1, totalType do
    if i == typeSelected then
      table.insert(selectionMenu, {
        text = tostring(i),
        x = x,
        y = y,
        font = lFont,
        color = {1,0,1}
      })
      y = y + 150
    else
      table.insert(selectionMenu, {
        text = tostring(i),
        x = x,
        y = y,
        font = mFont,
        color = {1,1,1}
      })
      y = y + 90
    end
  end

  playerDemo:changeType(typeSelected)
  playerDemo:update(dt)

  if inputTable["c"] then
    gGameState:change("level1", {type = typeSelected})
  end

end

---------------------------------------------------------------------------------------------------------

function Select:render()
  items = world:getItems()

  love.graphics.setColor(0.1, 0.9, 0.9, 1)
  love.graphics.line(GAME_WIDTH/2, 0, GAME_WIDTH/2, GAME_HEIGHT)

  -- render all items
  for key, item in pairs(items) do
    item:render()
  end

  -- render selection
  for k, val in pairs(selectionMenu) do
    love.graphics.setFont(val.font)
    love.graphics.setColor(val.color)
    love.graphics.print(val.text, val.x, val.y)
  end

  love.graphics.setFont(lFont)
  love.graphics.setColor(1,1,1)
  love.graphics.print("Choose your battleship:", GAME_WIDTH/4-300, 100)
  playerDemo:render()

end

---------------------------------------------------------------------------------------------------------
