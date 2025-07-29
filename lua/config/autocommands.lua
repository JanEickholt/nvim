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
  local lines = {}
  for s in result:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end

  vim.api.nvim_command("vnew")
  local bufnr = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

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

      if result == nil then
        print("mvn generate failed!")
        return nil
      end

      local current_dir = vim.fn.getcwd()
      local file = io.open(current_dir .. "/" .. projectName .. "/" .. "Makefile", "w")
      if file then
        file:write(
          "all: \n"
          .. "\tmvn install\n"
          .. "\tjava -cp target/classes "
          .. packageName
          .. ".App\n"
          .. "verify: \n"
          .. "\tmvn verify\n"
          .. "validate: \n"
          .. "\tmvn validate\n"
          .. "package: \n"
          .. "\tmvn package\n"
          .. "test: \n"
          .. "\tmvn test\n"
        )
        file:close()
      else
        print("Failed to create Makefile")
      end
      vim.fn.chdir(current_dir .. "/" .. projectName)
      local oil = require("oil")
      oil.close()
      oil.open(vim.fn.getcwd())
      print(result)
    end, { desc = "Create a new Java project" })
  end,
  desc = "Create custom command 'CreateJavaProject' for Java files",
})

-- Diagnostic floating window on cursor hold
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--   group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
--   callback = function()
--     vim.diagnostic.open_float(nil, {
--       focus = false,
--       border = "rounded",
--     })
--   end,
-- })
