-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
--
local get_maven_groupId = function()
  local handle = io.popen("mvn help:evaluate -Dexpression=project.groupId -q -DforceStdout")
  if not handle then
    return nil
  end
  local result = handle:read("*a")
  handle:close()
  return result:gsub("%s+", "")
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "JdtRun", function()
      local groupID = get_maven_groupId()
      if not groupID then
        print("Failed to read pom.xml inside your project root(using mvn)")
      elseif groupID == "org.apache.maven" then
        print("Please enter nvim from your root project directory")
        return
      end
      local result = vim.fn.system("java -cp target/classes " .. groupID .. ".App")
      print(result)
    end, { desc = "Compile and run Java project" })
  end,
  desc = "Create custom command 'JdtCompile' for Java files",
})
