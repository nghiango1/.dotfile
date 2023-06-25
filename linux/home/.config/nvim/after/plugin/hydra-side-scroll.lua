local Hydra = require('hydra')

Hydra({
   name = 'Side scroll',
   color = 'teal',
   mode = 'n',
   body = '<leader>z',
   heads = {
      { 'h', '5zh' },
      { 'l', '5zl', { desc = '←/→' } },
      { 'H', 'zH' },
      { 'L', 'zL', { desc = 'half screen ←/→' } },
   }
})
