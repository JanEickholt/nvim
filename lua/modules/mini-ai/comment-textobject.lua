-- In your mini-utils-comment.lua file
local M = {}

local function has_inline_comment(line_text)
  local comment_start = line_text:find("%-%-")
  if not comment_start then
    return false
  end
  local code_before = line_text:sub(1, comment_start - 1):match("%S")
  return code_before ~= nil, comment_start
end

-- Helper function to select comment from a line
local function select_comment(ai_type, line_num, comment_start, line_text)
  local comment_end = #line_text
  if ai_type == "a" then
    local ws_start = line_text:sub(1, comment_start - 1):match(".*%S()%s*$") or comment_start
    return { from = { line = line_num, col = ws_start }, to = { line = line_num, col = comment_end } }
  else
    local text_start = line_text:find("%S", comment_start + 2) or (comment_start + 2)
    return { from = { line = line_num, col = text_start }, to = { line = line_num, col = comment_end } }
  end
end

-- Helper function to get current comment boundaries
local function get_current_comment_boundaries()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local current_line = lines[cursor_line]

  -- Check if cursor is in an inline comment
  local has_inline, comment_start = has_inline_comment(current_line)
  if has_inline and cursor_col >= comment_start then
    return cursor_line, cursor_line

  -- Check if cursor is in a block comment
  elseif current_line:match("^%s*%-%-") then
    local comment_start_line = cursor_line
    local comment_end_line = cursor_line

    -- Go up to find start of comment block
    while comment_start_line > 1 and lines[comment_start_line - 1]:match("^%s*%-%-") do
      comment_start_line = comment_start_line - 1
    end

    -- Go down to find end of comment block
    while comment_end_line < #lines and lines[comment_end_line + 1] and lines[comment_end_line + 1]:match("^%s*%-%-") do
      comment_end_line = comment_end_line + 1
    end

    return comment_start_line, comment_end_line
  end

  return nil, nil
end

-- Function 1: Handle block comments (lines starting with --)
local function handle_block_comment(ai_type)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Find the start and end of consecutive comment lines
  local start_line = cursor_line
  local end_line = cursor_line

  -- Go up to find start of comment block
  while start_line > 1 and lines[start_line - 1]:match("^%s*%-%-") do
    start_line = start_line - 1
  end

  -- Go down to find end of comment block
  while end_line < #lines and lines[end_line]:match("^%s*%-%-") do
    end_line = end_line + 1
  end
  end_line = end_line - 1 -- Adjust back to last comment line

  -- Return empty if cursor is not on a comment line
  if not lines[cursor_line]:match("^%s*%-%-") then
    return { from = { line = cursor_line, col = 1 } }
  end

  local from_col = ai_type == "a" and 1 or (lines[start_line]:find("%S") or 1)
  local to_col = ai_type == "a" and #lines[end_line] or lines[end_line]:len()

  return {
    from = { line = start_line, col = from_col },
    to = { line = end_line, col = to_col },
  }
end

-- Function 2: Handle inline comments (code followed by comment on same line)
local function handle_inline_comment(ai_type)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Check current line first
  local current_line = lines[cursor_line]
  local has_inline, comment_start = has_inline_comment(current_line)

  if has_inline and cursor_col >= comment_start then
    return select_comment(ai_type, cursor_line, comment_start, current_line)
  end

  -- Look for next comment (any type)
  for i = cursor_line, #lines do
    local line_text = lines[i]
    if line_text:find("%-%-") then
      local has_inline_next, comment_start_next = has_inline_comment(line_text)
      if has_inline_next then
        -- It's an inline comment
        return select_comment(ai_type, i, comment_start_next, line_text)
      elseif line_text:match("^%s*%-%-") then
        -- It's a block comment, call block handler with this line as cursor
        local saved_cursor = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_win_set_cursor(0, { i, 0 })
        local result = handle_block_comment(ai_type)
        vim.api.nvim_win_set_cursor(0, saved_cursor)
        return result
      end
    end
  end

  return nil
end

-- Function 3: Handle next comment search
local function handle_next_comment(ai_type)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Check if we're currently in a comment and find its boundaries
  local current_comment_start, current_comment_end = get_current_comment_boundaries()

  -- Start searching from after the current comment (if we're in one)
  local search_start = current_comment_end and (current_comment_end + 1) or cursor_line

  -- Look forwards for any comment, skipping the current one
  for i = search_start, #lines do
    local line_text = lines[i]
    if line_text:find("%-%-") then
      local has_inline_next, comment_start_next = has_inline_comment(line_text)
      if has_inline_next then
        return select_comment(ai_type, i, comment_start_next, line_text)
      elseif line_text:match("^%s*%-%-") then
        local saved_cursor = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_win_set_cursor(0, { i, 0 })
        local result = handle_block_comment(ai_type)
        vim.api.nvim_win_set_cursor(0, saved_cursor)
        return result
      end
    end
  end

  return nil
end

-- Function 4: Handle previous comment search
local function handle_previous_comment(ai_type)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Check if we're currently in a comment and find its boundaries
  local current_comment_start, current_comment_end = get_current_comment_boundaries()

  -- Start searching from before the current comment (if we're in one)
  local search_start = current_comment_start and (current_comment_start - 1) or cursor_line

  -- Look backwards for any comment, skipping the current one
  for i = search_start, 1, -1 do
    local line_text = lines[i]
    if line_text:find("%-%-") then
      local has_inline_prev, comment_start_prev = has_inline_comment(line_text)
      if has_inline_prev then
        return select_comment(ai_type, i, comment_start_prev, line_text)
      elseif line_text:match("^%s*%-%-") then
        local saved_cursor = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_win_set_cursor(0, { i, 0 })
        local result = handle_block_comment(ai_type)
        vim.api.nvim_win_set_cursor(0, saved_cursor)
        return result
      end
    end
  end

  return nil
end

-- Main function that decides which handler to use
function M.ai_comment(ai_type, id, opts)
  opts = opts or {}
  local search_method = opts.search_method or require("mini.ai").config.search_method

  -- For 'prev' search method, look backwards and skip current comment
  if search_method == "prev" then
    return handle_previous_comment(ai_type)
  end

  -- For 'next' search method, look forwards and skip current comment
  if search_method == "next" then
    return handle_next_comment(ai_type)
  end

  -- Default behavior (cover_or_next)
  local inline_result = handle_inline_comment(ai_type)
  if inline_result then
    return inline_result
  end

  return handle_block_comment(ai_type)
end

return M
