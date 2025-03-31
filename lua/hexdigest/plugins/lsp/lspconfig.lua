return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    local nvim_lsp = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")

    local protocol = require("vim.lsp.protocol")

    local on_attach = function(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
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
      keymap("n", "gd", vim.lsp.buf.definition, opts)   -- Go to definition
      keymap("n", "gD", vim.lsp.buf.declaration, opts)  -- Go to declaration
      keymap("n", "gi", vim.lsp.buf.implementation, opts) -- Go to implementation
      keymap("n", "gr", vim.lsp.buf.references, opts)   -- Find references
      keymap("n", "gy", vim.lsp.buf.type_definition, opts) -- Go to type definition

      -- Documentation and information
      keymap("n", "K", vim.lsp.buf.hover, opts)           -- Show hover information
      keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts) -- Show signature help

      -- Code actions and modifications
      keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code actions
      keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)   -- Rename symbol

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

    mason_lspconfig.setup_handlers({
      function(server)
        nvim_lsp[server].setup({
          capabilities = capabilities,
        })
      end,
      ["lua_ls"] = function()
        nvim_lsp["lua_ls"].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
      ["pyright"] = function()
        nvim_lsp["pyright"].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
      ["clangd"] = function()
        nvim_lsp["clangd"].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
      ["intelephense"] = function()
        nvim_lsp["intelephense"].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
      ["texlab"] = function()
        nvim_lsp["texlab"].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
      ["jdtls"] = function()
        nvim_lsp["jdtls"].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
      ["tailwindcss"] = function()
        nvim_lsp["tailwindcss"].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
      ["svelte"] = function()
        nvim_lsp["svelte"].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
      ["dockerls"] = function()
        nvim_lsp["dockerls"].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
      ["gopls"] = function()
        nvim_lsp["gopls"].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
      ["ts_ls"] = function()
        nvim_lsp["ts_ls"].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
    })
  end,
}
