require("sg").setup {}

vim.cmd [[nnoremap <space>fs <cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>]]

vim.keymap.set('n', '<leader>ch', function()
    require("sg.cody.commands").focus_history()
end)
vim.keymap.set('n', '<leader>cp', function()
    require("sg.cody.commands").focus_prompt()
end)
