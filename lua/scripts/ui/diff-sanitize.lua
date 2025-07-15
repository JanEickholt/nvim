--- Module for disabling/enabling features during diff mode to improve legibility
local M = {}
local ts_context = nil
local ts_context_was_enabled = false
local lspsaga_winbar_was_enabled = false
local lualine_winbar_was_enabled = false

--- Disables features that can clutter diff view:
--- - Diagnostic messages
--- - Treesitter context (sticky headers)
--- - LSP Saga winbar breadcrumbs
--- - Lualine winbar
--- @return nil
function M.disable_diff_features()
  vim.diagnostic.enable(false)

  -- Disable treesitter context
  local has_ts_context
  has_ts_context, ts_context = pcall(require, "treesitter-context")
  if has_ts_context then
    ts_context.disable()
    ts_context_was_enabled = true
  end

  -- Disable lspsaga winbar
  local has_lspsaga, _ = pcall(require, "lspsaga")
  if has_lspsaga then
    local config = require("lspsaga").config
    lspsaga_winbar_was_enabled = config.symbol_in_winbar and config.symbol_in_winbar.enable
    if lspsaga_winbar_was_enabled then
      vim.cmd("Lspsaga winbar_toggle")
    end
  end

  -- Disable lualine winbar
  local has_lualine, lualine = pcall(require, "lualine")
  if has_lualine then
    local config = lualine.get_config()
    -- Check if winbar is configured and has content
    if
        config.winbar
        and (
          config.winbar.lualine_a
          or config.winbar.lualine_b
          or config.winbar.lualine_c
          or config.winbar.lualine_x
          or config.winbar.lualine_y
          or config.winbar.lualine_z
        )
    then
      lualine_winbar_was_enabled = true
      -- Temporarily disable winbar by setting it to empty
      local temp_config = vim.deepcopy(config)
      temp_config.winbar = {}
      lualine.setup(temp_config)

      -- Explicitly set winbar to empty
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        vim.wo[win].winbar = ""
      end
    end
  end

  vim.cmd("redraw!")
end

--- Re-enables features that were disabled for diff mode with `disable_diff_features`
--- Restores the previous state of all managed features
--- @return nil
function M.re_enable_diff_features()
  vim.diagnostic.enable(true)

  if ts_context_was_enabled and ts_context then
    ts_context.enable()
    ts_context_was_enabled = false
  end

  if lspsaga_winbar_was_enabled then
    vim.cmd("Lspsaga winbar_toggle")
    lspsaga_winbar_was_enabled = false
  end

  if lualine_winbar_was_enabled then
    local has_lualine, lualine = pcall(require, "lualine")
    if has_lualine then
      local _, navic = pcall(require, "nvim-navic")
      local config = lualine.get_config()
      config.winbar.lualine_c = {
        {
          function()
            return " " .. navic.get_location() -- Empty string to make winbar always appear
          end,
          cond = function()
            return navic.is_available()
          end,
        },
      }
      lualine.setup(config)
    end
    lualine_winbar_was_enabled = false
  end

  vim.cmd("redraw!")
end

return M
