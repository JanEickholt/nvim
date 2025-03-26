local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node

return {
  s("test", {
    i(1, "Hello, World!"),
  }),
}
