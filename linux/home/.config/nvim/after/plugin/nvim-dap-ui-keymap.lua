local dap, dapui = require("dap"), require("dapui")
local Hydra      = require("hydra")
local extension  = require('ylsama.extension')

local function watchExpression(expression)
    dapui.elements.watches.add(expression)
end

local addSelectedTextToWatch = function()
    watchExpression(extension.getVisualSelection())
end

vim.api.nvim_create_user_command('DapUIAddWatch', addSelectedTextToWatch, {})
vim.api.nvim_create_user_command('DapUIToggleUI', dapui.toggle, {})

vim.cmd [[nnoremenu Debug.Add\ Breakpoint   <Cmd>DapToggleBreakpoint<CR>]]
vim.cmd [[nnoremenu Debug.Show\ UI          <Cmd>DapUIToggleUI<CR>]]
vim.cmd [[vnoremenu Debug.Evaluation        <Cmd>lua require("dapui").eval()<CR>]]
vim.cmd [[vnoremenu Debug.Watch             <Cmd>DapUIAddWatch<CR>]]

vim.keymap.set("n", "<leader>dui", dapui.toggle)
vim.keymap.set("n", "<leader>dp", "<Cmd>popup Debug<CR>")

dap.listeners.after.event_initialized["dapui_config"] = function()
    vim.cmd [[set mouse=a]]
    vim.keymap.set({ "n", "x", "v" }, "<RightMouse>", "<Cmd>popup Debug<CR>")
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    vim.cmd [[set mouse=]]
    vim.keymap.set({ "n", "x", "v" }, "<RightMouse>", "<Cmd>popup PopUp<CR>")
end

dap.listeners.before.event_exited["dapui_config"] = function()
    vim.cmd [[set mouse=]]
    vim.keymap.set({ "n", "x", "v" }, "<RightMouse>", "<Cmd>popup PopUp<CR>")
end
