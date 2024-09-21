vim.filetype.add({
  extension = {
    rasi = "rasi",
  },
})

return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      "*",
    }, {
      names = false, -- Disable name-based colors globally
      RRGGBBAA = true, -- Enable RRGGBBAA colors globally
    })
  end,
}
