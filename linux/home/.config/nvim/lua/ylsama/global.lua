--- @type string
local home = os.getenv("HOME")
local path_sep = "/"
local M = {
    border_style = "rounded",
    vim_path = vim.fn.stdpath("config"),
    home = home,
    path_sep = "/",
    dap_path = home .. "/.vscode/extensions",
    data_path = string.format(
        "%s" .. path_sep .. "site" .. path_sep,
        vim.fn.stdpath("data")
    ),
}

return M
