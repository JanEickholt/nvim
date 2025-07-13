local M = {}
-- NOTE: taken from https://github.com/echasnovski/mini.nvim/discussions/1434

M.v_1 = -- snake_case, camelCase, PascalCase, etc; all capitalizations
  {
    -- Lua 5.1 character classes and the undocumented frontier pattern:
    -- https://www.lua.org/manual/5.1/manual.html#5.4.1
    -- http://lua-users.org/wiki/FrontierPattern
    -- note: when I say "letter" I technically mean "letter or digit"
    {
      -- Matches a single uppercase letter followed by 1+ lowercase letters.
      -- This covers:
      -- - PascalCaseWords (or the latter part of camelCaseWords)
      "%u[%l%d]+%f[^%l%d]", -- An uppercase letter, 1+ lowercase letters, to end of lowercase letters

      -- Matches lowercase letters up until not lowercase letter.
      -- This covers:
      -- - start of camelCaseWords (just the `camel`)
      -- - snake_case_words in lowercase
      -- - regular lowercase words
      "%f[^%s%p][%l%d]+%f[^%l%d]", -- after whitespace/punctuation, 1+ lowercase letters, to end of lowercase letters
      "^[%l%d]+%f[^%l%d]", -- after beginning of line, 1+ lowercase letters, to end of lowercase letters

      -- Matches uppercase or lowercase letters up until not letters.
      -- This covers:
      -- - SNAKE_CASE_WORDS in uppercase
      -- - Snake_Case_Words in titlecase
      -- - regular UPPERCASE words
      -- (it must be both uppercase and lowercase otherwise it will
      -- match just the first letter of PascalCaseWords)
      "%f[^%s%p][%a%d]+%f[^%a%d]", -- after whitespace/punctuation, 1+ letters, to end of letters
      "^[%a%d]+%f[^%a%d]", -- after beginning of line, 1+ letters, to end of letters
    },
    "^().*()$",
  }

M.v_2 = {
  {
    -- __-1, __-U, __-l, __-1_, __-U_, __-l_
    "[^_%-]()[_%-]+()%w()()[%s%p]",
    "^()[_%-]+()%w()()[%s%p]",
    -- __-123SNAKE
    "[^_%-]()[_%-]+()%d+%u[%u%d]+()()",
    "^()[_%-]+()%d+%u[%u%d]+()()",
    -- __-123snake
    "[^_%-]()[_%-]+()%d+%l[%l%d]+()()",
    "^()[_%-]+()%d+%l[%l%d]+()()",
    -- __-SNAKE, __-SNAKE123
    "[^_%-]()[_%-]+()%u[%u%d]+()()",
    "^()[_%-]+()%u[%u%d]+()()",
    -- __-snake, __-Snake, __-snake123, __-Snake123
    "[^_%-]()[_%-]+()%a[%l%d]+()()",
    "^()[_%-]+()%a[%l%d]+()()",
    -- UPPER, UPPER123, UPPER-__, UPPER123-__
    -- No support: 123UPPER
    "[^_%-%u]()()%u[%u%d]+()[_%-]*()",
    "^()()%u[%u%d]+()[_%-]*()",
    -- UPlower, UPlower123, UPlower-__, UPlower123-__
    "%u%u()()[%l%d]+()[_%-]*()",
    -- lower, lower123, lower-__, lower123-__
    "[^_%-%w]()()[%l%d]+()[_%-]*()",
    "^()()[%l%d]+()[_%-]*()",
    -- Camel, Camel123, Camel-__, Camel123-__
    "[^_%-%u]()()%u[%l%d]+()[_%-]*()",
    "^()()%u[%l%d]+()[_%-]*()",
  },
}

return M
