local make_entry = require("telescope.make_entry")
local entry_display = require("telescope.pickers.entry_display")
local utils = require("telescope.utils")
local git_status_entry_maker = make_entry.gen_from_git_status()

local make_display = function(entry)
  local icon, icon_hl = utils.get_devicons(entry.value)
  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 2 }, -- For git status (e.g., M, ??)
      { width = vim.fn.strdisplaywidth(icon) },
      { width = nil },
      { remaining = true },
    },
  })
  local name = entry.value and vim.fn.fnamemodify(entry.value, ":t") or "[No Name]"
  local display_path = ""
  if entry.value then
    local path = vim.fn.fnamemodify(entry.value, ":h")
    display_path = utils.transform_path({
      path_display = { shorten = { len = 3, exclude = { -1, -2, -3 } } },
    }, path)
  end
  return displayer({
    { entry.status or "  ", "TelescopeResultsIdentifier" },
    { icon, icon_hl },
    name,
    { display_path, "TelescopeResultsComment" },
  })
end

return function(entry)
  local git_st_entry = git_status_entry_maker(entry)

  if git_st_entry then
    git_st_entry.status = entry:sub(1, 2)
    -- Get the base path from metatable then concatenate with the value to get the full path
    local base_path = git_st_entry.path
    git_st_entry.path = base_path .. git_st_entry.value
    git_st_entry.display = make_display
  end

  return git_st_entry
end
