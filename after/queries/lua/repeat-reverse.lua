local M = {}
function M.setup_gitsigns()
  if M.gitsigns_next_hunk then
    return M.gitsigns_next_hunk, M.gitsigns_prev_hunk
  end

  local function next_hunk()
    local gs = package.loaded.gitsigns
    if vim.wo.diff then
      vim.cmd.normal({ "]c", bang = true })
    else
      gs.next_hunk()
    end
    vim.defer_fn(function()
      vim.cmd("normal! zz")
    end, 5)
  end

  local function prev_hunk()
    local gs = package.loaded.gitsigns
    if vim.wo.diff then
      vim.cmd.normal({ "[c", bang = true })
    else
      gs.prev_hunk()
    end
    vim.defer_fn(function()
      vim.cmd("normal! zz")
    end, 5)
  end

  M.gitsigns_next_hunk, M.gitsigns_prev_hunk = RepeatablePairs.track_pair(next_hunk, prev_hunk)

  return M.gitsigns_next_hunk, M.gitsigns_prev_hunk
end
return M
