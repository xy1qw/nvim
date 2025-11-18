---@diagnostic disable: undefined-global

return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'saghen/blink.cmp',
        },
        config = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            local on_attach = function(client, bufnr)
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs,
                        { buffer = bufnr, noremap = true, silent = true, desc = desc })
                end

                map("n", "K", vim.lsp.buf.hover, "Hover document")
                map("n", "<leader>lh", vim.lsp.buf.signature_help, "Signature help")
                map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

                map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
                map("n", "gri", vim.lsp.buf.implementation, "Go to implementation")
                map("n", "grr", vim.lsp.buf.references, "Show references")
                map("n", "<leader>lR", vim.lsp.buf.references, "Show references")

                map("n", "gra", vim.lsp.buf.code_action, "Code actions")
                map("n", "<leader>la", vim.lsp.buf.code_action, "Code actions")
                map("v", "<leader>la", vim.lsp.buf.code_action, "Code actions")

                map("n", "grn", vim.lsp.buf.rename, "Rename")
                map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")

                map("n", "gl", vim.diagnostic.open_float, "Line diagnostics")
                map("n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
                map("n", "<leader>lD", vim.diagnostic.setloclist, "All diagnostics")

                map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
                map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")

                map("n", "<leader>li", "<cmd>LspInfo<cr>", "LSP Info")

                map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
                map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
                map("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, "List workspace folders")

                if client.server_capabilities.documentHighlightProvider then
                    local group = vim.api.nvim_create_augroup('lsp_document_highlight',
                        { clear = false })
                    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        group = group,
                        buffer = bufnr,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd('CursorMoved', {
                        group = group,
                        buffer = bufnr,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end

            vim.diagnostic.config({
                virtual_text = {
                    prefix = '●',
                    source = 'if_many',
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = 'rounded',
                    source = 'always',
                    header = '',
                    prefix = '',
                },
            })

            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            vim.lsp.config('ts_ls', {
                capabilities = capabilities,
                on_attach = on_attach,
            })

            vim.lsp.config('pyright', {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                        }
                    }
                }
            })

            vim.lsp.config('rust_analyzer', {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ['rust-analyzer'] = {
                        checkOnSave = {
                            command = "clippy"
                        },
                        cargo = {
                            allFeatures = true,
                        }
                    }
                }
            })

            vim.lsp.config('gopls', {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                    }
                }
            })

            vim.lsp.config('lua_ls', {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    }
                }
            })

            vim.lsp.config('clangd', {
                capabilities = capabilities,
                on_attach = on_attach,
            })

            vim.lsp.config('jsonls', {
                capabilities = capabilities,
                on_attach = on_attach,
            })

            vim.lsp.config('html', {
                capabilities = capabilities,
                on_attach = on_attach,
            })

            vim.lsp.config('cssls', {
                capabilities = capabilities,
                on_attach = on_attach,
            })

            vim.lsp.config('yamlls', {
                capabilities = capabilities,
                on_attach = on_attach,
            })

            vim.lsp.config("yql", {
                cmd_cwd = vim.fn.expand("~/arcadia/data-ui/yql-vscode/bin/"),
                cmd = {
                    "yql-lsp",
                    "--enableAutocomplete2",
                    "true",
                    "--requestTimeoutMs",
                    "30000",
                    "--token",
                    "$YQL_TOKEN",
                },
                filetypes = { "yql" },
                name = "YQL lsp",
            })

            vim.lsp.enable("yql")
        end,
    },


    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup({
                ui = {
                    border = 'rounded',
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end,
    },

    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'rust_analyzer',
                    'ts_ls',
                    'pyright',
                    'gopls',
                    'clangd',
                    'jsonls',
                    'yamlls',
                    'html',
                    'cssls',
                },
                automatic_installation = true,
            })
        end,
    },
    --    {
    --     'windwp/nvim-autopairs',
    --     event = 'InsertEnter',
    --     dependencies = { 'saghen/blink.cmp' },
    --     config = function()
    --         local npairs = require('nvim-autopairs')
    --         npairs.setup({
    --             check_ts = true,
    --             ts_config = {
    --                 lua = { 'string' },
    --                 javascript = { 'template_string' },
    --             },
    --         })

    -- local blink = require('blink.cmp')
    -- blink.setup({
    --     keymap = {
    --         ['<CR>'] = {
    --             function(fallback)
    --                 if blink.accept() then
    --                     npairs.autopairs_cr()
    --                 else
    --                     fallback()
    --                 end
    --             end,
    --         },
    --     },
    -- })
    --     end,
    -- },
    {
        'saghen/blink.cmp',
        version = '*',
        dependencies = {
            'rafamadriz/friendly-snippets',
            'xzbdmw/colorful-menu.nvim',
            'L3MON4D3/LuaSnip',
            -- { 'windwp/nvim-autopairs', event = 'InsertEnter' }
        },
        config = function()
            local blink = require('blink.cmp')
            local colorful = require('colorful-menu')
            -- local npairs = require('nvim-autopairs')

            -- npairs.setup()
            colorful.setup()

            blink.setup({
                appearance = {
                    use_nvim_cmp_as_default = false,
                    nerd_font_variant = "mono",
                },

                completion = {
                    accept = { auto_brackets = { enabled = true } },

                    ghost_text = { enabled = true },

                    documentation = {
                        auto_show = true,
                        auto_show_delay_ms = 250,
                        treesitter_highlighting = true,
                        window = { border = 'rounded' },
                    },
                    menu = {
                        border = 'rounded',
                        draw = {
                            columns = { { "kind_icon" }, { "label", gap = 1 } },
                            components = {
                                label = {
                                    text = function(ctx)
                                        return require("colorful-menu")
                                            .blink_components_text(ctx)
                                    end,
                                    highlight = function(ctx)
                                        return require("colorful-menu")
                                            .blink_components_highlight(ctx)
                                    end,
                                },
                            },
                        },
                    },
                },
                signature = {
                    enabled = true,
                    window = { border = "rounded" },
                },
                sources = {
                    default = { 'lsp', 'path', 'snippets', 'buffer' },
                },
                -- snippet = {
                --	expand = function(args)
                --		require('luasnip').lsp_expand(args.body)
                --	end,
                --},
                keymap = {
                    ['<C-Space>'] = { 'show' },
                    ['<C-e>'] = { 'hide' },
                    ['<CR>'] = { 'accept', 'fallback' },
                    ['<Tab>'] = { 'select_next', 'fallback' },
                    ['<S-Tab>'] = { 'select_prev', 'fallback' },
                },
            })
        end,
    },

    -- {
    --     'hrsh7th/nvim-cmp',
    --     dependencies = {
    --         'hrsh7th/cmp-nvim-lsp',
    --         'hrsh7th/cmp-buffer',
    --         'hrsh7th/cmp-path',
    --         'L3MON4D3/LuaSnip',
    --         'saadparwaiz1/cmp_luasnip',
    --         'rafamadriz/friendly-snippets',
    --         "xzbdmw/colorful-menu.nvim"
    --     },
    --     config = function()
    --         local cmp = require('cmp')
    --         local luasnip = require('luasnip')

    --         require('luasnip.loaders.from_vscode').lazy_load()

    --         cmp.setup({
    --             snippet = {
    --                 expand = function(args)
    --                     luasnip.lsp_expand(args.body)
    --                 end,
    --             },
    --             mapping = cmp.mapping.preset.insert({
    --                 ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    --                 ['<C-f>'] = cmp.mapping.scroll_docs(4),
    --                 ['<C-Space>'] = cmp.mapping.complete(),
    --                 ['<C-e>'] = cmp.mapping.abort(),
    --                 ['<CR>'] = cmp.mapping.confirm({ select = true }),
    --                 ['<Tab>'] = cmp.mapping(function(fallback)
    --                     if cmp.visible() then
    --                         cmp.select_next_item()
    --                     elseif luasnip.expand_or_jumpable() then
    --                         luasnip.expand_or_jump()
    --                     else
    --                         fallback()
    --                     end
    --                 end, { 'i', 's' }),
    --                 ['<S-Tab>'] = cmp.mapping(function(fallback)
    --                     if cmp.visible() then
    --                         cmp.select_prev_item()
    --                     elseif luasnip.jumpable(-1) then
    --                         luasnip.jump(-1)
    --                     else
    --                         fallback()
    --                     end
    --                 end, { 'i', 's' }),
    --             }),
    --             sources = cmp.config.sources({
    --                 { name = 'nvim_lsp' },
    --                 { name = 'luasnip' },
    --                 { name = 'path' },
    --             }, {
    --                 { name = 'buffer' },
    --             }),
    --             formatting = {
    --                 format = function(entry, vim_item)
    --                     local highlights_info = require("colorful-menu").cmp_highlights(entry)
    --                     if highlights_info ~= nil then
    --                         vim_item.abbr_hl_group = highlights_info.highlights
    --                         vim_item.abbr = highlights_info.text
    --                     end

    --                     return vim_item
    --                 end,
    --             },
    --             window = {
    --                 completion = cmp.config.window.bordered(),
    --                 documentation = cmp.config.window.bordered(),
    --             },
    --         })
    --     end,
    -- },


    {
        'stevearc/conform.nvim',
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                '<leader>lf',
                function()
                    require('conform').format({ async = true, lsp_fallback = true })
                end,
                mode = '',
                desc = 'Format buffer',
            },
        },
        config = function()
            require('conform').setup({
                formatters_by_ft = {
                    lua = { 'stylua' },
                    python = { 'black' },
                    javascript = { 'prettier' },
                    typescript = { 'prettier' },
                    javascriptreact = { 'prettier' },
                    typescriptreact = { 'prettier' },
                    css = { 'prettier' },
                    html = { 'prettier' },
                    json = { 'prettier' },
                    yaml = { 'prettier' },
                    markdown = { 'prettier' },
                    rust = { 'rustfmt' },
                    go = { 'gofmt' },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
            })
        end,
    },

    {
        'mfussenegger/nvim-lint',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require('lint')

            lint.linters_by_ft = {
                javascript = { 'eslint' },
                typescript = { 'eslint' },
                javascriptreact = { 'eslint' },
                typescriptreact = { 'eslint' },
                python = { 'flake8' },
            }

            local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
            vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
                group = lint_augroup,
                callback = function()
                    pcall(function()
                        lint.try_lint()
                    end)
                end,
            })
        end,
    },

    {
        'folke/trouble.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        cmd = "Trouble",
        keys = {
            {
                '<leader>xx',
                '<cmd>Trouble diagnostics toggle<cr>',
                desc = 'Diagnostics (Trouble)',
            },
            {
                '<leader>xX',
                '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
                desc = 'Buffer Diagnostics (Trouble)',
            },
            {
                '<leader>cs',
                '<cmd>Trouble symbols toggle focus=false<cr>',
                desc = 'Symbols (Trouble)',
            },
            {
                '<leader>cl',
                '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
                desc = 'LSP Definitions / references / ... (Trouble)',
            },
            {
                '<leader>xL',
                '<cmd>Trouble loclist toggle<cr>',
                desc = 'Location List (Trouble)',
            },
            {
                '<leader>xQ',
                '<cmd>Trouble qflist toggle<cr>',
                desc = 'Quickfix List (Trouble)',
            },
        },
        opts = {},
    },

    {
        'RRethy/vim-illuminate',
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('illuminate').configure({
                delay = 200,
                large_file_cutoff = 2000,
                large_file_overrides = {
                    providers = { 'lsp' },
                },
            })
        end,
    },

    {
        'onsails/lspkind.nvim',
        config = function()
            require('lspkind').init({
                mode = 'symbol_text',
                preset = 'codicons',
            })
        end,
    },

    {
        'ray-x/lsp_signature.nvim',
        event = "VeryLazy",
        config = function()
            require('lsp_signature').setup({
                bind = true,
                handler_opts = {
                    border = "rounded"
                },
                floating_window = true,
                hint_enable = false,
            })
        end,
    },


    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'lua',
                    'vim',
                    'vimdoc',
                    'query',
                    'javascript',
                    'typescript',
                    'tsx',
                    'python',
                    'rust',
                    'go',
                    'c',
                    'cpp',
                    'json',
                    'yaml',
                    'html',
                    'css',
                    'markdown',
                    'markdown_inline',
                    'bash',
                    'toml',
                    'regex',
                },

                auto_install = true,

                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },

                indent = {
                    enable = true,
                },

                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<CR>',
                        node_incremental = '<CR>',
                        scope_incremental = '<S-CR>',
                        node_decremental = '<BS>',
                    },
                },

                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['ai'] = '@conditional.outer',
                            ['ii'] = '@conditional.inner',
                            ['al'] = '@loop.outer',
                            ['il'] = '@loop.inner',
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
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
            })

            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
            vim.opt.foldenable = false
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('treesitter-context').setup({
                enable = true,
                max_lines = 3,
                min_window_height = 20,
                trim_scope = 'outer',
                mode = 'cursor',
            })


            vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#2d3139' })
            vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { bg = '#2d3139' })

            vim.keymap.set('n', '<leader>tc', ':TSContextToggle<CR>', { desc = 'Toggle Treesitter context' })
        end,
    },

    {
        'windwp/nvim-ts-autotag',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('nvim-ts-autotag').setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = false,
                },
            })
        end,
    },

    {
        'HiPhish/rainbow-delimiters.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            local rainbow = require('rainbow-delimiters')

            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = rainbow.strategy['global'],
                    vim = rainbow.strategy['local'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    lua = 'rainbow-blocks',
                },
                highlight = {
                    'RainbowDelimiterRed',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                },
            }
        end,
    },

    {
        'numToStr/Comment.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('Comment').setup({
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            })
        end,
    },

    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
    -- {
    --     "rachartier/tiny-inline-diagnostic.nvim",
    --     event = "VeryLazy",
    --     priority = 1000,
    --     config = function()
    --         require("tiny-inline-diagnostic").setup()
    --         vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
    --     end,
    -- },
    {
        "xzbdmw/colorful-menu.nvim"
    },
    {
        'saghen/blink.pairs',
        version = '*',
        dependencies = 'saghen/blink.download',
        opts = {
            mappings = {
                enabled = true,
                cmdline = true,
                disabled_filetypes = {},
                pairs = {},
            },
            highlights = {
                enabled = true,
                cmdline = true,
                groups = {
                    'BlinkPairsOrange',
                    'BlinkPairsPurple',
                    'BlinkPairsBlue',
                },
                unmatched_group = 'BlinkPairsUnmatched',

                matchparen = {
                    enabled = true,
                    cmdline = false,
                    include_surrounding = false,
                    group = 'BlinkPairsMatchParen',
                    priority = 250,
                },
            },
            debug = false,
        }
    },
}
