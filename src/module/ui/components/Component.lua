local Component = {}
Component.__index = Component
Component.__call = function(t, children)
    return t:extend()(children):draw()
end

function Component:new(props)
    local self = setmetatable({}, Component)

    self.props = props or {
        position = {x = 0, y = 0},
        size = {x = 0, y = 0}
    }
    self.state = {}
    self.effects = {}
    self.prevDependencies = {}
    self.children = {}

    return self
end

function Component:render() end

function Component:instance()
    local clonedComponent = self:new(self.props)
    clonedComponent.render = self.render

    return clonedComponent
end

function Component:withProps(props)
    return self:extend(nil, props):draw()
end

function Component:extend(renderFn, props)
    local self = self:instance()
    self.props = props or self.props
    if renderFn then
        local origRender = self.render
        self.render = function(self)
            renderFn(self)
            origRender(self)
        end
    end
    return function(c)
        self.children = c
    end
end

function Component:draw()
    print("Attempt draw")
    print(self.props.id)
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
    if (self.state[id]) then return end
    self.state[id] = value

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
    return self.state[id]
end

function Component:updateState(id, value)
    if (self.state[id] == nil) then warn("State not initialised: ", id) return end
    self.state[id] = value
end

function Component:deleteState(id)
    self.state[id] = nil;
end

return Component