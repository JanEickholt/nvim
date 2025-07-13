local mini_utils = require("modules.mini-ai.mini-utils")
local mini_comments = require("modules.mini-ai.comment-textobject")
local word_with_case = require("modules.mini-ai.word-with-case")
return {
  "echasnovski/mini.ai",
  enabled = true,
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({ -- code block
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),       -- class
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },           -- tags
        d = { "%f[%d]%d+" },                                                          -- digits
        -- e = { -- Word with case (og version)
        --   { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
        --   "^().*()$",
        -- },
        e = word_with_case.v_2,                                    -- Word with case (amped up version)
        i = mini_utils.ai_indent,                                  -- indent
        g = mini_utils.ai_buffer,                                  -- buffer
        u = ai.gen_spec.function_call(),                           -- u for "Usage"
        U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        C = mini_comments.ai_comment,                              -- comment custom textobject
      },
    }
  end,
  config = function(_, opts)
    require("mini.ai").setup(opts)
    mini_utils.ai_whichkey(opts)
  end,
}
