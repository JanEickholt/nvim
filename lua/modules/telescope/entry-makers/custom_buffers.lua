local make_entry = require("telescope.make_entry")
local entry_display = require("telescope.pickers.entry_display")
local utils = require("telescope.utils")
require("telescope").extensions.fzf.native_fzf_sorter()
local plain_buffer_maker = make_entry.gen_from_buffer()

-- Find the maximum width needed for buffer numbers
local function get_max_bufnr_width()
  local buffers = vim.api.nvim_list_bufs()
  local max_width = 0
  for _, bufnr in ipairs(buffers) do
    local width = vim.fn.strdisplaywidth(tostring(bufnr))
    max_width = math.max(max_width, width)
  end
  -- Set a minimum width of 3 to handle small buffer numbers
  return math.max(max_width, 3)
end

-- Calculate this once when creating the entry maker
local bufnr_width = get_max_bufnr_width()

local make_display = function(entry)
  local icon, icon_hl = utils.get_devicons(entry.filename or "")
  local bufnr_str = tostring(entry.bufnr)

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = bufnr_width }, -- fixed width for all buffer numbers
      { width = 4 }, -- for buffer indicator/flag
      { width = vim.fn.strdisplaywidth(icon) }, -- file icon
      { width = nil }, -- filename
      { remaining = true }, -- path
    },
  })

  local filename = entry.filename and vim.fn.fnamemodify(entry.filename, ":t") or "[No Name]"
  local display_path = ""
  if entry.filename then
    local path = vim.fn.fnamemodify(entry.filename, ":h")
    display_path = utils.transform_path({
      path_display = { shorten = { len = 3, exclude = { -1, -2, -3 } } },
    }, path)
  end

  local indicator = entry.indicator or " "
  return displayer({
    { bufnr_str, "TelescopeResultsNumber" },
    { indicator, "TelescopeResultsComment" },
    { icon, icon_hl },
    filename,
    { display_path, "TelescopeResultsComment" },
  })
end

return function(entry)
  local buffer_entry = plain_buffer_maker(entry)
  if buffer_entry == nil then
    return nil
  end
  -- Add our custom display while keeping all original entry data
  buffer_entry.display = make_display
  return buffer_entry
end
