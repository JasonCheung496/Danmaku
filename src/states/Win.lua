Win = Class{__includes = BaseState}

---------------------------------------------------------------------------------------------------------

function Win:enter(score)
  self.score = score or 0

end

---------------------------------------------------------------------------------------------------------

function Win:update(dt)
  if inputTable["c"] then
    gGameState:change("menu")
  end


end

---------------------------------------------------------------------------------------------------------

function Win:render()
  love.graphics.setColor(0.5, 0.5, 0.3, 1)
  love.graphics.setFont(love.graphics.newFont(40))
  love.graphics.print("Congratulations! You win!", 500, 200)
  love.graphics.print("Your score: " .. tostring(self.score), 500, 300)
  love.graphics.print("Press c to continue", 500, 600)

end

---------------------------------------------------------------------------------------------------------
