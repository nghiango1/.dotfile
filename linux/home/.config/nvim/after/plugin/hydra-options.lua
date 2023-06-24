local Hydra = require("hydra")

local hint = [[
  Options:
  _m_ %{mouse} mouse
  _i_ %{list} invisible characters
  _w_ %{wrap} wrap
  _n_ %{nu} number
  _r_ %{rnu} relative number
]]

local OptionFunc = {}

OptionFunc.mouse = function()
    if vim.o.mouse == '' then
        return '[ ]'
    else
        return '[x]'
    end
end

Hydra({
    name = 'Options',
    hint = hint,
    config = {
        color = 'red',
        invoke_on_body = true,
        hint = {
            border = 'rounded',
            position = 'bottom',
            funcs = OptionFunc
        }
    },
    mode = { 'n', 'x' },
    body = '<leader>o',
    heads = {
        { 'n', function()
            if vim.o.number == true then
                vim.o.number = false
            else
                vim.o.number = true
            end
        end, { desc = 'number' } },
        { 'r', function()
            if vim.o.relativenumber == true then
                vim.o.relativenumber = false
            else
                vim.o.number = true
                vim.o.relativenumber = true
            end
        end, { desc = 'relativenumber' } },
        { 'i', function()
            if vim.o.list == true then
                vim.o.list = false
            else
                vim.o.list = true
            end
        end, { desc = 'show invisible' } },
        { 'w', function()
            if vim.o.wrap ~= true then
                vim.o.wrap = true
                vim.keymap.set('n', 'k', function() return vim.v.count > 0 and 'k' or 'gk' end,
                    { expr = true, desc = 'k or gk' })
                vim.keymap.set('n', 'j', function() return vim.v.count > 0 and 'j' or 'gj' end,
                    { expr = true, desc = 'j or gj' })
            else
                vim.o.wrap = false
                vim.keymap.del('n', 'k')
                vim.keymap.del('n', 'j')
            end
        end, { desc = 'wrap' } },
        { 'm', function()
            if vim.o.mouse == '' then
                vim.o.mouse = 'a'
            else
                vim.o.mouse = ''
            end
        end, { desc = 'cursor line' } },
        { '<Esc>', nil, { exit = true } }
    }
})
