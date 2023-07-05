-- mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)
-- for normal mode - the word under the cursor
vim.cmd [[nmap <Leader>di <Plug>VimspectorBalloonEval]]
-- for visual mode, the visually selected text
vim.cmd [[xmap <Leader>di <Plug>VimspectorBalloonEval]]
vim.cmd([[let g:vimspector_install_gadgets = [ 'debugpy' ] ]])

vim.keymap.set("n", "<F5>", "<Plug>VimspectorContinue")
vim.keymap.set("n", "<C-b>", "<Plug>VimspectorToggleBreakpoint")
vim.keymap.set("n", "<F9>", "<Plug>VimspectorStepOver")
vim.keymap.set("n", "<F8>", "<Plug>VimspectorStepInto")

vim.keymap.set("n", "<Leader>dp", "<Cmd>popup PopUp<CR>")

-- Define a function to toggle Vimspector UI
function ToggleVimspectorUI()
        vim.fn['vimspector#Reset']()
end

-- Define the command and key mapping
vim.cmd([[command! ToggleVimspectorUI lua ToggleVimspectorUI()]])
vim.api.nvim_set_keymap('n', '<leader>dui', ':ToggleVimspectorUI<CR>', { noremap = true })

local debug_popup_map = function()
    vim.cmd [[aunmenu PopUp]]
    vim.cmd [[nnoremenu PopUp.Continue              <Plug>VimspectorContinue]]
    vim.cmd [[nnoremenu PopUp.Stop                  <Plug>VimspectorStop]]
    vim.cmd [[nnoremenu PopUp.Restart               <Plug>VimpectorRestart]]
    vim.cmd [[nnoremenu PopUp.Pause                 <Plug>VimspectorPause]]
    vim.cmd [[anoremenu PopUp.-1-                         <Nop>]]
    vim.cmd [[nnoremenu PopUp.Show\ Breakpoints     <Plug>VimspectorBreakpoints]]
    vim.cmd [[nnoremenu PopUp.Show\ Disassemble     <Plug>VimspectorDisassemble]]
    vim.cmd [[anoremenu PopUp.-2-                         <Nop>]]
    vim.cmd [[nnoremenu PopUp.Toggle\ Breakpoint    <Plug>VimspectorToggleBreakpoint]]
    vim.cmd [[anoremenu PopUp.-3-                         <Nop>]]
    vim.cmd [[nnoremenu PopUp.Go\ to            <Plug>VimspectorGoToCurrentLine]]
    vim.cmd [[nnoremenu PopUp.Go\ to\ cursor    <Plug>VimspectorRunToCursor]]
    vim.cmd [[anoremenu PopUp.-4-                         <Nop>]]
    vim.cmd [[nnoremenu PopUp.Step\ Over    <Plug>VimspectorStepOver]]
    vim.cmd [[nnoremenu PopUp.Step\ Into    <Plug>VimspectorStepInto]]
    vim.cmd [[nnoremenu PopUp.Step\ Out     <Plug>VimspectorStepOut]]
    vim.cmd [[nnoremenu PopUp.Step\ Into    <Plug>VimspectorStepInto]]
    vim.cmd [[nnoremenu PopUp.Eval          <Plug>VimspectorBalloonEval]]
end

debug_popup_map()
