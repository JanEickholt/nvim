-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
--

local compiler_command = "mvn compile"

local run_command = function(cmd, callback)
  vim.fn.jobstart(cmd, {
    on_exit = function()
      if callback then
        callback()
      end
    end,
  })
end

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
    vim.api.nvim_buf_create_user_command(0, "JR", function()
      local groupID = get_maven_groupId()

      if not groupID then
        print("Failed to read pom.xml inside your project root(using mvn)")
      elseif groupID == "org.apache.maven" then
        print("Please enter nvim from your root project directory")
        return
      end
      run_command(vim.fn.system(compiler_command), function()
        local result = vim.fn.system("java -cp target/classes " .. groupID .. ".Main")
        print(result)
      end)
    end, { desc = "Compile and run Java project from Main" })
  end,
  desc = "Create custom command to compile and run Java projects",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "JRCustom", function()
      local groupID = get_maven_groupId()

      if not groupID then
        print("Failed to read pom.xml inside your project root(using mvn)")
      elseif groupID == "org.apache.maven" then
        print("Please enter nvim from your root project directory")
        return
      end

      local javaFile = vim.fn.input("Custom file name(eg. main, test): ")

      run_command(vim.fn.system(compiler_command), function()
        local result = vim.fn.system("java -cp target/classes " .. groupID .. "." .. javaFile)
        print(result)
      end)
    end, { desc = "Compile and run Java project from a custom file" })
  end,
  desc = "Create custom command to compile and run Java projects",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "JRC", function()
      local groupID = get_maven_groupId()

      if not groupID then
        print("Failed to read pom.xml inside your project root(using mvn)")
      elseif groupID == "org.apache.maven" then
        print("Please enter nvim from your root project directory")
        return
      end
      local fileName = vim.fn.expand("%:t"):match("(.+)%..+"):gsub("%s+", "")
      if not fileName then
        print("Failed to read file name")
        return
      end

      run_command(vim.fn.system(compiler_command), function()
        local result = vim.fn.system("java -cp target/classes " .. groupID .. "." .. fileName)
        print(result)
      end)
    end, { desc = "Compile and run Java project from the current file" })
  end,
  desc = "Create custom command to compile and run Java projects",
})

vim.api.nvim_create_autocmd("BufRead", {
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "CreateJavaProject", function()
      local projectName = vim.fn.input("Enter Project Name: ")
      local packageName = vim.fn.input("Enter Package Name: ")

      local result = vim.fn.system(
        "mvn archetype:generate -DgroupId="
          .. packageName
          .. " -DartifactId="
          .. projectName
          .. " -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false"
      )
      print(result)
    end, { desc = "Create a new Java project" })
  end,
  desc = "Create custom command 'CreateJavaProject' for Java files",
})
