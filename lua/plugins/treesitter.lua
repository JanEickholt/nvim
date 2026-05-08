return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local ts = require("nvim-treesitter")

    -- Setup with default install directory
    ts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    require("nvim-ts-autotag").setup({
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    })

    -- Auto-install commonly used parsers if missing
    local installed = {}
    for _, lang in ipairs(ts.get_installed()) do
      installed[lang] = true
    end

    local desired_parsers = {
      "bash",
      "c",
      "cpp",
      "css",
      "go",
      "html",
      "java",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "php",
      "python",
      "rust",
      "svelte",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    }

    local to_install = {}
    for _, lang in ipairs(desired_parsers) do
      if not installed[lang] then
        table.insert(to_install, lang)
      end
    end

    if #to_install > 0 then
      vim.notify("Installing treesitter parsers: " .. table.concat(to_install, ", "), vim.log.levels.INFO)
      ts.install(to_install)
    end

    local group = vim.api.nvim_create_augroup("hexdigest-treesitter", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "*",
      callback = function(args)
        if vim.bo[args.buf].filetype == "latex" then
          return
        end

        if not pcall(vim.treesitter.start, args.buf) then
          return
        end

        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype) or vim.bo[args.buf].filetype
        if pcall(vim.treesitter.query.get, lang, "indents") then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
