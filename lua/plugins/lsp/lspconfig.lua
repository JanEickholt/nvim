return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    local nvim_lsp = require("lspconfig")

    local function map(mode, lhs, rhs, options)
      options = options or {}
      local icon = options.icon
      local vim_options = vim.tbl_deep_extend("force", {}, options)
      vim_options.icon = nil -- Remove icon from vim keymap options
      vim.keymap.set(mode, lhs, rhs, vim_options)
      if has_wk and options.icon then
        local wk_spec = {
          lhs,
          rhs,
          desc = options.desc,
          icon = icon,
          mode = mode,
        }
        wk.add({ wk_spec })
      end
    end

    local on_attach = function(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      vim.diagnostic.config({ virtual_text = true })

      -- format on save
      if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("Format", { clear = true }),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ timeout_ms = 10000 })
          end,
        })
      end

      local opts = { noremap = true, silent = true, buffer = bufnr }

      -- Navigation keybindings
      map(
        "n",
        "gd",
        vim.lsp.buf.definition,
        vim.tbl_extend("force", opts, {
          desc = "Go to definition",
        })
      )

      map(
        "n",
        "gD",
        vim.lsp.buf.declaration,
        vim.tbl_extend("force", opts, {
          desc = "Go to declaration",
        })
      )

      map(
        "n",
        "gi",
        vim.lsp.buf.implementation,
        vim.tbl_extend("force", opts, {
          desc = "Go to implementation",
        })
      )

      map(
        "n",
        "gr",
        vim.lsp.buf.references,
        vim.tbl_extend("force", opts, {
          desc = "Find references",
        })
      )

      map(
        "n",
        "gy",
        vim.lsp.buf.type_definition,
        vim.tbl_extend("force", opts, {
          desc = "Go to type definition",
        })
      )

      -- Documentation and information
      map(
        "n",
        "K",
        vim.lsp.buf.hover,
        vim.tbl_extend("force", opts, {
          desc = "Show hover information",
        })
      )

      map(
        "n",
        "<C-k>",
        vim.lsp.buf.signature_help,
        vim.tbl_extend("force", opts, {
          desc = "Show signature help",
        })
      )

      -- Code actions and modifications
      map(
        "n",
        "<leader>ca",
        vim.lsp.buf.code_action,
        vim.tbl_extend("force", opts, {
          desc = "Code actions",
        })
      )

      map(
        "n",
        "<leader>rn",
        vim.lsp.buf.rename,
        vim.tbl_extend("force", opts, {
          desc = "Rename symbol",
        })
      )

      -- Workspace management
      map(
        "n",
        "<leader>wa",
        vim.lsp.buf.add_workspace_folder,
        vim.tbl_extend("force", opts, {
          desc = "Add workspace folder",
        })
      )

      map(
        "n",
        "<leader>wr",
        vim.lsp.buf.remove_workspace_folder,
        vim.tbl_extend("force", opts, {
          desc = "Remove workspace folder",
        })
      )

      map(
        "n",
        "<leader>wl",
        function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        vim.tbl_extend("force", opts, {
          desc = "List workspace folders",
        })
      )

      -- Document formatting
      map(
        "n",
        "<leader>f",
        function()
          vim.lsp.buf.format({ async = true })
        end,
        vim.tbl_extend("force", opts, {
          desc = "Format document",
        })
      )

      -- Diagnostics navigation
      map(
        "n",
        "[d",
        vim.diagnostic.goto_prev,
        vim.tbl_extend("force", opts, {
          desc = "Go to previous diagnostic",
        })
      )

      map(
        "n",
        "]d",
        vim.diagnostic.goto_next,
        vim.tbl_extend("force", opts, {
          desc = "Go to next diagnostic",
        })
      )
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    nvim_lsp.ts_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    nvim_lsp.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    nvim_lsp.pyright.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    nvim_lsp.clangd.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    nvim_lsp.intelephense.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    nvim_lsp.texlab.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    nvim_lsp.jdtls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    nvim_lsp.tailwindcss.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    nvim_lsp.svelte.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    nvim_lsp.dockerls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    nvim_lsp.gopls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
}
