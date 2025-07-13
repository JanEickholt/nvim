-- this doesnt work at all right now xd
local ts_utils = require("nvim-treesitter.ts_utils")

local function is_method_call(node)
  local parent = node:parent()
  return parent and parent:type() == "call"
end

local function goto_next_filtered_member()
  local original_pos = vim.api.nvim_win_get_cursor(0)

  -- Keep jumping to next @variable.member until we find one that's not a method call
  for _ = 1, 10 do -- Max 10 attempts to avoid infinite loop
    -- Use the built-in movement
    local ok = pcall(function()
      require("nvim-treesitter.textobjects.move").goto_next_start("@variable.member")
    end)

    if not ok then
      break
    end

    -- Check if current position is a method call
    local node = ts_utils.get_node_at_cursor()
    if node and not is_method_call(node) then
      return -- Found a valid target
    end
  end

  -- If we didn't find anything, restore original position
  vim.api.nvim_win_set_cursor(0, original_pos)
end

vim.keymap.set("n", "]=", goto_next_filtered_member, { desc = "Next property (not method)" })
