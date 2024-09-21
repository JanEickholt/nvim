return {
  "catppuccin/nvim",
  lazy = false,
  opts = {
    transparent_background = false,
    color_overrides = {
      mocha = {},
    },
  },
  priority = 1000,
  config = function(_, opts)
    local handle = io.popen("xrdb -query | grep -w '*background' | awk '{print $2}'")
    opts.color_overrides.mocha.base = handle:read("*a"):gsub("\n", "")
    handle:close()
    require("catppuccin").setup(opts)
    vim.cmd("colorscheme catppuccin-mocha")
  end,
}
