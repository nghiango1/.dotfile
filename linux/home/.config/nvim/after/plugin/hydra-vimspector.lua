local Hydra = require("hydra")

Hydra({
    name = 'Debug',
    config = {
        color = 'red',
        invoke_on_body = true,
        hint = {
            border = 'rounded',
        }
    },
    mode = { 'n', 'x' },
    body = '<leader>d',
    heads = {
        { 'c',  "<Plug>VimspectorContinue",        { desc = 'Continue' } },
        { 's',  "<Plug>VimspectorStop",            { desc = 'Stop' } },
        { 'r',  "<Plug>VimpectorRestart",          { desc = 'Restart' } },
        { 'p',  "<Plug>VimspectorPause",           { desc = 'Pause' } },
        { 'vp', "<Cmd>popup PopUp<CR>",            { desc = 'Show PopUp' } },
        { 'vb', "<Plug>VimspectorBreakpoints",     { desc = 'Show Breakpoint' } },
        { 'vd', "<Plug>VimspectorDisassemble",     { desc = 'Show Disassemble' } },
        { 'vq', "<Cmd>ToggleVimspectorUI<CR>",     { desc = "Close UI" } },
        { 'gl', "<Plug>VimspectorGoToCurrentLine", { desc = "Go line" } },
        { 'gc', "<Plug>VimspectorRunToCursor",     { desc = "Go Cursor" } },
        { 'so', "<Plug>VimspectorStepOver",        { desc = "Step over" } },
        { 'si', "<Plug>VimspectorStepInto",        { desc = "Step into" } },
        { 'so', "<Plug>VimspectorStepOut",         { desc = "Step out" } },
        { 'si', "<Plug>VimspectorStepInto",        { desc = "Step into" } },
        { 'e',  "<Plug>VimspectorBalloonEval",     { desc = "Eval" } },
    },
})
