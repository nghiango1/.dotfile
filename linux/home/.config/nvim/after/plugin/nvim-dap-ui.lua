local dapui = require("dapui")

local user_config = {
    element_mappings = {},
    expand_lines = true,
    floating = {
        border = "single",
        position = "center",
        enter = true,
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
--   layouts = { {
--       elements = {"scopes"},
--       position = "left",
--       size = 40
--     }, {
--       elements = {"breakpoints"},
--       position = "left",
--       size = 40
--     }, {
--         elements = {"stacks"},
--         position = "left",
--         size = 40
--     }, {
--         elements = {"watches"},
--         position = "left",
--         size = 40
--     },{
--         elements = {"repl"},
--         position = "bottom",
--         size = 10
--     },{
--         elements = {"console"},
--         position = "left",
--         size = 40
--     },
--   },
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
