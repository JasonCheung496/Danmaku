HUD = {}

function HUD.init(hud, player, score)
  --HUD init
  local border = 10
  hud.HPFrame = {x = 100, y = 100, width = 70, height = 400, color = {0.490,0.804,1}}
  hud.score = {x = 1400, y = 10, val = score}

  hud.HPBlock = {height = 20, deltaY = border, maxHP = playerSet[player.type].maxHP, curHP = player.HP}
  hud.HPBlock.x = hud.HPFrame.x + border
  hud.HPBlock.y = hud.HPFrame.y + hud.HPFrame.height - border
  hud.HPBlock.width = hud.HPFrame.width - border*2
  hud.HPBlock.maxHeight = hud.HPFrame.height - border*2
  hud.HPBlock.curHeight = hud.HPBlock.maxHeight * hud.HPBlock.curHP / hud.HPBlock.maxHP
  hud.HPBlock.deltaColor = 2/math.floor((hud.HPFrame.height - border)/(border + hud.HPBlock.height))

end

function HUD.update(hud, player, score)
  -- HUD update
  hud.HPBlock.curHP = player.HP
  hud.HPBlock.curHeight = hud.HPBlock.maxHeight * hud.HPBlock.curHP / hud.HPBlock.maxHP
  hud.score.val = gameScore

end

function HUD.render(hud)
  -- HUD display
  -- HP frame
  love.graphics.setColor(hud.HPFrame.color)
  love.graphics.rectangle("fill", hud.HPFrame.x, hud.HPFrame.y, hud.HPFrame.width, hud.HPFrame.height)

  -- HP blocks
  local h = hud.HPBlock.height
  local color = {1,0,0}
  while h <= hud.HPBlock.curHeight do
    -- color changes from red to yellow to green
    if color[2] < 1 then
      color[2] = color[2] + hud.HPBlock.deltaColor
    else
      color[1] = color[1] - hud.HPBlock.deltaColor + 1 - color[2]
      color[2] = 1
    end
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", hud.HPBlock.x, hud.HPBlock.y-h, hud.HPBlock.width, hud.HPBlock.height)
    h  = h + hud.HPBlock.height + hud.HPBlock.deltaY
  end

  -- game score
  love.graphics.setColor(0.1, 0.8, 0.3, 1)
  love.graphics.setFont(sFont)
  love.graphics.print("Score: ", hud.score.x, hud.score.y)
  love.graphics.print(tostring(hud.score.val), hud.score.x, hud.score.y + 50)
end
