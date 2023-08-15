require("notify").setup({
    background_colour = "#000000",
    render = 'minimal',
})
vim.keymap.set("n", "<leader>vn", "<Cmd>Notifications<CR>")


local function tprint(tbl, indent)
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint .. k .. "= "
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\n"
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\n"
        elseif (type(v) == "table") then
            toprint = toprint .. tprint(v, indent + 2) .. ",\n"
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\n"
        end
    end
    toprint = toprint .. string.rep(" ", indent - 2) .. "}"
    return toprint
end

-- vim.notify = require("notify")

function DEBUG(tbl)
    require("notify")(tprint(tbl), "info")
end

function DEBUG_FUNC(func)
    local info = debug.getinfo(func)
    local functionTable = {
        name = info.name,
        source = info.source,
        linedefined = info.linedefined,
        lastlinedefined = info.lastlinedefined,
        nups = info.nups,
        -- Add more fields as needed
    }
    DEBUG(functionTable)
end
