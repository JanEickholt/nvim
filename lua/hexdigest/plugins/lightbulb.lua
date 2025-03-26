return {
  "kosayoda/nvim-lightbulb",
  dependencies = "antoinemadec/FixCursorHold.nvim",
  config = function()
    require("nvim-lightbulb").setup({
      sign = {
        enabled = true,
        priority = 10,
      },
    })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = function()
        require("nvim-lightbulb").update_lightbulb()
      end,
    })
  end,
}
