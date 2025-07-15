local M = {}

local restore_wezmove_bindings = function(wezmove)
  vim.keymap.set("n", "<C-j>", function()
    wezmove.move("j")
  end)

  vim.keymap.set("n", "<C-k>", function()
    wezmove.move("k")
  end)
end

local restore_smart_splits_bindings = function(smsplit)
  vim.keymap.set("n", "<C-j>", function()
    smsplit.move_cursor_down()
  end)

  vim.keymap.set("n", "<C-k>", function()
    smsplit.move_cursor_up()
  end)
end

function M.restore_gs_bindings()
  vim.keymap.set("n", "q", "", { noremap = true, desc = "Quit most things" })
  vim.keymap.set("n", "Q", "q", { noremap = true, desc = "Record macro" })
  local has_wezmove, wezmove = pcall(require, "wezterm-move")
  if has_wezmove then
    restore_wezmove_bindings(wezmove)
  end
  local has_smsplit, smsplit = pcall(require, "smart-splits")
  if has_smsplit then
    restore_smart_splits_bindings(smsplit)
  end
end

return M
