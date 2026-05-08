-- Java Language Server Configuration using nvim-jdtls
-- This file is automatically loaded for Java files

local jdtls = require("jdtls")
local mason_path = vim.fn.stdpath("data") .. "/mason/packages"

-- Determine project name and workspace directory
local root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
local project_name = vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name

-- Determine OS-specific config directory
local config_dir = "config_linux"
if vim.fn.has("mac") == 1 then
  config_dir = "config_mac"
elseif vim.fn.has("win32") == 1 then
  config_dir = "config_win"
end

-- Setup bundles for debugging and testing
local bundles = {
  vim.fn.glob(mason_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
}

-- Add java-test bundles for JUnit support
vim.list_extend(
  bundles,
  vim.split(vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", true), "\n")
)

-- JDTLS configuration
local config = {
  -- The command to start the Java language server
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx4g", -- Allocate 4GB memory for large projects
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    
    -- Path to eclipse.jdt.ls launcher
    "-jar", vim.fn.glob(mason_path .. "/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", true),
    
    -- Platform-specific configuration
    "-configuration", mason_path .. "/jdtls/" .. config_dir,
    
    -- Workspace directory (prevents re-indexing on restart)
    "-data", workspace_dir,
  },
  
  -- Root directory detection
  root_dir = root_dir,
  
  -- Initialize bundles for debugging
  init_options = {
    bundles = bundles,
  },
  
  -- Java-specific settings
  settings = {
    java = {
      -- Don't pollute project with Eclipse metadata
      eclipse = {
        downloadSources = true,
      },
      
      -- Configuration settings
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      
      -- Maven settings
      maven = {
        downloadSources = true,
        updateSnapshots = false,
      },
      
      -- Code generation preferences
      codeGeneration = {
        toString = {
          template = "${object.className} ${object.fieldNames}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
      },
      
      -- Completion settings
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
        },
        importOrder = { "java", "javax", "com", "org" },
      },
      
      -- Inlay hints
      inlayHints = {
        parameterNames = {
          enabled = "all", -- 'none', 'literals', 'all'
          exclusions = { "String" },
        },
      },
      
      -- Save actions
      saveActions = {
        organizeImports = true,
      },
    },
  },
  
  -- On attach: setup keymaps and DAP
  on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }
    
    -- Organize imports
    vim.keymap.set("n", "<A-o>", function()
      jdtls.organize_imports()
    end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
    
    -- Extract variable
    vim.keymap.set("n", "<leader>ev", function()
      jdtls.extract_variable()
    end, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
    
    -- Extract constant
    vim.keymap.set("n", "<leader>ec", function()
      jdtls.extract_constant()
    end, vim.tbl_extend("force", opts, { desc = "Extract constant" }))
    
    -- Extract method (visual mode)
    vim.keymap.set("v", "<leader>em", function()
      jdtls.extract_method(true)
    end, vim.tbl_extend("force", opts, { desc = "Extract method" }))
    
    -- Test runner
    vim.keymap.set("n", "<leader>df", function()
      jdtls.test_class()
    end, vim.tbl_extend("force", opts, { desc = "Debug test class" }))
    
    vim.keymap.set("n", "<leader>dn", function()
      jdtls.test_nearest_method()
    end, vim.tbl_extend("force", opts, { desc = "Debug nearest test" }))
    
    -- Setup DAP
    jdtls.setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()
    
    -- Refresh code lens
    vim.lsp.codelens.refresh()
    vim.lsp.codelens.refresh({ bufnr = bufnr })
  end,
}

-- Start or attach to language server
jdtls.start_or_attach(config)
