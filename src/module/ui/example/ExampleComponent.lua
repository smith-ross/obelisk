local Component = require("components/Component")
local TextLabel = require("components/TextLabel")
local RandomChildComponent = require("components/RandomChildComponent")

local ExampleComponent = Component:extend(function(exampleComponent)
    local counter = exampleComponent:state("Counter", 0)
    local text = exampleComponent:state("Text", "Counted multiple of 5 0 times.")

    exampleComponent:effect("mod5Effect", function()
        if counter.get() % 5 == 0 then
            text.set("Counted multiple of 5 " .. tostring(counter.get() % 5) .. " times.")
        end
    end, {counter.get()})

    return TextLabel:withProps({
        text = text.get(),
        colour = {255, 255, 255},
        onClick = function() counter.set(counter.get() + 1) end
    }) ({
        RandomChildComponent(),
        RandomChildComponent(),
        RandomChildComponent(),
    })
end)

return ExampleComponent