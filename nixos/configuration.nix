{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  # Include the results of the hardware scan.
  imports =
    [
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Define hostname.
  networking.hostName = "nec-pc";
  # Enables wireless support via wpa_supplicant.
  # networking.wireless.enable = true;  

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "vi_VN";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ylong = {
    isNormalUser = true;
    description = "ylong";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
  };

  home-manager.users.ylong = {
    home.stateVersion = "23.11";

    programs.git = {
      enable = true;
      userName = "nghiango1";
      userEmail = "ducnghia.tin47@gmail.com";
    };

    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        vim-sleuth
        vim-fugitive
        vim-rhubarb

        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = ''
            local lspconfig = require('lspconfig')
            lspconfig.clangd.setup {}
            lspconfig.nixd.setup {}
            lspconfig.lua_ls.setup {
              on_init = function(client)
                local path = client.workspace_folders[1].name
                if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                  return
                end

                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                  runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT'
                  },
                  -- Make the server aware of Neovim runtime files
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      vim.env.VIMRUNTIME
                    }
                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                    -- library = vim.api.nvim_get_runtime_file("", true)
                  }
                })
              end,
              settings = {
                Lua = {
                  workspace = { checkThirdParty = false },
                  telemetry = { enable = false },
                },
              }
            }
            vim.diagnostic.config({
              virtual_text = true
            })

            vim.api.nvim_create_autocmd('LspAttach', {
              group = vim.api.nvim_create_augroup('UserLspConfig', {}),
              callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                vim.keymap.set('n', '<space>wl', function()
                  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<space>f', function()
                    vim.lsp.buf.format { async = true }
                end, opts)
              end,
            })
          '';
        }
        fidget-nvim

        {
          plugin = nvim-cmp;
          type = "lua";
          config = ''
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            require('luasnip.loaders.from_vscode').lazy_load()
            luasnip.config.setup {}

            cmp.setup {
              snippet = {
                expand = function(args)
                  luasnip.lsp_expand(args.body)
                end,
              },
              mapping = cmp.mapping.preset.insert {
                ["<c-a>"] = cmp.mapping.complete {
                  config = {
                    sources = {
                      { name = "cody" },
                    },
                  },
                },
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete {},
                -- ['<CR>'] = cmp.mapping.confirm {
                --   behavior = cmp.ConfirmBehavior.Replace,
                --   select = true,
                -- },
                ['<Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                  else
                    fallback()
                  end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
                end, { 'i', 's' }),
              },
              sources = {
                { name = 'cody' },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                {
                  name = 'look',
                  keyword_length = 2,
                  option = {
                    convert_case = true,
                    loud = true
                    --dict = '/usr/share/dict/words'
                  }
                },
              },
            }

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
          '';
        }

        luasnip
        cmp_luasnip
        cmp-nvim-lsp
        friendly-snippets

        {
          plugin = which-key-nvim;
          type = "lua";
          config = ''
            require('which-key').register {
              ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
              ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
              ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
              ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
              ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
              ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
              ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
            }
          '';
        }

        {
          plugin = rose-pine;
          type = "lua";
          config = ''
            require('rose-pine').setup({
                disable_background = true
            })

            function SetBgColor(color)
                color = color or "rose-pine"
                vim.cmd.colorscheme(color)

                vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
                vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none" })
            end

            SetBgColor()
          '';
        }

        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = ''
            require('gitsigns').setup{
              signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
              },
              on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

                -- don't override the built-in and fugitive keymaps
                local gs = package.loaded.gitsigns
                vim.keymap.set({ 'n', 'v' }, ']c', function()
                  if vim.wo.diff then
                    return ']c'
                  end
                  vim.schedule(function()
                    gs.next_hunk()
                  end)
                  return '<Ignore>'
                end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
                vim.keymap.set({ 'n', 'v' }, '[c', function()
                  if vim.wo.diff then
                    return '[c'
                  end
                  vim.schedule(function()
                    gs.prev_hunk()
                  end)
                  return '<Ignore>'
                end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
              end,
            }
          '';
        }

        {
          plugin = lualine-nvim;
          type = "lua";
          config = ''
            require('lualine').setup {
              options = {
                icons_enabled = false,
                theme = 'onedark',
                component_separators = '|',
                section_separators = ''',
              },
            }
          '';
        }

        telescope-nvim
        plenary-nvim
        {
          plugin = telescope-fzf-native-nvim;
          type = "lua";
          config = ''
            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            require('telescope').setup {
              defaults = {
                mappings = {
                  i = {
                    ['<C-u>'] = false,
                    ['<C-d>'] = false,
                  },
                },
              },
            }

            -- Enable telescope fzf native, if installed
            pcall(require('telescope').load_extension, 'fzf')

            -- See `:help telescope.builtin`
            vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
            vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<leader>/', function()
              -- You can pass additional configuration to telescope to change theme, layout, etc.
              require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
              })
            end, { desc = '[/] Fuzzily search in current buffer' })

            vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
            vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })


            -- Diagnostic keymaps
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
          '';
        }

        nvim-treesitter.withAllGrammars
        {
          plugin = nvim-treesitter;
          type = "lua";
          config = ''
            require'nvim-treesitter.configs'.setup {
              -- A list of parser names, or "all" (the five listed parsers should always be installed)
              ensure_installed = {},

              -- Install parsers synchronously (only applied to `ensure_installed`)
              sync_install = false,

              -- Automatically install missing parsers when entering buffer
              -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
              auto_install = false,

              -- List of parsers to ignore installing (for 'all')
              ignore_install = {'all'},

              -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
              -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
              -- Using this option may slow down your editor, and you may see some duplicate highlights.
              -- Instead of true it can also be a list of languages
              additional_vim_regex_highlighting = false,

              highlight = { enable = true },
              indent = { enable = true },
              incremental_selection = {
                enable = true,
                keymaps = {
                  init_selection = '<c-space>',
                  node_incremental = '<c-space>',
                  scope_incremental = '<c-s>',
                  node_decremental = '<M-space>',
                },
              },
              textobjects = {
                select = {
                  enable = true,
                  lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                  keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ['aa'] = '@parameter.outer',
                    ['ia'] = '@parameter.inner',
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner',
                  },
                },
                move = {
                  enable = true,
                  set_jumps = true, -- whether to set jumps in the jumplist
                  goto_next_start = {
                    [']m'] = '@function.outer',
                    [']]'] = '@class.outer',
                  },
                  goto_next_end = {
                    [']M'] = '@function.outer',
                    [']['] = '@class.outer',
                  },
                  goto_previous_start = {
                    ['[m'] = '@function.outer',
                    ['[['] = '@class.outer',
                  },
                  goto_previous_end = {
                    ['[M'] = '@function.outer',
                    ['[]'] = '@class.outer',
                  },
                },
                swap = {
                  enable = true,
                  swap_next = {
                    ['<leader>a'] = '@parameter.inner',
                  },
                  swap_previous = {
                    ['<leader>A'] = '@parameter.inner',
                  },
                },
              },
            }
          '';
        }

        nvim-jdtls
        nvim-dap-ui
        nvim-dap-go
        {
          plugin = nvim-dap;
          type = "lua";
          config = ''
            local dap = require 'dap'
            local dapui = require 'dapui'

            -- Basic debugging keymaps, feel free to change to your liking!
            vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
            vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
            vim.keymap.set('n', '<C-b>', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
            vim.keymap.set('n', '<leader>pd', require('dap.ext.vscode').load_launchjs)
            vim.keymap.set('n', '<Leader>dr', dap.continue, { desc = 'DAP [r]un' })
            vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end, { desc = 'DAP run [l]ast' })
            vim.keymap.set('n', '<F9>', dap.step_over)
            vim.keymap.set('n', '<F8>', dap.step_into)
            vim.keymap.set('n', '<leader>do', dap.repl.toggle, { desc = 'DAP Repl t[o]ggle' })

            vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
            vim.keymap.set('n', '<Leader>B', function() require('dap').toggle_breakpoint() end)
            vim.keymap.set('n', '<Leader>lp',
                function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
                { desc = 'DAP set [l]og [p]oint' })

            vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
                require('dap.ui.widgets').hover()
            end, { desc = 'DAP [h]over' })
            vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
                require('dap.ui.widgets').preview()
            end, { desc = 'DAP preview' })
            vim.keymap.set('n', '<Leader>df', function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.frames)
            end, { desc = 'DAP [f]rames' })
            vim.keymap.set('n', '<Leader>ds', function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.scopes)
            end, { desc = 'DAP [s]copes' })

            vim.keymap.set('n', 'S-<F5>', 'make<CR>')
            vim.keymap.set('n', '<Leader><F5>', require('dap.ext.vscode').load_launchjs)

            -- Dap UI setup
            -- For more information, see |:help nvim-dap-ui|
            dapui.setup {
              -- Set icons to characters that are more likely to work in every terminal.
              --    Feel free to remove or use ones that you like more! :)
              --    Don't feel like these are good choices.
              icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
              controls = {
                icons = {
                  pause = '⏸',
                  play = '▶',
                  step_into = '⏎',
                  step_over = '⏭',
                  step_out = '⏮',
                  step_back = 'b',
                  run_last = '▶▶',
                  terminate = '⏹',
                  disconnect = '⏏',
                },
              },
            }

            -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
            vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

            -- Install golang specific config
            require('dap-go').setup() 

            -- Python
            dap.adapters.python = function(cb, config)
                if config.request == 'attach' then
                    ---@diagnostic disable-next-line: undefined-field
                    local port = (config.connect or config).port
                    ---@diagnostic disable-next-line: undefined-field
                    local host = (config.connect or config).host or '127.0.0.1'
                    cb({
                        type = 'server',
                        port = assert(port, '`connect.port` is required for a python `attach` configuration'),
                        host = host,
                        options = {
                            source_filetype = 'python',
                        },
                    })
                else
                    cb({
                        type = 'executable',
                        command = 'debugpy-adapter',
                        options = {
                            source_filetype = 'python',
                        },
                    })
                end
            end

            dap.configurations.python = {
                {
                    -- The first three options are required by nvim-dap
                    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
                    request = 'launch',
                    name = 'Launch file',
                    console = 'integratedTerminal',

                    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
                    program = "''${file}", -- This configuration will launch the current file if used.
                    pythonPath = function()
                        -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                        -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                        -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                        local cwd = vim.fn.getcwd()
                        if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                            return cwd .. '/venv/bin/python'
                        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                            return cwd .. '/.venv/bin/python'
                        else
                            return '/usr/bin/python'
                        end
                    end,
                },

                {
                    -- The first three options are required by nvim-dap
                    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
                    request = 'launch',
                    name = 'Launch file with `--debug` args',
                    console = 'integratedTerminal',

                    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
                    program = "''${file}", -- This configuration will launch the current file if used.
                    pythonPath = function()
                        -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                        -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                        -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                        local cwd = vim.fn.getcwd()
                        if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                            return cwd .. '/venv/bin/python'
                        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                            return cwd .. '/.venv/bin/python'
                        else
                            return '/usr/bin/python'
                        end
                    end,
                    args = { '--debug' },
                },

                {
                    -- The first three options are required by nvim-dap
                    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
                    request = 'launch',
                    name = 'Launch file with args',
                    console = 'integratedTerminal',

                    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
                    program = "''${file}", -- This configuration will launch the current file if used.
                    pythonPath = function()
                        -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                        -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                        -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                        local cwd = vim.fn.getcwd()
                        if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                            return cwd .. '/venv/bin/python'
                        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                            return cwd .. '/.venv/bin/python'
                        else
                            return '/usr/bin/python'
                        end
                    end,
                    args = function()
                        local args = {}
                        local i = 1
                        while true do
                            local arg = vim.fn.input('Argument [' .. i .. ']: ')
                            if arg == ''' then
                                break
                            end
                            args[i] = arg
                            i = i + 1
                        end
                        return args
                    end,
                },
            }

            -- CCP/C/Rust with gdb
            dap.adapters.cppdbg = {
              id = 'cppdbg',
              type = 'executable',
              command = '${pkgs.vscode-extensions.ms-vscode.cpptools}/share/vscode/extensions/ms-vscode.cpptools/debugAdapters/bin/OpenDebugAD7',
            }

            
            dap.adapters.c = dap.adapters.cppdbg
            dap.adapters.cpp = dap.adapters.cppdbg
            dap.adapters.rust = dap.adapters.cppdbg

            dap.configurations.rust = {
                {
                    name = "Rust cargo default",
                    type = "rust",
                    request = "launch",
                    program = "''${workspaceFolder}/target/debug/''${workspaceFolderBasename}",
                    cwd = "''${workspaceFolder}",
                    stopOnEntry = false,
                },
                {
                    name = "Rust standalone",
                    type = "rust",
                    request = "launch",
                    program = "''${fileBasenameNoExtension}",
                    cwd = "''${workspaceFolder}",
                    stopOnEntry = false,
                },
            }

            dap.configurations.c = {
                {
                    name = "Launch DAP default",
                    type = "c",
                    request = "launch",
                    program = "''${workspaceFolder}/dist/''${fileBasenameNoExtension}",
                    cwd = "''${workspaceFolder}",
                    stopOnEntry = false,
                },
            }

            dap.configurations.cpp = {
                {
                    name = "Launch DAP default",
                    type = "cpp",
                    request = "launch",
                    program = "''${workspaceFolder}/dist/''${fileBasenameNoExtension}",
                    cwd = "''${workspaceFolder}",
                    stopOnEntry = false,
                },
            }
          '';
        }

        {
          plugin = nvim-autopairs;
          type = "lua";
          config = ''
            require("nvim-autopairs").setup {}
            -- If you want to automatically add `(` after selecting a function or method
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
              'confirm_done',
              cmp_autopairs.on_confirm_done()
            )
          '';
        }

        cmp-look
      ];

      extraLuaConfig = ''
        vim.g.mapleader = ' '
        vim.g.maplocalleader = ' '
        
        vim.opt.nu = true
        vim.opt.relativenumber = true
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.expandtab = true
        vim.opt.smartindent = true
        vim.opt.wrap = false
        vim.opt.swapfile = false
        vim.opt.backup = false
        vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
        vim.opt.undofile = true
        vim.opt.hlsearch = false
        vim.opt.incsearch = true
        vim.opt.termguicolors = true
        vim.opt.scrolloff = 3
        vim.opt.signcolumn = "yes"
        vim.opt.isfname:append("@-@")
        vim.opt.updatetime = 50
        vim.opt.colorcolumn = "80"
        vim.cmd [[set listchars=tab:\ >\ ]]
        vim.o.completeopt = 'menuone,noselect'
        vim.o.termguicolors = true

        vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
        vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
        vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
        -- Maybe i'm wrong, this work like >> but in insert mode
        vim.keymap.set("i", "<C-t>", "")

        -- Why Undo is ctrl r again
        vim.keymap.set("n", "U", "<C-r>")

        -- Quick go to next word in insert mode with Ctrl h and Ctrl l
        -- Trying to replace Ctrl left and Ctrl right here
        function _G.t(str)
          return vim.api.nvim_replace_termcodes(str, true, true, true)
        end

        vim.keymap.set("i", _G.t "<C-h>", "<C-Left>")
        vim.keymap.set("i", _G.t "<C-l>", "<C-\\><C-N>ea")

        vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

        -- Move all selected line Up/Down with JK
        vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
        vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

        -- Mark to keep the cursor at place when [J]oin line
        vim.keymap.set("n", "J", "mzJ`z")

        -- Keep thing in the middle when jump
        vim.keymap.set("n", "<C-d>", "<C-d>zz")
        vim.keymap.set("n", "<C-u>", "<C-u>zz")
        vim.keymap.set("n", "n", "nzzzv")
        vim.keymap.set("n", "N", "Nzzzv")

        -- Normally I work with <leader>cn and <leader>cN
        vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
        vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

        -- Visual mode paste without changing register " value
        vim.keymap.set("x", "<leader>p", [["_dP]])

        -- Copy to register + (system cliboard)
        vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
        vim.keymap.set("n", "<leader>Y", [["+Y]])

        -- Delete to register + (? Why we need this again)
        vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

        -- For fun, Ctrl c to Esc, almost no diferent and I only use Esc
        vim.keymap.set("i", "<C-c>", "<Esc>")

        -- Format
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

        -- Replace in current file, with regex
        vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

        -- For bash like file, normally i will go for normal console command instead
        vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

        -- Quick jump to config file
        vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/init.lua<CR>");
        vim.keymap.set("n", "<leader>vpo", "<cmd>e ~/.config/nvim/lua/ylsama/telex.lua<CR>");
      '';
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    python311Packages.debugpy
    nixpkgs-fmt
    nixd
    lua-language-server
    jdt-language-server
    clang-tools
    gdb
    vscode-extensions.ms-vscode.cpptools
    bear
    gnumake
    xclip
    lua
    unzip
    go
    gotools
    gcc
    nodejs
    python3
    wget
    keepassxc
    rclone
    fzf

    gnomeExtensions.dash-to-dock
    gnomeExtensions.topicons-plus
    gnomeExtensions.appindicator
  ];

  services.gnome.gnome-browser-connector.enable = true;
  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org/gnome/shell]
    app-picker-view=uint32 1
    enabled-extensions=['dash-to-dock@micxgx.gmail.com', 'TopIcons@phocean.net', ]
    had-bluetooth-devices-setup=true
    favorite-apps=['org.gnome.Terminal.desktop', 'firefox.desktop', 'org.gnome.Nautilus.desktop']

    [org/gnome/shell/extensions/dash-to-dock]
    preferred-monitor=0
    multi-monitor=false
    height-fraction=0.90000000000000002
    dash-max-icon-size=64
    icon-size-fixed=true
  '';

  i18n.inputMethod = {
    enabled = "ibus";
    ibus = {
      engines = with pkgs.ibus-engines; [ hangul bamboo ];
    };
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Ubuntu" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Ubuntu" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "Ubuntu" ];
      };
    };
  };

  environment.variables = rec {
    VISUAL = "nvim";
  };

  environment.sessionVariables = rec {
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

  environment.shellAliases = {
    sudovi = "sudo -E -s nvim";
    # Hack for sudo alias to work, check https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
    sudo = "sudo ";
    # Alias for linked library wraper shell
    nix-ln-shell = "nix-shell ~/workspace/dotfile/nixos/glibcLinked.nix --command";
  };

  # This help dynamic linked executable, which pair with `nix-ln-shell` alias
  # eg: Mason prebuild LSP server
  programs.nix-ld.enable = true;
  # It already come with default library, so these just not needed, unless we need more
  # programs.nix-ld.libraries = with pkgs; [ alsa-lib at-spi2-atk at-spi2-core atk cairo cups curl dbus expat fontconfig freetype fuse3 gdk-pixbuf glib gtk3 icu libGL libappindicator-gtk3 libdrm libglvnd libnotify libpulseaudio libunwind libusb1 libuuid libxkbcommon libxml2 mesa nspr nss openssl pango pipewire stdenv.cc.cc systemd vulkan-loader xorg.libX11 xorg.libXScrnSaver xorg.libXcomposite xorg.libXcursor xorg.libXdamage xorg.libXext xorg.libXfixes xorg.libXi xorg.libXrandr xorg.libXrender xorg.libXtst xorg.libxcb xorg.libxkbfile xorg.libxshmfence zlib ];

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    baseIndex = 1;
    historyLimit = 10000;
    escapeTime = 0;
    clock24 = true;
    customPaneNavigationAndResize = true;
    extraConfig = ''
      # First remove *all* keybindings
      unbind C-b
      set-option -g prefix M-a
      bind-key M-a send-prefix
      set -g status-style 'bg=#333334 fg=#5eacd3'

      # Vim like
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      # Fzf any session
      bind-key -r f run-shell "tmux neww tmuxhelper.sh"

      # Copy mode
      bind-key [ copy-mode

      # Paste buffer
      bind-key ] paste-buffer

      # Clock
      setw -g clock-mode-style 24
      setw -g monitor-activity on
    
      # Mouse on/off
      set -g mouse off

      # Automatically set window title
      set-window-option -g automatic-rename on
      set-option -g set-titles on

      # Choose Window
      bind-key w choose-window

      # New Window with number
      bind-key 1 new-window -t 1
      bind-key 2 new-window -t 2
      bind-key 3 new-window -t 3
      bind-key 4 new-window -t 4
      bind-key 5 new-window -t 5
      bind-key 6 new-window -t 6
      bind-key 7 new-window -t 7
      bind-key 8 new-window -t 8
      bind-key 9 new-window -t 9
      bind-key 0 new-window -t 10

      # Switch windows alt+number
      bind-key -n M-1 select-window -t 1
      bind-key -n M-2 select-window -t 2
      bind-key -n M-3 select-window -t 3
      bind-key -n M-4 select-window -t 4
      bind-key -n M-5 select-window -t 5
      bind-key -n M-6 select-window -t 6
      bind-key -n M-7 select-window -t 7
      bind-key -n M-8 select-window -t 8
      bind-key -n M-9 select-window -t 9
      bind-key -n M-0 select-window -t 10

      # Change current pane to next window
      bind-key ! join-pane -t :1
      bind-key @ join-pane -t :2
      bind-key '#' join-pane -t :3
      bind-key '$' join-pane -t :4
      bind-key '%' join-pane -t :5
      bind-key '^' join-pane -t :6
      bind-key '&' join-pane -t :7
      bind-key '*' join-pane -t :8
      bind-key '(' join-pane -t :9
      bind-key ')' join-pane -t :10

      # Kill Selected Pane
      bind-key Q kill-pane
    '';
  };

  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      user.name = "nghiango1";
      user.email = "ducnghia.tin47@gmaill.com";
    };
  };

  programs.fuse.userAllowOther = true;

  # Neovim setup
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Unsure about should I use oracle-java
  programs.java = {
    enable = true;
    package = pkgs.openjdk17;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  systemd.user.services.ggdrive = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    description = "rclone: Remote FUSE filesystem for cloud storage config %i";
    serviceConfig = {
      Type = "notify";
      ExecStart = ''${pkgs.rclone}/bin/rclone mount --config=%h/.config/rclone/rclone.conf --cache-dir=%h/mnt/cache-ggdrive --log-file=/tmp/rclone-ggdrive.log --poll-interval 15s --allow-other --dir-cache-time 1000h --log-level INFO --vfs-cache-mode full --vfs-cache-max-size 100G --vfs-cache-max-age 120h --bwlimit-file 16M ggdrive: %h/mnt/ggdrive'';
      ExecStop = ''/run/wrappers/bin/fusermount -u %h/mnt/ggdrive'';
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
