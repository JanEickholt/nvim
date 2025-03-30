return {
	"mfussenegger/nvim-dap",
	recommended = true,
	desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

	dependencies = {
		"rcarriga/nvim-dap-ui",
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},
	},

  -- stylua: ignore
  keys = {
    { "<leader>d",  "",                                                                                   desc = "+debug",                 mode = { "n", "v" } },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end,                                             desc = "Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end,                        desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end,                                                desc = "Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end,                                                 desc = "Down" },
    { "<leader>dk", function() require("dap").up() end,                                                   desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end,                                             desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end,                                             desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end,                                            desc = "Step Over" },
    { "<leader>dp", function() require("dap").pause() end,                                                desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end,                                              desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
  },

	config = function()
		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
		vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "red", linehl = "", numhl = "" })

		local dap = require("dap")
		dap.adapters.cpp = {
			type = "server",
			port = "${port}",
			executable = {
				command = "/home/user/.local/share/nvim/mason/bin/codelldb",
				args = { "--port", "${port}" },
			},
		}
		dap.configurations.cpp = {
			{
				name = "lldb",
				type = "cpp",
				request = "launch",
				args = function()
					local args_string = vim.fn.input("Arguments: ")
					return vim.split(args_string, " ")
				end,
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				externalTerminal = false,
				stopOnEntry = true,
			},
		}
		dap.configurations.c = dap.configurations.cpp
		dap.configurations.rust = dap.configurations.cpp
	end,
}
