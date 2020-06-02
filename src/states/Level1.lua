Level1 = Class{__includes = BaseState}

---------------------------------------------------------------------------------------------------------

function Level1:enter(playerAttri)
  world = bump.newWorld()
  gameScore = 0

  local newPlayerAttri = playerAttri or { x = GAME_WIDTH/2 - 100, y = GAME_HEIGHT - 200, type = 1, HP = 30 }
  player = Player(newPlayerAttri)

  local newEnemyAttri = { x = GAME_WIDTH/2 - 100, y = 200, HP = 1000 }
  enemy1 = Enemy1(newEnemyAttri)
  local newEnemyAttri = { x = GAME_WIDTH/2 + 100, y = 200, HP = 1000 }
  enemy2 = Enemy1(newEnemyAttri)

  curRoom = Border(300, 50, 1000, 800)

  items = world:getItems()

  --HUD init
  HUD = {
    playerHP = {x = 100, y = 10, width = 50, height = 300, barY = 10, barHeight = 300, max = playerSet[player.type].maxHP},
    enemyHP = {x = 180, y = 10, width = 50, height = 300, barY = 10, barHeight = 300, max = enemy1.HP},
    score = {x = 1200, y = 10, val = gameScore}
  }

end

---------------------------------------------------------------------------------------------------------

function Level1:update(dt)
  items = world:getItems()

  enemiesNumber = 0
  for key, item in pairs(items) do
    item:update(dt)
    if item.__index and (item.__index == Enemy1 or item.__index == Enemy2) then
      enemiesNumber = enemiesNumber + 1
    end
  end

  --HUD update
  HUD.playerHP.barHeight = HUD.playerHP.height* player.HP /HUD.playerHP.max
  HUD.playerHP.barY = HUD.playerHP.y + HUD.playerHP.height - HUD.playerHP.barHeight
  HUD.enemyHP.barHeight = HUD.enemyHP.height* enemy1.HP /HUD.enemyHP.max
  HUD.enemyHP.barY = HUD.enemyHP.y + HUD.enemyHP.height - HUD.enemyHP.barHeight
  HUD.score.val = gameScore

  if inputTable["r"] then
    gGameState:change("level1")
  elseif player.HP <= 0 then
    gGameState:change("lose", gameScore)
  elseif enemiesNumber == 0 and inputTable["c"] then
    gGameState:change("level2", {HP = player.HP, type = player.type})
  elseif inputTable["p"] then
    gGameState:change("level2", {HP = player.HP, type = player.type})
  end


end

---------------------------------------------------------------------------------------------------------

function Level1:render()
  love.graphics.setColor(0.1, 0.8, 0.3, 1)
  love.graphics.setFont(love.graphics.newFont(40))
  --love.graphics.print("This is level1")

  local i = 1
  for key, item in pairs(items) do
    item:render()
    --love.graphics.print(tostring(item), 0, i*50)
    i = i + 1
  end

  --HUD display
  love.graphics.setColor(0.8, 0.7, 0.5, 0.7)
  love.graphics.rectangle("fill", HUD.playerHP.x, HUD.playerHP.barY, HUD.playerHP.width, HUD.playerHP.barHeight)
  love.graphics.setColor(0.8, 0.9, 0.7, 1)
  love.graphics.rectangle("line", HUD.playerHP.x, HUD.playerHP.y, HUD.playerHP.width, HUD.playerHP.height)

  love.graphics.setColor(0.2, 0.3, 0.5, 0.7)
  love.graphics.rectangle("fill", HUD.enemyHP.x, HUD.enemyHP.barY, HUD.enemyHP.width, HUD.enemyHP.barHeight)
  love.graphics.setColor(0.2, 0.1, 0.3, 1)
  love.graphics.rectangle("line", HUD.enemyHP.x, HUD.enemyHP.y, HUD.enemyHP.width, HUD.enemyHP.height)

  love.graphics.setColor(0.1, 0.8, 0.3, 1)
  love.graphics.print("Score: " .. tostring(HUD.score.val), HUD.score.x, HUD.score.y)


end

---------------------------------------------------------------------------------------------------------
