local make_entry = require("telescope.make_entry")
local entry_display = require("telescope.pickers.entry_display")
local utils = require("telescope.utils")
require("telescope").extensions.fzf.native_fzf_sorter()
local plain_file_maker = make_entry.gen_from_file()

local make_display = function(entry)
  local icon, icon_hl = utils.get_devicons(entry.name)
  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = vim.fn.strdisplaywidth(icon) },
      { width = nil },
      { remaining = true },
    },
  })
  local name = entry.filename and vim.fn.fnamemodify(entry.filename, ":t") or "[No Name]"
  local display_path = ""
  if entry.filename then
    local path = vim.fn.fnamemodify(entry.filename, ":h")
    display_path = utils.transform_path({
      path_display = { shorten = { len = 3, exclude = { -1, -2, -3 } } },
    }, path)
  end
  return displayer({
    { icon, icon_hl },
    name,
    { display_path, "TelescopeResultsComment" },
  })
end

return function(entry)
  local file_entry = plain_file_maker(entry)
  if file_entry == nil then
    return nil
  end

  file_entry.name = vim.fn.fnamemodify(entry, ":t")
  file_entry.display = make_display

  return file_entry
end
