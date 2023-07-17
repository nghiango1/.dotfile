require("dap-vscode-js").setup {
    node_path = "node", -- Path of node executable. vscode-js-debug require node verson 16
    adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
}

local dap = require('dap')
local js_languages = { "typescript", "javascript", "typescriptreact" }
for _, language in ipairs(js_languages) do
    dap.configurations[language] = {
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach launch --inspect node",
            console = "integratedTerminal",
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            console = "integratedTerminal",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch Test Program (pwa-node with vitest)",
            cwd = "${workspaceFolder}",
            program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
            args = { "--threads", "false", },
            autoAttachChildProcesses = false,
            trace = true,
            console = "integratedTerminal",
            sourceMaps = true,
            smartStep = true,
        },
    }
end
