local M = {}

local ls = require("luasnip")

local sn = ls.snippet_node

local i = ls.insert_node

function M.get_ISO_8601_date()
  return os.date("%Y-%m-%d")
end

function M.get_visual(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    vim.notify(parent.snippet.env.LS_SELECT_RAW)

    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    vim.notify("else block")

    return sn(nil, i(1, ""))
  end
end

return M
