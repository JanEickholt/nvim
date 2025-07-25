local make_entry = require("telescope.make_entry")
local entry_display = require("telescope.pickers.entry_display")
local utils = require("telescope.utils")

require("telescope").extensions.fzf.native_fzf_sorter()
local plain_grep_maker = make_entry.gen_from_vimgrep()

local make_display = function(entry)
  local icon, icon_hl = utils.get_devicons(entry.filename)
  local filename = vim.fn.fnamemodify(entry.filename, ":t")
  local path = vim.fn.fnamemodify(entry.filename, ":h")

  local display_path = utils.transform_path({
    path_display = { shorten = { len = 3, exclude = { -1, 2 } } },
  }, path)

  local line_col = entry.lnum .. ":" .. entry.col
  local line_col_width = vim.fn.strdisplaywidth(line_col)

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = vim.fn.strdisplaywidth(icon) }, -- icon width
      { width = #filename },
      { width = line_col_width },
      { remaining = true },
      { width = #display_path },
    },
  })

  return displayer({
    { icon,                        icon_hl },
    { filename },
    { line_col,                    "TelescopeResultsNumber" },
    { entry.text:gsub("^%s+", ""), "TelescopeResultsIdentifier" },
    { display_path,                "TelescopeResultsComment" },
  })
end

return function(entry)
  local grep_entry = plain_grep_maker(entry)
  if grep_entry == nil then
    return nil
  end
  grep_entry.display = make_display
  return grep_entry
end
