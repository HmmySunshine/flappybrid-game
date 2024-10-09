--[[

    游戏的主要状态，玩家在这里玩游戏。
    管道对会从屏幕右边生成，并不断向左移动。
    玩家控制小鸟，通过点击或按下空格键来跳跃。
    如果小鸟碰到地面或管道，游戏结束。
]]

PlayState = Class{__includes = BaseState}

-- 管道速度
PIPE_SPEED = 60
-- 管道宽度
PIPE_WIDTH = 70
-- 管道高度
PIPE_HEIGHT = 288

-- 小鸟宽度
BIRD_WIDTH = 38
-- 小鸟高度
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    -- 初始化上次记录的间隙位置，以便其他间隙基于此
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- 更新管道生成计时器
    self.timer = self.timer + dt

    -- 每隔 1.5 秒生成一个新的管道对
    if self.timer > 2 then
        -- 修改上次放置的 Y 坐标，使管道间隙不要太远
        -- 不要高于屏幕顶部 10 像素，也不要低于间隙长度（90 像素）从底部
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        -- 在屏幕右端添加一个新的管道对，Y 坐标为我们的新 Y
        table.insert(self.pipePairs, PipePair(y))

        -- 重置计时器
        self.timer = 0
    end

    -- 对于每一对管道..
    for k, pair in pairs(self.pipePairs) do
        -- 如果管道已经过去小鸟的左边，就得分
        -- 确保如果已经得分，就忽略它
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        -- 更新管道对的位置
        pair:update(dt)
    end

    -- 我们需要这个第二个循环，而不是在之前的循环中删除，
    -- 因为在删除时修改表，而不是显式键，会导致跳过下一个管道，
    -- 因为所有隐式键（数字索引）在表删除后都会自动向下移动
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- 简单的小鸟和所有管道对的碰撞
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()

                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    -- 基于重力和小鸟输入更新小鸟
    self.bird:update(dt)

    -- 如果我们到达地面，就重置
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end

--[[
    当从另一个状态转换到这个状态时调用。
]]
function PlayState:enter()
    -- 如果我们从死亡状态转换过来，就重新开始滚动
    scrolling = true
end

--[[
    当这个状态转换到另一个状态时调用。
]]
function PlayState:exit()
    -- 停止死亡/得分屏幕的滚动
    scrolling = false
end
