-- 引入 'push' 模块，用于处理屏幕分辨率缩放来自github
push = require 'push'

-- 引入 'Class' 库，用于创建类和对象
Class = require 'class'

-- 引入状态机类，用于管理游戏状态之间的转换
require 'StateMachine'

-- 引入所有可能的状态类
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

require 'Bird'
require 'Pipe'
require 'PipePair'

-- 物理屏幕尺寸
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- 虚拟分辨率尺寸
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png') -- 背景图像
local backgroundScroll = 0 -- 背景滚动位置

local ground = love.graphics.newImage('ground.png') -- 地面图像
local groundScroll = 0 -- 地面滚动位置

local BACKGROUND_SCROLL_SPEED = 30 -- 背景滚动速度
local GROUND_SCROLL_SPEED = 60 -- 地面滚动速度

local BACKGROUND_LOOPING_POINT = 413 -- 背景循环点

function love.load()
    -- 设置默认的图像过滤方式为最近邻过滤
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- 初始化随机数生成器的种子
    math.randomseed(os.time())

    -- 设置窗口标题
    love.window.setTitle('Fifty Bird')

    -- 初始化各种大小的字体
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- 初始化声音表
    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        -- 引入背景音乐
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    -- 开始播放背景音乐，并设置循环
    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- 设置虚拟分辨率
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- 初始化状态机，并设置所有可能的状态
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    -- 初始化键盘输入表
    love.keyboard.keysPressed = {}

    -- 初始化鼠标输入表
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    -- 当窗口大小改变时，调整屏幕尺寸
    push:resize(w, h)
end

function love.keypressed(key)
    -- 将按键添加到本帧按下的键表中
    love.keyboard.keysPressed[key] = true

    -- 如果按下的是退出键，则退出游戏
    if key == 'escape' then
        love.event.quit()
    end
end

-- 当鼠标按钮被按下时，LÖVE2D 调用的回调函数
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

-- 自定义函数，检查在当前帧是否按下了指定的键
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

-- 类似于键盘函数，但用于鼠标按钮
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    -- 滚动背景和地面，达到一定值后循环回0
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    -- 更新状态机
    gStateMachine:update(dt)

    -- 清空本帧按下的键和鼠标按钮
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end
function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
