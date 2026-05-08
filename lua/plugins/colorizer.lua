vim.filetype.add({
  extension = {
    rasi = "rasi",
  },
})

return {
  "catgoose/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      "*",
    }, {
      names = false,
      RRGGBBAA = true,
    })
  end,
}
