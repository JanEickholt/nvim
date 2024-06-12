function IS_GIT_REPO()
  local f = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
  if not f then
    return false
  end
  local git_repo = f:read("*all")
  f:close()
  if git_repo:match("true") then
    return true
  else
    return false
  end
end

function GET_CONTEXT()
  local depth = vim.env.NVDEPTH or 4
  if not IS_GIT_REPO() then
    return false
  end

  local lines = {}

  local p = io.popen("git rev-parse --show-toplevel")
  if not p then
    return false
  end
  local git_root = p:read("*all"):gsub("\n", "")
  p:close()
  local cmd = "find " .. git_root .. " -maxdepth " .. depth .. " -type f"
  local files = io.popen(cmd):lines()

  for file in files do
    if file:match(".git") then
      goto continue
    end
    if file:match("node_modules") then
      goto continue
    end
    local f = io.open(file, "r")
    if not f then
      return false
    end
    local content = f:read("*all"):gsub("\n", "")
    if content ~= nil then
      f:close()
      print(content)
      table.insert(lines, file .. " has the content: " .. content)
    end
    ::continue::
  end
  local line_string = ""
  for line in lines do
    line_string = line_string .. line .. "\n"
  end
  return line_string
end

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  cmd = "CopilotChat",
  opts = function()
    local user = vim.env.NVUSER or "User"
    user = user:sub(1, 1):upper() .. user:sub(2)
    return {
      model = "gpt-4",
      context = "buffers",
      auto_insert_mode = true,
      show_help = true,
      question_header = "  " .. user .. " ",
      answer_header = "  Copilot ",
      window = {
        width = 0.4,
      },
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.buffer(source)
      end,
    }
  end,
  keys = {
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    {
      "<leader>aa",
      function()
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>ax",
      function()
        return require("CopilotChat").reset()
      end,
      desc = "Clear (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>aq",
      function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input)
        end
      end,
      desc = "Quick Chat (CopilotChat)",
      mode = { "n", "v" },
    },
  },
  config = function(_, opts)
    local chat = require("CopilotChat")
    require("CopilotChat.integrations.cmp").setup()

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-chat",
      callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
      end,
    })

    chat.setup(opts)
  end,
}
