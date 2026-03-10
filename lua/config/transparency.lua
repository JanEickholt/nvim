-- Manual transparency overrides for UI elements
-- This ensures transparency even if colorscheme doesn't respect it

local function set_transparent_highlights()
  -- Core floating window groups
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

  -- Telescope
  vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = "none" })

  -- Which-key
  vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "WhichKeyBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "WhichKeyNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "WhichKeyGroup", { bg = "none" })
  vim.api.nvim_set_hl(0, "WhichKeyDesc", { bg = "none" })
  vim.api.nvim_set_hl(0, "WhichKeyValue", { bg = "none" })

  -- Popup menus (completion, etc.)
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
  vim.api.nvim_set_hl(0, "PmenuSel", { bg = "none" })
  vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "none" })
  vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "none" })
  vim.api.nvim_set_hl(0, "PmenuExtra", { bg = "none" })
  vim.api.nvim_set_hl(0, "PmenuKind", { bg = "none" })

  -- LSP hover/signature help
  vim.api.nvim_set_hl(0, "LspFloatWinNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "LspFloatWinBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bg = "none" })

  -- General UI elements
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
  vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
  vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })
  vim.api.nvim_set_hl(0, "Terminal", { bg = "none" })
end

-- Apply immediately on load
set_transparent_highlights()

-- Re-apply when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_transparent_highlights,
  desc = "Re-apply transparency overrides when colorscheme changes",
})
