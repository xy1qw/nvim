---@diagnostic disable: undefined-global

local M = {}

function M.setup()
    local colors = {
        error = "#F14C4C",
        warn  = "#CCA700",
        info  = "#3794FF",
        hint  = "#16C60C",
    }

    vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.error })
    vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = colors.warn })
    vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = colors.info })
    vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = colors.hint })

    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.error })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = colors.warn })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = colors.info })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = colors.hint })

    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "#402020", fg = colors.error })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "#403810", fg = colors.warn })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { bg = "#102840", fg = colors.info })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "#103010", fg = colors.hint })

    local signs = {
        Error = { icon = "", color = colors.error },
        Warn  = { icon = "", color = colors.warn },
        Info  = { icon = "", color = colors.info },
        Hint  = { icon = "", color = colors.hint },
    }

    for type, data in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.api.nvim_set_hl(0, hl, { fg = data.color })

        vim.fn.sign_define(hl, {
            text = data.icon,
            texthl = hl,
            numhl = "",
        })
    end

    vim.diagnostic.config({
        virtual_text = {
            prefix = "●",
            spacing = 2,
            severity_sort = true,
        },
        virtual_lines = false,
        underline = true,
        update_in_insert = true,
        severity_sort = true,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
            local bufnr = ev.buf
            local client = vim.lsp.get_client_by_id(ev.data.client_id)

            vim.diagnostic.enable(bufnr)

            client.notify("textDocument/didChange", {
                textDocument = {
                    uri = vim.uri_from_bufnr(bufnr),
                    version = 1,
                },
                contentChanges = {},
            })

            vim.defer_fn(function()
                vim.diagnostic.show(nil, bufnr)
            end, 50)
        end,
    })
end

return M
