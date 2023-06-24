local dap, dapui = require("dap"), require("dapui")

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

local user_config = {
    controls = {
        element = "repl",
        enabled = true,
        icons = {
            disconnect = "",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = ""
        }
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
        border = "single",
        mappings = {
            close = { "q", "<Esc>" }
        }
    },
    force_buffers = true,
    icons = {
        collapsed = "+",
        current_frame = "+",
        expanded = "-"
    },
    layouts = { {
        elements = { {
            id = "scopes",
            size = 0.25
        }, {
            id = "breakpoints",
            size = 0.25
        }, {
            id = "stacks",
            size = 0.25
        }, {
            id = "watches",
            size = 0.25
        } },
        position = "left",
        size = 40
    }, {
        elements = { {
            id = "repl",
            size = 0.5
        }, {
            id = "console",
            size = 0.5
        } },
        position = "bottom",
        size = 10
    } },
    mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t"
    },
    render = {
        indent = 1,
        max_value_lines = 100
    }
}

dapui.setup(user_config)

vim.keymap.set("n", "<leader>dui", dapui.toggle)
dap.listeners.after.event_initialized["dapui_config"] = function()
    vim.cmd [[set mouse=a]]
    debug_popup_map()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
    vim.cmd [[set mouse=]]
    default_popup_map()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
    vim.cmd [[set mouse=]]
    default_popup_map()
end
