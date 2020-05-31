Level1 = Class{__includes = BaseState}

---------------------------------------------------------------------------------------------------------

function Level1:enter()
  world = bump.newWorld()

  player = Player(GAME_WIDTH/2 - 100, GAME_HEIGHT - 200, 1)
  enemy1 = Enemy(GAME_WIDTH/2 - 100, 200)
  enemy2 = Enemy(GAME_WIDTH/2 + 100, 200)
  curRoom = Border(300, 50, 1000, 800)

  items = world:getItems()

  --HUD init
  HUD = {
    playerHP = {x = 100, y = 10, width = 50, height = 300, barY = 10, barHeight = 300},
    enemyHP = {x = 180, y = 10, width = 50, height = 300, barY = 10, barHeight = 300}
  }

end

---------------------------------------------------------------------------------------------------------

function Level1:update(dt)
  items = world:getItems()

  for key, item in pairs(items) do
    item:update(dt)
  end

  --HUD update
  HUD.playerHP.barHeight = HUD.playerHP.height*player.HP/100
  HUD.playerHP.barY = HUD.playerHP.y + HUD.playerHP.height - HUD.playerHP.barHeight
  HUD.enemyHP.barHeight = HUD.enemyHP.height*enemy1.HP/100
  HUD.enemyHP.barY = HUD.enemyHP.y + HUD.enemyHP.height - HUD.enemyHP.barHeight

  if inputTable["r"] then
    gGameState:change("level1")
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

  --HUD
  love.graphics.setColor(0.8, 0.7, 0.5, 0.7)
  love.graphics.rectangle("fill", HUD.playerHP.x, HUD.playerHP.barY, HUD.playerHP.width, HUD.playerHP.barHeight)
  love.graphics.setColor(0.8, 0.9, 0.7, 1)
  love.graphics.rectangle("line", HUD.playerHP.x, HUD.playerHP.y, HUD.playerHP.width, HUD.playerHP.height)

  love.graphics.setColor(0.2, 0.3, 0.5, 0.7)
  love.graphics.rectangle("fill", HUD.enemyHP.x, HUD.enemyHP.barY, HUD.enemyHP.width, HUD.enemyHP.barHeight)
  love.graphics.setColor(0.2, 0.1, 0.3, 1)
  love.graphics.rectangle("line", HUD.enemyHP.x, HUD.enemyHP.y, HUD.enemyHP.width, HUD.enemyHP.height)


end

---------------------------------------------------------------------------------------------------------
