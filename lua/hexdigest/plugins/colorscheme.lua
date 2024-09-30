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
    local background_color = handle:read("*a"):gsub("\n", "")
    handle:close()

    if background_color == "" then
      background_color = "#1e1e2e"
    end

    opts.color_overrides.mocha.base = background_color

    require("catppuccin").setup(opts)
    vim.cmd("colorscheme catppuccin-mocha")
  end,
}
