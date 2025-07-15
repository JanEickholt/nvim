vim.g.mapleader = " "

vim.opt.scrolloff = 8

local has_wk, wk = pcall(require, "which-key")

-- Enhanced map function that handles both vim keymaps and which-key
local function map(mode, lhs, rhs, options)
  options = options or {}

  local icon = options.icon
  local vim_options = vim.tbl_deep_extend("force", {}, options)
  vim_options.icon = nil -- Remove icon from vim keymap options

  vim.keymap.set(mode, lhs, rhs, vim_options)

  if has_wk and options.icon then
    local wk_spec = {
      lhs,
      rhs,
      desc = options.desc,
      icon = icon,
      mode = mode,
    }

    wk.add({ wk_spec })
  end
end

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "J", "mzJ`z")

map("x", "<leader>p", '"_dP')
map({ "n", "v" }, "<leader>y", '"+y')
map({ "n", "v" }, "<leader>d", '"_d')

-- Make Y work like D or C
map("n", "Y", "y$")

-- Stop cc, x, and X from overwriting default register
map("n", "cc", '"_cc')
map("n", "x", '"_x')
map("n", "X", '"_X')

-- Paste in visual mode without overwriting default register
map("v", "p", "P")

map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

map("v", "<leader>i", "g<C-a>")

map({ "i", "n", "v" }, "<C-C>", "<esc>", { desc = "Make Ctrl+C behave exactly like escape." })

-- Delete whole word with ctrl+backspace (interpreted as <C-h> in terminal)
map("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })

-- Rebind macro key cause mistakes are made too often lol
map("n", "q", "", { desc = "Disabled (use Q for macros)" })
map("n", "Q", "q", { desc = "Record macro" })

-- Center after most code navigation commands
map("n", "G", "Gzz", { desc = "Go to end and center" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "<C-O>", "<C-O>zz", { desc = "Jump back and center" })
map("n", "<C-I>", "<C-I>zz", { desc = "Jump forward and center" })
map("n", "{", "{zz", { desc = "Previous paragraph and center" })
map("n", "}", "}zz", { desc = "Next paragraph and center" })
map("n", "n", "nzz", { desc = "Next search and center" })
map("n", "N", "Nzz", { desc = "Previous search and center" })
map("n", "*", "*zz", { desc = "Search word under cursor and center" })
map("n", "#", "#zz", { desc = "Search word under cursor backward and center" })
map("n", "%", "%zz", { desc = "Match bracket and center" })

map("n", "<leader>ya", 'ggVG"+y', { desc = "Copy file content to system clipboard" })

-- better indenting
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Disable arrow keys
map({ "n", "i", "v" }, "<Up>", "<Nop>", { desc = "Disable Up arrow key" })
map({ "n", "i", "v" }, "<Down>", "<Nop>", { desc = "Disable Down arrow key" })
map({ "n", "i", "v" }, "<Left>", "<Nop>", { desc = "Disable Left arrow key" })
map({ "n", "i", "v" }, "<Right>", "<Nop>", { desc = "Disable Right arrow key" })

map("i", "jj", "<ESC>", { silent = true }, { desc = "Exit insert mode with jj" })

-- Swap true/false keywords
map("n", "<leader>S", function()
  require("scripts.edit.swap-true-false-keywords").swap_keywords()
end, { desc = "Swap true/false keywords", icon = "" })

-- Invert (flip flop) comments with gC, in normal and visual mode
map(
  { "n", "x" },
  "gC",
  "<cmd>set operatorfunc=v:lua.__flip_flop_comment<cr>g@",
  { silent = true, desc = "Invert comments" }
)
