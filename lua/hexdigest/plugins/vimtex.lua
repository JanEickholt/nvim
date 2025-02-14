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
      aux_dir = "/tmp/vimtex/",
      out_dir = "./out",
      executable = "latexmk",
      callback = 1,
      continuous = 1,
      options = {
        "-synctex=1",
        "-file-line-error",
        "-verbose",
        "-interaction=nonstopmode",
      },
    }
    vim.g["vimtex_log_ignore"] = {
      "Underfull",
      "Overfull",
      "specifier changed to",
      "Token not allowed in a PDF string",
      "LaTeX Warning: Command ",
    }
  end,
}
