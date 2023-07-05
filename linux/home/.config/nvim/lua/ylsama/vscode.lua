local list_extension = {
    "tomblind.local-lua-debugger-vscode",
    "ms-python.python",
    "ms-vscode.js-debug-nightly",
}

local update_all_command = [[!for ext in `code --list-extensions`; do code --install-extension "$ext" --force; done]]

local install_extension = function(opts)
    local command = '!code --install-extension ' .. opts.fargs[1]
    vim.cmd(command)
end

local install_extension_force = function(opts)
    local command = '!code --install-extension ' .. opts.fargs[1] .. ' --force'
    vim.cmd(command)
end

local uninstall_extension = function(opts)
    local command = '!code --uninstall-extension ' .. opts.fargs[1] .. ' --force'
    vim.cmd(command)
end

local update_extensions = function()
    vim.cmd(update_all_command)
end

local sync_extensions = function()
    for key, ext in pairs(list_extension) do
        print(ext)
        install_extension_force({ fargs = { ext } })
    end
end

vim.api.nvim_create_user_command('VscodeListExtension', '!code --list-extensions --show-versions', {})
vim.api.nvim_create_user_command('VscodeInstallExtension', install_extension, { nargs = 1 })
vim.api.nvim_create_user_command('VscodeInstallExtensionForce', install_extension_force, { nargs = 1 })
vim.api.nvim_create_user_command('VscodeUpdate', update_extensions, {})
vim.api.nvim_create_user_command('VscodeUninstallExtension', uninstall_extension, { nargs = 1 })
vim.api.nvim_create_user_command('VscodeSync', sync_extensions, {})
