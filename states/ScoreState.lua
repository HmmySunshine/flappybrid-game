--[[
    ScoreState 类
    作者：Colton Ogden
    cogden@cs50.harvard.edu

    一个简单的状态，用于在玩家回到游戏状态之前显示他们的分数。
    当玩家与管道碰撞时，从 PlayState 转换到该状态。
]]

ScoreState = Class{__includes = BaseState}

--[[
    当我们进入分数状态时，我们期望从 PlayState 接收到分数，
    以便我们知道要在状态中渲染什么。
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- 当按下 enter 或 return 键时，返回到 play 状态
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- 简单地将分数渲染到屏幕中央
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end
