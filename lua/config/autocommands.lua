-- Java project creation (task runner moved to overseer.nvim templates)
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
