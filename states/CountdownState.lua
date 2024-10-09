

CountdownState = Class{__includes = BaseState}

-- 每次倒计时需要 1 秒
COUNTDOWN_TIME = 0.75

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

--[[
    跟踪已经过去的时间，并在计时器超过倒计时时间时减少计数。
    如果我们达到 0，我们应该转换到 PlayState。
]]
function CountdownState:update(dt)
    self.timer = self.timer + dt

    -- 将计时器循环回 0（加上我们超过倒计时时间的时间）
    -- 一旦超过倒计时时间，就减少计数一次
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        -- 当计数达到 0 时，我们应该转换到 PlayState
        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    -- 在屏幕中央渲染大的计数
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end
