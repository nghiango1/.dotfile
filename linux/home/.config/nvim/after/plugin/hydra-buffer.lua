local Hydra = require("hydra")

local hint = [[
_m_ %{modifi} modifiable
]]

local OptionFunc = {}

OptionFunc.modifi = function()
    if vim.bo[0].modifiable then
        return '[x]'
    else
        return '[ ]'
    end
end

Hydra({
    name = 'Buffer',
    hint = hint,
    config = {
        color = 'red',
        invoke_on_body = true,
        hint = {
            border = 'rounded',
            funcs = OptionFunc
        }
    },
    mode = { 'n', 'x' },
    body = '<leader>b',
    heads = {
        { '<S-n>', function() vim.cmd('bprevious') end,      { desc = 'prev' } },
        { 'n',     function() vim.cmd('bnext') end,          { desc = 'next' } },
        { 'd',     function() vim.cmd('bdelete') end,        { desc = 'delete' } },
        { 'c',     function() vim.cmd('bdelete') end,        { desc = false } },
        { 'q',     function() vim.cmd('bdelete') end,        { desc = false } },
        { 'm',     function() vim.cmd('setlocal invma') end, { desc = false } },
        { 'w',     function() vim.cmd('w') end,              { desc = 'write', exit = true } },
        { 'l',     function() vim.cmd('ls') end,             { desc = 'list', exit = true } },
    },
})
