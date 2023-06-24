local dap, dapui = require("dap"), require("dapui")

local widgets = require('dap.ui.widgets')
local my_sidebar = widgets.centered_float(widgets.scopes)

vim.keymap.set("n", "<leader>dui", dapui.toggle)
local Hydra = require("hydra")

Hydra({
    name = 'Debug',
    config = {
        color = 'red',
        invoke_on_body = true,
    },
    mode = { 'n', 'x' },
    body = '<leader>d',
    heads = {
        { 'w', function()
            my_sidebar.toggle()
        end, { desc = 'sidebar' } },
    }
})
