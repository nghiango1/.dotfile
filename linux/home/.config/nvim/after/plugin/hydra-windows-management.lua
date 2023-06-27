local Hydra = require("hydra")

local wm_hydra = Hydra({
    name = 'Windows Managing',
    config = {
        color = 'red',
        invoke_on_body = true,
    },
    mode = { 'n' },
    body = '<C-w>m',
    heads = {
        { 'H',  '<C-w>H' },
        { 'J',  '<C-w>J' },
        { 'K',  '<C-w>K' },
        { 'L',  '<C-w>L', { desc = "Reorder" } },

        { 'h',  '<C-w>>' },
        { 'j',  '<C-w>+' },
        { 'k',  '<C-w>-' },
        { 'l',  '<C-w><', { desc = 'Resize' } },

        { '\\', '<C-w>|' },
        { '|',  '<C-w>|', { desc = 'maximize vertical size' } },
        { '-',  '<C-w>_' },
        { '_',  '<C-w>_', { desc = 'maxinize horizon size' } },
        { '=',  '<C-w>=', { desc = 'equalize' } },

        { 'c',  '<C-w>c' },
    }
})

Hydra({
    name = 'Windows Switching',
    config = {
        color = 'red',
        invoke_on_body = true,
    },
    mode = { 'n', 'x' },
    body = '<leader>w',
    heads = {
        { 'h', '<C-w>h' },
        { 'j', '<C-w>j' },
        { 'k', '<C-w>k' },
        { 'l', '<C-w>l' },
        { 'w', '<C-w>w', { desc = 'Jump' } },

        { 'm', function()
            wm_hydra:activate()
        end, { exit = true, desc = 'Managing' } },

        { 'o', '<C-w>o', { desc = 'Focus' } },
        { 'A', '<Cmd>ball<CR>', { desc = 'Show all buffer' } },

        { 's', '<C-w>s' },
        { 'v', '<C-w>v', { desc = "Split" } },

        { 'c', '<C-w>c', { desc = 'Close' } },
    }
})
