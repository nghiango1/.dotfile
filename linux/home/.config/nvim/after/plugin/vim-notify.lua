require("notify").setup({
  background_colour = "#000000",
  render = 'minimal',
})
vim.keymap.set("n", "<leader>vn", "<Cmd>Notifications<CR>")
