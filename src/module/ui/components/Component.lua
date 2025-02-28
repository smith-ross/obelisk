local Component = {}
Component.__index = Component
Component.__call = function(t, id, children)
    return t:extend(id, nil, nil, children):draw()
end

local state = {}

function Component:new(props)
    local self = setmetatable({}, Component)

    self.props = props or {
        position = {x = 0, y = 0},
        size = {x = 0, y = 0}
    }
    self.effects = {}
    self.prevDependencies = {}
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
    for _, effect in pairs(self.effects) do
        local rerun = self.prevDependencies[effect.effect] == nil
        if not rerun then
            for i, v in pairs(self.prevDependencies[effect.effect] or {}) do
                if v ~= effect.dep[i] then
                    rerun = true
                    break
                end
            end
        end
        self.prevDependencies[effect.effect] = effect.dep
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
    self.effects[id] = {
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