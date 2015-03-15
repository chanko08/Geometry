local StateMachine = class({})

function StateMachine:init()
    self.possible_states = {}
    self.state = nil
end

function StateMachine:update(dt)
    self.state:update(dt)
end

function StateMachine:transition(from,to)
    if self.possible_states[to] then
        if from then from:leave() end
        self.state = to
        self.state:enter()
    end
end

function StateMachine:add(state)
    self.possible_states[state] = state
end

function StateMachine:enter(state)
    if self.possible_states[state] then
        self:transition(self.state, state)
    end
end

return StateMachine