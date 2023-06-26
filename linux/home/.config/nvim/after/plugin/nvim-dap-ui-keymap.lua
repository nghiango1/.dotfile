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

local default_popup_map = function()
    vim.cmd [[aunmenu PopUp]]
    vim.cmd [[vnoremenu PopUp.Cut                         "+x]]
    vim.cmd [[vnoremenu PopUp.Copy                        "+y]]
    vim.cmd [[anoremenu PopUp.Paste                       "+gP]]
    vim.cmd [[vnoremenu PopUp.Paste                       "+P]]
    vim.cmd [[vnoremenu PopUp.Delete                      "_x]]
    vim.cmd [[nnoremenu PopUp.Select\ All                 ggVG]]
    vim.cmd [[vnoremenu PopUp.Select\ All                 gg0oG$]]
    vim.cmd [[inoremenu PopUp.Select\ All                 <C-Home><C-O>VG]]
    vim.cmd [[anoremenu PopUp.-1-                         <Nop>]]
    vim.cmd [[anoremenu PopUp.How-to\ disable\ mouse      <Cmd>help disable-mouse<CR>]]
end

local debug_popup_map = function()
    vim.cmd [[aunmenu PopUp]]
    vim.cmd [[vnoremenu PopUp.Copy                        "+y]]
    vim.cmd [[anoremenu PopUp.Paste                       "+gP]]
    vim.cmd [[vnoremenu PopUp.Paste                       "+P]]
    vim.cmd [[nnoremenu PopUp.Select\ All                 ggVG]]
    vim.cmd [[vnoremenu PopUp.Select\ All                 gg0oG$]]
    vim.cmd [[inoremenu PopUp.Select\ All                 <C-Home><C-O>VG]]
    vim.cmd [[anoremenu PopUp.-1-                         <Nop>]]
    vim.cmd [[nnoremenu PopUp.Add\ Breakpoint   <Cmd>DapToggleBreakpoint<CR>]]
    vim.cmd [[nnoremenu PopUp.Show\ UI       <Cmd>DapUIToggleUI<CR>]]
    vim.cmd [[vnoremenu PopUp.Evaluation        <Cmd>lua require("dapui").eval()<CR>]]
    vim.cmd [[vnoremenu PopUp.Watch2            <Cmd>DapUIAddWatch<CR>]]
end

debug_popup_map()

vim.keymap.set("n", "<leader>dui", dapui.toggle)
Hydra({
    name = 'Debug',
    config = {
        color = 'red',
    },
    mode = { 'n' },
    body = '<leader>d',
    heads = {
        { 'b', dap.toggle_breakpoint },
        { 'B', dap.set_breakpoint,   { desc = 'Breakpoint' } },
        { 'p', function()
            dap.pause()
        end, { desc = 'Pause' } },
        { '<F12>', dap.step_out,                                   { desc = 'Step out' } },
        { 't',     dap.terminate,                                  { desc = 'Terminate' } },
        { 'r',     dap.restart,                                    { desc = 'Restart' } },
        { 'l',     dap.run_last,                                   { desc = 'Run last' } },
        { 'o',     dap.repl.toggle,                                { desc = 'Repl UI' } },
        { 'J',     'viw<Cmd>lua require("dapui").eval()<CR><Esc>', { desc = 'Evaluation' } },
    }
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    vim.cmd [[set mouse=a]]
    debug_popup_map()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    vim.cmd [[set mouse=]]
    default_popup_map()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    vim.cmd [[set mouse=]]
    default_popup_map()
end
