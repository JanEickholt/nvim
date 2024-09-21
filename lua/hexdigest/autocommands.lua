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

local write_to_buffer = function(result)
  -- Split the result into lines
  local lines = {}
  for s in result:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end

  -- Create a new buffer
  vim.api.nvim_command("vnew") -- This opens a new empty buffer
  local bufnr = vim.api.nvim_get_current_buf()

  -- Set the lines of the new buffer
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  -- Optionally, set the buffer to be not modifiable if it's meant to be read-only
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "hide")
  vim.api.nvim_buf_set_option(bufnr, "swapfile", false)
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

local check_maven_groupID = function(groupID)
  if not groupID then
    print("Failed to read pom.xml inside your project root(using mvn)")
    return false
  elseif groupID == "org.apache.maven" then
    print("Please enter nvim from your root project directory")
    return false
  end
  return true
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "JR", function()
      local groupID = get_maven_groupId()

      if not check_maven_groupID(groupID) then
        return
      end

      run_command(vim.fn.system(compiler_command), function()
        local result = vim.fn.system("java -cp target/classes " .. groupID .. ".App")
        write_to_buffer(result)
      end)
    end, { desc = "Compile and run Java project from Main" })
  end,
  desc = "Create custom command to compile and run Java projects",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "JRCustom", function()
      local groupID = get_maven_groupId()

      if not check_maven_groupID(groupID) then
        return
      end

      local javaFile = vim.fn.input("Custom file name(eg. main, test): ")

      run_command(vim.fn.system(compiler_command), function()
        local result = vim.fn.system("java -cp target/classes " .. groupID .. "." .. javaFile)
        write_to_buffer(result)
      end)
    end, { desc = "Compile and run Java project from a custom file" })
  end,
  desc = "Create custom command to compile and run Java projects",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "JRC", function()
      local groupID = get_maven_groupId()

      if not check_maven_groupID(groupID) then
        return
      end

      local fileName = vim.fn.expand("%:t"):match("(.+)%..+"):gsub("%s+", "")
      if not fileName then
        print("Failed to read file name")
        return
      end

      run_command(vim.fn.system(compiler_command), function()
        local result = vim.fn.system("java -cp target/classes " .. groupID .. "." .. fileName)
        write_to_buffer(result)
      end)
    end, { desc = "Compile and run Java project from the current file" })
  end,
  desc = "Create custom command to compile and run Java projects",
})

vim.api.nvim_create_autocmd("BufRead", {
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "JValidate", function()
      local groupID = get_maven_groupId()
      if not check_maven_groupID(groupID) then
        return
      end
      local result = vim.fn.system("mvn validate")
      write_to_buffer(result)
    end, { desc = "Validate current project" })
  end,
  desc = "Create custom command too validate MVN Projects",
})

vim.api.nvim_create_autocmd("BufRead", {
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "JPackage", function()
      local groupID = get_maven_groupId()
      if not check_maven_groupID(groupID) then
        return
      end
      local result = vim.fn.system("mvn package")
      write_to_buffer(result)
    end, { desc = "Packages current project into a .jar file" })
  end,
  desc = "Create custom command too package MVN projects",
})

vim.api.nvim_create_autocmd("BufRead", {
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "JTest", function()
      local groupID = get_maven_groupId()
      if not check_maven_groupID(groupID) then
        return
      end
      local result = vim.fn.system("mvn package")
      write_to_buffer(result)
    end, { desc = "Run the test suite of MVN in the current project" })
  end,
  desc = "Create custom command too package MVN projects",
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

local function handle_image_file()
  local filetype = vim.fn.expand("%:e")

  if filetype == "png" or filetype == "jpg" or filetype == "gif" then
    -- Open image file with sxiv
    vim.cmd("silent !nsxiv " .. vim.fn.expand("%"))

    -- Only close the current buffer
    vim.cmd("bd") -- Use buffer delete to close only the image buffer
  elseif filetype == "svg" then
    -- Open SVG source code on the side
    vim.cmd("vsplit")
    vim.cmd("edit " .. vim.fn.expand("%"))
    vim.cmd("terminal nsxiv " .. vim.fn.expand("%"))

    -- Close the terminal window after the command
    vim.cmd("q")
  end
end

-- Autocmd to handle files based on their type
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.png", "*.jpg", "*.gif", "*.svg" },
  callback = handle_image_file,
})
