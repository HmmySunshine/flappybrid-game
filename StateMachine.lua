--[[

    代码取自 http://howtomakeanrpg.com 的课程

    使用方法：

    状态只在需要时创建，以节省内存，减少清理错误，并由于内存中的数据更多，垃圾收集需要更长的时间，从而提高速度。

    状态使用字符串标识符和初始化函数添加。
    期望初始化函数被调用时，将返回一个包含 Render、Update、Enter 和 Exit 方法的表。

    gStateMachine = StateMachine {
            ['MainMenu'] = function()
                return MainMenu()
            end,
            ['InnerGame'] = function()
                return InnerGame()
            end,
            ['GameOver'] = function()
                return GameOver()
            end,
        }
    gStateMachine:change("MainGame")

    传递给 Change 函数的状态名称之后的参数将转发到正在更改的状态的 Enter 函数。

    状态标识符应与状态表具有相同的名称，除非有充分的理由不这样做。即，MainMenu 创建一个使用 MainMenu 表的状态。这使事情保持简单。
]]


StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end
