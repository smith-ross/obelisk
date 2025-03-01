local Component = {}
Component.__index = Component
Component.__call = function(t, id, children)
    return t:extend(id, nil, nil, children):draw()
end

local componentState = {}

function Component:new(props)
    local self = setmetatable({}, Component)

    self.props = props or {
        position = {x = 0, y = 0},
        size = {x = 0, y = 0}
    }
    
    self.children = {}
    self:init()

    return self
end

function Component:init()
    if self.id then
        componentState[self.id] = {
            effects = {},
            state = {},
            prevDependencies = {},
            memo = {},
            prevMemo = {}
        }
    end
end

function Component:render() 
    term.setCursorPos(0, 0)
end

function Component:instance()
    local clonedComponent = self:new(self.props)
    clonedComponent.render = self.render

    return clonedComponent
end

function Component:withProps(id, props)
    return function(children)
        self:extend(id, nil, props, children):draw()
    end
end

function Component:extend(id, renderFn, props, children)
    local self = self:instance()
    self.props = props or self.props
    self.id = id
    if children then
        self.children = children or self.children
    end
    if self.id and not componentState[self.id] then
        self:init()
    end
    if renderFn then
        local origRender = self.render
        self.render = function(self)
            renderFn(self)
            origRender(self)
        end
    end
    return self
end

function Component:draw()
    local r = self:render()
    for id, effect in pairs(componentState[self.id].effects) do
        local rerun = componentState[self.id].prevDependencies[id] == nil
        if not rerun then
            for i, v in pairs(componentState[self.id].prevDependencies[id] or {}) do
                if v ~= effect.dep[i] then
                    rerun = true
                    break
                end
            end
        end
        componentState[self.id].prevDependencies[id] = effect.dep
        if rerun then effect.effect() end
    end
    if r then
        r:draw()
    end
    if self.children then
        for _, child in pairs(self.children) do
            child:draw()
        end
    end
end

function Component:memo(id, memoFn, dependencies)
    local stateRef = componentState[self.id]
    componentState[self.id].memo[id] = {
        result = stateRef.memo[id] and stateRef.memo[id].result,
        dep = dependencies or {}
    }
    local rerun = stateRef.prevMemo[id] == nil
    if not rerun then
        for i, v in pairs(stateRef.prevMemo[id] or {}) do
            if v ~= dependencies[i] then
                rerun = true
                break
            end
        end
    end
    stateRef.prevMemo[id] = dependencies
    if rerun then stateRef.memo[id].result = memoFn() end
    return stateRef.memo[id].result
end

function Component:effect(id, effectFn, dependencies)
    componentState[self.id].effects[id] = {
        effect = effectFn,
        dep = dependencies or {}
    }
end

function Component:state(id, value)
    if (componentState[self.id].state[id] == nil) then
        componentState[self.id].state[id] = value
    end

    return {
        get = function()
            return self:getState(id)
        end,
        set = function(value)
            self:updateState(id, value)
        end,
        delete = function()
            self:deleteState(id)
        end,
    }
end

function Component:prop(propId)
    assert(self.props[propId], "Prop does not exist: " .. propId)
    return self.props[propId]
end

function Component:getState(id)
    return componentState[self.id].state[id]
end

function Component:updateState(id, value)
    if (componentState[self.id].state[id] == nil) then warn("State not initialised: ", id) return end
    componentState[self.id].state[id] = value
end

function Component:deleteState(id)
    componentState[self.id].state[id] = nil;
end

return Component