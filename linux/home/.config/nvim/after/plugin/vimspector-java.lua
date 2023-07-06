local jdt_ls_debugger_port = 0

local function StartDebugging()
    if jdt_ls_debugger_port <= 0 then
        jdt_ls_debugger_port = vim.lsp.buf.execute_command({ command = 'vscode.java.startDebugSession' })
        if jdt_ls_debugger_port == nil then
            print("Unable to get DAP port - is JDT.LS initialized?")
            jdt_ls_debugger_port = 0
            return
        end
    end
    print(jdt_ls_debugger_port)

    vim.api.nvim_call_function('vimspector#LaunchWithSettings', { DAPPort = jdt_ls_debugger_port })
end

vim.keymap.set("n", "<Leader><F5>", StartDebugging)

-- vim.api.nvim_exec(
--     [[
-- let s:jdt_ls_debugger_port = 0
-- function! s:StartDebugging()
--   if s:jdt_ls_debugger_port <= 0
--     " Get the DAP port
--     let s:jdt_ls_debugger_port = youcompleteme#GetCommandResponse(
--       \ 'ExecuteCommand',
--       \ 'vscode.java.startDebugSession' )
--
--     if s:jdt_ls_debugger_port == ''
--        echom "Unable to get DAP port - is JDT.LS initialized?"
--        let s:jdt_ls_debugger_port = 0
--        return
--      endif
--   endif
--
--   " Start debugging with the DAP port
--   call vimspector#LaunchWithSettings( { 'DAPPort': s:jdt_ls_debugger_port } )
-- endfunction
--
-- nnoremap <silent> <buffer> <Leader><F5> :call <SID>StartDebugging()<CR>
-- ]], false)
