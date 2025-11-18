---@diagnostic disable: undefined-global

return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'A7Lavinraj/fyler.nvim',
            'lukahartwig/pnpm.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
            },
        },
        cmd = 'Telescope',
        keys = {
            { '<leader>f<CR>', '<cmd>Telescope resume<cr>',                                desc = 'Resume previous search' },
            { '<leader>f"',    '<cmd>Telescope registers<cr>',                             desc = 'Registers' },
            { '<leader>f\'',   '<cmd>Telescope marks<cr>',                                 desc = 'Marks' },
            { '<leader>fb',    '<cmd>Telescope buffers<cr>',                               desc = 'Buffers' },
            { '<leader>fc',    '<cmd>Telescope grep_string<cr>',                           desc = 'Word at cursor' },
            { '<leader>fC',    '<cmd>Telescope commands<cr>',                              desc = 'Commands' },
            { '<leader>ff',    '<cmd>Telescope find_files<cr>',                            desc = 'Find files' },
            { '<leader>fF',    '<cmd>Telescope find_files hidden=true no_ignore=true<cr>', desc = 'Find files (hidden)' },
            { '<leader>fh',    '<cmd>Telescope help_tags<cr>',                             desc = 'Help tags' },
            { '<leader>fk',    '<cmd>Telescope keymaps<cr>',                               desc = 'Keymaps' },
            { '<leader>fm',    '<cmd>Telescope man_pages<cr>',                             desc = 'Man pages' },
            { '<leader>fn',    '<cmd>Telescope notify<cr>',                                desc = 'Notifications' },
            { '<leader>fo',    '<cmd>Telescope oldfiles<cr>',                              desc = 'Old files' },
            { '<leader>fr',    '<cmd>Telescope registers<cr>',                             desc = 'Registers' },
            { '<leader>ft',    '<cmd>Telescope colorscheme<cr>',                           desc = 'Colorschemes' },
            { '<leader>fw',    '<cmd>Telescope live_grep<cr>',                             desc = 'Live grep' },
            { '<leader>fW',    '<cmd>Telescope live_grep hidden=true no_ignore=true<cr>',  desc = 'Live grep (hidden)' },

            { '<leader>gb',    '<cmd>Telescope git_branches<cr>',                          desc = 'Git branches' },
            { '<leader>gc',    '<cmd>Telescope git_commits<cr>',                           desc = 'Git commits' },
            { '<leader>gC',    '<cmd>Telescope git_bcommits<cr>',                          desc = 'Git commits (current file)' },
            { '<leader>gt',    '<cmd>Telescope git_status<cr>',                            desc = 'Git status' },

            { '<leader>ls',    '<cmd>Telescope lsp_document_symbols<cr>',                  desc = 'Document symbols' },
            { '<leader>lG',    '<cmd>Telescope lsp_workspace_symbols<cr>',                 desc = 'Workspace symbols' },
        },
        config = function()
            local telescope = require('telescope')
            local actions = require('telescope.actions')
            telescope.load_extension('pnpm')

            vim.keymap.set('n', '<leader>fw', telescope.extensions.pnpm.workspace, {})

            telescope.setup({
                defaults = {
                    prompt_prefix = '   ',
                    selection_caret = '  ',
                    entry_prefix = '  ',
                    sorting_strategy = 'ascending',
                    layout_strategy = 'horizontal',
                    layout_config = {
                        horizontal = {
                            prompt_position = 'top',
                            preview_width = 0.55,
                            results_width = 0.8,
                        },
                        vertical = {
                            mirror = false,
                        },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 120,
                    },
                    path_display = { 'truncate' },
                    winblend = 0,
                    border = {},
                    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
                    color_devicons = true,
                    set_env = { ['COLORTERM'] = 'truecolor' },
                    file_ignore_patterns = {
                        'node_modules',
                        '.git/',
                        'dist/',
                        'build/',
                        'target/',
                        '%.lock',
                    },
                    mappings = {
                        i = {
                            ['<C-n>'] = actions.cycle_history_next,
                            ['<C-p>'] = actions.cycle_history_prev,
                            ['<C-j>'] = actions.move_selection_next,
                            ['<C-k>'] = actions.move_selection_previous,
                            ['<C-c>'] = actions.close,
                            ['<Down>'] = actions.move_selection_next,
                            ['<Up>'] = actions.move_selection_previous,
                            ['<CR>'] = actions.select_default,
                            ['<C-x>'] = actions.select_horizontal,
                            ['<C-v>'] = actions.select_vertical,
                            ['<C-t>'] = actions.select_tab,
                            ['<C-u>'] = actions.preview_scrolling_up,
                            ['<C-d>'] = actions.preview_scrolling_down,
                            ['<PageUp>'] = actions.results_scrolling_up,
                            ['<PageDown>'] = actions.results_scrolling_down,
                            ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
                            ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
                            ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
                            ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
                            ['<C-l>'] = actions.complete_tag,
                            ['<C-_>'] = actions.which_key,
                        },
                        n = {
                            ['<esc>'] = actions.close,
                            ['<CR>'] = actions.select_default,
                            ['<C-x>'] = actions.select_horizontal,
                            ['<C-v>'] = actions.select_vertical,
                            ['<C-t>'] = actions.select_tab,
                            ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
                            ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
                            ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
                            ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
                            ['j'] = actions.move_selection_next,
                            ['k'] = actions.move_selection_previous,
                            ['H'] = actions.move_to_top,
                            ['M'] = actions.move_to_middle,
                            ['L'] = actions.move_to_bottom,
                            ['<Down>'] = actions.move_selection_next,
                            ['<Up>'] = actions.move_selection_previous,
                            ['gg'] = actions.move_to_top,
                            ['G'] = actions.move_to_bottom,
                            ['<C-u>'] = actions.preview_scrolling_up,
                            ['<C-d>'] = actions.preview_scrolling_down,
                            ['<PageUp>'] = actions.results_scrolling_up,
                            ['<PageDown>'] = actions.results_scrolling_down,
                            ['?'] = actions.which_key,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = 'smart_case',
                    },
                },
            })

            telescope.load_extension('fzf')
        end,
    },
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        opts = {
            preset = "modern",
            icons = {
                breadcrumb = "»",
                separator = "➜",
                group = "+",
            }
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            require("telescope").load_extension("ui-select")
        end
    },
    {
        "A7Lavinraj/fyler.nvim",
        dependencies = {
            "echasnovski/mini.icons",
        },
        keys = {
            {
                '<leader>e',
                function()
                    require("fyler").toggle { kind = "float" }
                end,
                desc = 'Toggle Fyler'
            },
        },

        opts = {
            views = {
                finder = {
                    indentscope = {
                        marker = "┊",
                    },
                    win = {
                        border = "rounded",
                        kind = "replace",
                    }
                }
            }
        },
    },
    {
        config = function()
            local telescope = require("telescope")
            telescope.load_extension('arc')

            local arc = telescope.extensions.arc

            vim.keymap.set('n', '<leader>ag', arc.status, { desc = 'Telescope arc status' })
            vim.keymap.set('n', '<leader>af', arc.ls_files, { desc = 'Telescope arc ls_files' })
            vim.keymap.set('n', '<leader>ac', arc.commits, { desc = 'Telescope arc commits' })
            vim.keymap.set('n', '<leader>ab', arc.branches, { desc = 'Telescope arc branches' })
            vim.keymap.set('n', '<leader>as', arc.stash, { desc = 'Telescope arc stash' })
            vim.keymap.set('n', '<leader>ap', arc.pr_list, { desc = 'Telescope arc pr_list' })
        end,
        dir = "~/arcadia/junk/moonw1nd/lua/telescope-arc.nvim"
    },
}
