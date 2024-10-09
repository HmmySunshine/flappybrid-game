

Bird = Class{}

local GRAVITY = 0.5-- 调整重力值

-- 初始化鸟的属性
function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.dy = 0
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
-- 检测鸟和管道的碰撞
function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

-- 更新鸟的位置
function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt


    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = -0.2 -- 调整跳跃高度
        sounds['jump']:play()
    end

    

    self.y = self.y + self.dy
end

-- 渲染鸟
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
