return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  enabled = true,
  event = "VeryLazy",
  keys = {
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({
          entry_maker = require("modules.telescope.entry-makers.custom_find_files"),
        })
      end,
      desc = "Find files (custom)",
    },
    {
      "<leader>fr",
      function()
        require("telescope.builtin").oldfiles({
          entry_maker = require("modules.telescope.entry-makers.custom_find_files"),
        })
      end,
      desc = "Recent files (custom)",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers({
          entry_maker = require("modules.telescope.entry-makers.custom_buffers"),
        })
      end,
      desc = "Buffers (custom)",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep({
          entry_maker = require("modules.telescope.entry-makers.custom_live_grep"),
        })
      end,
      desc = "Live grep (custom)",
    },
    {
      "<leader>fc",
      function()
        require("telescope.builtin").git_status({
          entry_maker = require("modules.telescope.entry-makers.custom_git_status"),
        })
      end,
      desc = "Git changes (custom)",
    },
  },
  config = function()
    vim.api.nvim_set_hl(0, "TelescopeMatching", { link = "CustomMatch" })
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    -- Shared keymap setup for focused windows
    local function setup_focus_keymaps(prompt_bufnr, bufnr, prompt_win)
      vim.keymap.set("n", "i", function()
        vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
        vim.cmd("startinsert")
      end, { buffer = bufnr })

      vim.keymap.set("n", "q", function()
        actions.close(prompt_bufnr)
      end, { buffer = bufnr })

      -- Disable navigation keymaps that might conflict
      local nav_keys = { "<C-l>", "<C-j>", "<C-k>", "<C-h>" }
      for _, key in ipairs(nav_keys) do
        vim.keymap.set("n", key, "<nop>", { buffer = bufnr })
      end
    end

    -- Focus window helper
    local function focus_window(prompt_bufnr, window_type)
      local action_state = require("telescope.actions.state")
      local picker = action_state.get_current_picker(prompt_bufnr)
      local prompt_win = picker.prompt_win
      local target_win, target_bufnr

      if window_type == "preview" then
        local previewer = picker.previewer
        target_bufnr = previewer.state.bufnr or previewer.state.termopen_bufnr
        target_win = previewer.state.winid or vim.fn.win_findbuf(target_bufnr)[1]
      elseif window_type == "results" then
        target_win = picker.results_win
        target_bufnr = vim.api.nvim_win_get_buf(target_win)
      end

      setup_focus_keymaps(prompt_bufnr, target_bufnr, prompt_win)
      vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", target_win))
    end

    -- Specific focus functions
    local focus_preview = function(prompt_bufnr)
      focus_window(prompt_bufnr, "preview")
    end

    local focus_results = function(prompt_bufnr)
      focus_window(prompt_bufnr, "results")
    end

    -- Flash setup
    local function flash(prompt_bufnr)
      require("flash").jump({
        pattern = "^",
        label = { after = { 0, 0 } },
        search = {
          mode = "search",
          exclude = {
            function(win)
              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
            end,
          },
        },
        action = function(match)
          local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
          picker:set_selection(match.pos[1] - 1)
        end,
      })
    end

    -- Configure telescope
    telescope.setup({
      defaults = {
        mappings = {
          n = {
            s = flash,
            ["<C-l>"] = focus_preview,
            ["<C-h>"] = focus_results,
          },
          i = {
            ["<m-s>"] = flash,
            ["<C-l>"] = focus_preview,
            ["<C-h>"] = focus_results,
          },
        },
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },
      },
      pickers = {
        live_grep = {
          mappings = {
            i = {
              ["<C-g>"] = actions.to_fuzzy_refine,
            },
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    telescope.load_extension("fzf")
  end,
}
