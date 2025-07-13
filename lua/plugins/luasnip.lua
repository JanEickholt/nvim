return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local sn = ls.snippet_node
    local isn = ls.indent_snippet_node
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node
    local d = ls.dynamic_node
    local r = ls.restore_node
    local events = require("luasnip.util.events")
    local ai = require("luasnip.nodes.absolute_indexer")
    local fmt = require("luasnip.extras.fmt").fmt
    local fmta = require("luasnip.extras.fmt").fmta
    local m = require("luasnip.extras").m
    local lambda = require("luasnip.extras").l
    local postfix = require("luasnip.extras.postfix").postfix

    -- LuaSnip Configuration
    ls.config.set_config({
      history = false,
      enable_autosnippets = true,
      store_selection_keys = "<Tab>",
      region_check_events = "InsertEnter",
      delete_check_events = "InsertLeave",
    })

    -- Load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Load custom snippets from directories
    require("luasnip.loaders.from_lua").lazy_load({
      paths = {
        vim.fn.stdpath("config") .. "/lua/plugins/snippets/",
      },
    })

    -- Custom snippet helper functions
    local helpers = {
      get_visual = function(args, parent)
        if #parent.snippet.env.LS_SELECT_RAW > 0 then
          return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
        else
          return sn(nil, i(1, ""))
        end
      end,
      get_ISO_8601_date = function()
        return os.date("%Y-%m-%d")
      end,
    }

    -- Keymaps
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      return ls.expandable() and "<Plug>luasnip-expand-snippet" or "<Tab>"
    end, { expr = true })

    vim.keymap.set({ "i", "s" }, "jk", function()
      return ls.jumpable(1) and "<Plug>luasnip-jump-next" or "jk"
    end, { expr = true })

    vim.keymap.set({ "i", "s" }, "<C-b>", function()
      return ls.jumpable(-1) and "<Plug>luasnip-jump-prev" or "<C-j>"
    end, { expr = true })

    vim.keymap.set({ "i", "s" }, "<C-f>", function()
      return ls.choice_active() and "<Plug>luasnip-next-choice" or "<C-f>"
    end, { expr = true })

    -- Reload snippets
    vim.keymap.set("n", "<Leader>U", function()
      require("luasnip.loaders.from_lua").lazy_load({
        paths = vim.fn.stdpath("config") .. "/lua/plugins/snippets/",
      })
      vim.notify("Snippets refreshed!", vim.log.levels.INFO)
    end)

    -- Optional: Expose helpers globally if needed
    _G.luasnip_helpers = helpers
  end,
}
