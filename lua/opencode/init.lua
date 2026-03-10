local M = {}

local defaults = {
  port = 42069,
  keymaps = {
    send_line = "<leader>ol",
    send_selection = "<leader>os",
  },
}

local cfg = vim.deepcopy(defaults)

local function send_ref(text)
  local url = string.format("http://localhost:%d/tui/append-prompt", cfg.port)
  vim.system({
    "curl",
    "-s",
    "--connect-timeout",
    "2",
    "--max-time",
    "5",
    "-X",
    "POST",
    "-H",
    "Content-Type: application/json",
    "--data-raw",
    vim.json.encode({ text = text }),
    url,
  })
end

local function format_ref(filepath, start_line, end_line)
  local fname = vim.fn.fnamemodify(filepath, ":.")
  if start_line == end_line then
    return string.format("@%s L%d ", fname, start_line)
  end
  return string.format("@%s L%d-L%d ", fname, start_line, end_line)
end

function M.send_line()
  local filepath = vim.api.nvim_buf_get_name(0)
  local line_nr = vim.api.nvim_win_get_cursor(0)[1]
  send_ref(format_ref(filepath, line_nr, line_nr))
end

function M.send_selection()
  local filepath = vim.api.nvim_buf_get_name(0)
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]
  send_ref(format_ref(filepath, start_line, end_line))
end

function M.setup(opts)
  cfg = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})

  vim.keymap.set("n", cfg.keymaps.send_line, M.send_line, { desc = "OpenCode: send line ref" })
  vim.keymap.set("v", cfg.keymaps.send_selection, function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", false)
    vim.schedule(M.send_selection)
  end, { desc = "OpenCode: send selection ref" })
end

return M
