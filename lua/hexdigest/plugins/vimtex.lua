return {
  "lervag/vimtex",
  init = function()
    vim.g["vimtex_view_method"] = "zathura"
    vim.g["vimtex_quickfix_mode"] = 0
    vim.g["vimtex_mappings_enabled"] = 1
    vim.g["vimtex_indent_enabled"] = 0
    vim.g["tex_flavor"] = "latex"
    vim.g["tex_indent_items"] = 0
    vim.g["tex_indent_brace"] = 0
    vim.g["vimtex_context_pdf_viewer"] = "zathura"
    vim.g["vimtex_compiler_latexmk"] = {
      options = {
        "-synctex=1",
        "-aux-directory=/tmp/vimtex",
      },
    }
    vim.g["vimtex_log_ignore"] = {
      "Underfull",
      "Overfull",
      "specifier changed to",
      "Token not allowed in a PDF string",
    }
  end,
}
