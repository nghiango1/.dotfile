local dap, dapui = require("dap"), require("dapui")
local Hydra = require("hydra")

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
    vim.cmd [[nnoremenu PopUp.Add\ Breakpoint   <Cmd>DapToggleBreakpoint<CR>]]
    vim.cmd [[nnoremenu PopUp.Continue          <Cmd>DapContinue<CR>]]
    vim.cmd [[nnoremenu PopUp.Terminate         <Cmd>DapTerminate<CR>]]
    vim.cmd [[vnoremenu PopUp.Evaluation        <Cmd>lua require("dapui").eval()<CR>]]
end

vim.keymap.set("n", "<leader>dui", dapui.toggle)
local debug_hydra = Hydra({
    name = 'Debug',
    config = {
        color = 'pink',
        invoke_on_body = true,
    },
    mode = { 'n' },
    body = '<leader>d',
    heads = {
        { '<C-b>', dap.toggle_breakpoint,                          { desc = 'Breakpoint' } },
        { '<F5>',  dap.continue,                                   { desc = 'Run/Continue' } },
        { 's',     dap.pause,                                      { desc = 'Pause' } },
        { '<F8>',  dap.step_into,                                  { desc = 'Step into' } },
        { '<F9>',  dap.step_over,                                  { desc = 'Step over' } },
        { 't',     dap.terminate,                                  { desc = 'Terminate' } },
        { 'r',     dap.restart,                                    { desc = 'Restart' } },
        { 'o',     dap.repl.toggle,                                { desc = 'Repl UI' } },
        { 'i',     dapui.float_element,                            { desc = 'Info' } },
        { 'J',     'viw<Cmd>lua require("dapui").eval()<CR><Esc>', { desc = 'Evaluation' } }
    }
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
    vim.cmd [[set mouse=a]]
    debug_hydra:activate()
    debug_popup_map()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
    vim.cmd [[set mouse=]]
    debug_hydra:exit()
    default_popup_map()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
    vim.cmd [[set mouse=]]
    debug_hydra:exit()
    default_popup_map()
end
