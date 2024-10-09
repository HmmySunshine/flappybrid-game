--[[
    PipePair 类

    用于表示一组管道，它们在滚动时粘在一起，为玩家提供一个跳跃的开口，以便得分。
]]

PipePair = Class{}

-- 管道之间的间隙高度
local GAP_HEIGHT = 90

function PipePair:init(y)
    -- 标志，表示这个管道对是否已经得分（跳跃过）
    self.scored = false

    -- 初始化管道在屏幕之外
    self.x = VIRTUAL_WIDTH + 32

    -- y 值是顶部管道的 y 值；间隙是第二个较低管道的垂直偏移
    self.y = y

    -- 实例化两个属于这个管道对的管道
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- 这个管道对是否准备好从场景中移除
    self.remove = false
end

function PipePair:update(dt)
    -- 如果管道在屏幕的左边，就移除它，否则从右向左移动它
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for l, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
