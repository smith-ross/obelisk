local Obelisk = {}

Obelisk.__init = false
Obelisk.__exportedModules = {
    service = require("module/service/init"),
    ui = require("module/ui/init")
}

function Obelisk.init()
    if Obelisk.__init then return end
    Obelisk.__callAllModules("init")
    Obelisk.__callAllModules("start")
    Obelisk.__init = true
end

function Obelisk.module(moduleName)
    if Obelisk.__exportedModules[moduleName] then
        return Obelisk.__exportedModules[moduleName]
    end
    error("Module Import Error: Can't find Obelisk Module \"" .. moduleName .. "\"")
end

function Obelisk.m(moduleName)
    return Obelisk.module(moduleName)
end

function Obelisk.withParallel(mainFn)
    parallel.waitForAny(mainFn, Obelisk.m("service").startUpdate)
end

function Obelisk.__callAllModules(parameter, ...)
    for _, module in pairs(Obelisk.__exportedModules) do
        if module[parameter] then module[parameter](...) end
    end
end

return Obelisk