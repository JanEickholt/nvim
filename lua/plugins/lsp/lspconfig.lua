return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- Corrected line: removed the parentheses
    local lspconfig = vim.lsp.config
    local on_attach = function(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      vim.diagnostic.config({ virtual_text = true })
      -- format on save
      if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("Format", { clear = true }),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format()
          end,
        })
      end
      local opts = { noremap = true, silent = true, buffer = bufnr }
      local keymap = vim.keymap.set

      -- Navigation keybindings
      keymap("n", "gd", vim.lsp.buf.definition, opts)      -- Go to definition
      keymap("n", "gD", vim.lsp.buf.declaration, opts)     -- Go to declaration
      keymap("n", "gi", vim.lsp.buf.implementation, opts)  -- Go to implementation
      keymap("n", "gr", vim.lsp.buf.references, opts)      -- Find references
      keymap("n", "gy", vim.lsp.buf.type_definition, opts) -- Go to type definition

      -- Documentation and information
      keymap("n", "K", vim.lsp.buf.hover, opts)              -- Show hover information
      keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts) -- Show signature help

      -- Code actions and modifications
      keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code actions
      keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)      -- Rename symbol

      -- Workspace management
      keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
      keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
      keymap("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)

      -- Document formatting
      keymap("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, opts)

      -- Diagnostics navigation
      keymap("n", "[d", vim.diagnostic.goto_prev, opts) -- Go to previous diagnostic
      keymap("n", "]d", vim.diagnostic.goto_next, opts) -- Go to next diagnostic
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    vim.lsp.config("ts_ls", {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable("ts_ls")

    vim.lsp.config("lua_ls", {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable("lua_ls")

    vim.lsp.config("pyright", {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable("pyright")

    vim.lsp.config("clangd", {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable("clangd")

    vim.lsp.config("intelephense", {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable("intelephense")

    vim.lsp.config("texlab", {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable("texlab")

    vim.lsp.config("jdtls", {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable("jdtls")

    vim.lsp.config("tailwindcss", {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable("tailwindcss")

    vim.lsp.config("svelte", {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable("svelte")

    vim.lsp.config("dockerls", {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable("dockerls")

    vim.lsp.config("gopls", {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable("gopls")
  end,
}
