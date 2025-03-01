local Component = {}
Component.__index = Component
Component.__call = function(t, id, children)
    return t:extend(id, nil, nil, children):draw()
end

local state = {}
local effects = {}
local prevDependencies = {}

function Component:new(props)
    local self = setmetatable({}, Component)

    self.props = props or {
        position = {x = 0, y = 0},
        size = {x = 0, y = 0}
    }
    if self.id then
        effects[self.id] = {}
        state[self.id] = {}
        prevDependencies[self.id] = {}
    end
    self.children = {}

    return self
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
    if self.id and not state[self.id] then
        state[self.id] = {}
        effects[self.id] = {}
        prevDependencies[self.id] = {}
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
    for id, effect in pairs(effects[self.id]) do
        local rerun = prevDependencies[self.id][id] == nil
        if not rerun then
            for i, v in pairs(prevDependencies[self.id][id] or {}) do
                if v ~= effect.dep[i] then
                    rerun = true
                    break
                end
            end
        end
        prevDependencies[self.id][id] = effect.dep
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

function Component:effect(id, effectFn, dependencies)
    effects[self.id][id] = {
        effect = effectFn,
        dep = dependencies or {}
    }
end

function Component:defineState(id, value)
    if (state[self.id][id] == nil) then
        state[self.id][id] = value
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
    return state[self.id][id]
end

function Component:updateState(id, value)
    if (state[self.id][id] == nil) then warn("State not initialised: ", id) return end
    state[self.id][id] = value
end

function Component:deleteState(id)
    state[self.id][id] = nil;
end

return Component