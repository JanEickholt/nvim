return {
  "lervag/vimtex",
  lazy = false, -- Important to disable lazy loading
  init = function()
    -- Set VimTeX options here
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_view_skim_sync = 1
    vim.g.vimtex_view_skim_activate = 1
  end,
}
