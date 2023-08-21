local dap = require('dap')

dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        command = '/home/termux/.local/share/nvim/mason/bin/codelldb',
        args = { "--port", "${port}" },
    }
}

dap.adapters.c = dap.adapters.codelldb
dap.adapters.cpp = dap.adapters.codelldb
dap.adapters.rust = dap.adapters.codelldb

dap.configurations.rust = {
    {
        name = "Rust cargo default",
        type = "rust",
        request = "launch",
        program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
    {
        name = "Rust standalone",
        type = "rust",
        request = "launch",
        program = '${fileBasenameNoExtension}',
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}

dap.configurations.c = {
    {
        name = "c hello default",
        type = "c",
        request = "launch",
        program = "${workspaceFolder}/myprogram",
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
--    {
--        name = "Launch DAP defaul",
--        type = "c",
--        request = "launch",
--        program = function()
--            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--        end,
--        cwd = '${workspaceFolder}',
--        stopOnEntry = false,
--    },
}

dap.configurations.cpp = dap.configurations.rust
