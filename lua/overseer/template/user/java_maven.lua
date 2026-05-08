local overseer = require("overseer")

-- Helper to get Maven groupId from pom.xml
local function get_maven_groupId()
	local handle = io.popen("mvn help:evaluate -Dexpression=project.groupId -q -DforceStdout 2>/dev/null")
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()
	return result:gsub("%s+", "")
end

-- Helper to check if we're in a Maven project
local function is_maven_project(dir)
	local pom_path = dir .. "/pom.xml"
	return vim.fn.filereadable(pom_path) == 1
end

---@type overseer.TemplateFileProvider
return {
	generator = function(opts)
		if not is_maven_project(opts.dir) then
			return {}
		end

		local tasks = {}

		-- Maven Compile
		table.insert(tasks, {
			name = "Maven Compile",
			desc = "Compile the Maven project",
			tags = { overseer.TAG.BUILD },
			builder = function()
				return {
					cmd = { "mvn" },
					args = { "compile" },
					components = {
						{ "on_output_quickfix", open_on_exit = "failure" },
						"default",
					},
				}
			end,
		})

		-- Maven Test
		table.insert(tasks, {
			name = "Maven Test",
			desc = "Run the Maven test suite",
			tags = { overseer.TAG.TEST },
			builder = function()
				return {
					cmd = { "mvn" },
					args = { "test" },
					components = {
						{ "on_output_quickfix", open_on_exit = "failure" },
						"default",
					},
				}
			end,
		})

		-- Maven Package
		table.insert(tasks, {
			name = "Maven Package",
			desc = "Package the project into a JAR file",
			tags = { overseer.TAG.BUILD },
			builder = function()
				return {
					cmd = { "mvn" },
					args = { "package", "-DskipTests" },
					components = {
						{ "on_output_quickfix", open_on_exit = "failure" },
						"default",
					},
				}
			end,
		})

		-- Maven Clean
		table.insert(tasks, {
			name = "Maven Clean",
			desc = "Clean the Maven project",
			tags = { overseer.TAG.BUILD },
			builder = function()
				return {
					cmd = { "mvn" },
					args = { "clean" },
					components = {
						"default",
					},
				}
			end,
		})

		-- Maven Clean + Compile
		table.insert(tasks, {
			name = "Maven Clean Compile",
			desc = "Clean and compile the Maven project",
			tags = { overseer.TAG.BUILD },
			builder = function()
				return {
					cmd = { "mvn" },
					args = { "clean", "compile" },
					components = {
						{ "on_output_quickfix", open_on_exit = "failure" },
						"default",
					},
				}
			end,
		})

		-- Run Java Main Class
		table.insert(tasks, {
			name = "Java Run Main",
			desc = "Compile and run the main class (App.java)",
			tags = { overseer.TAG.RUN },
			builder = function()
				local groupId = get_maven_groupId()
				local mainClass = groupId and (groupId .. ".App") or "App"
				return {
					cmd = { "mvn" },
					args = { "exec:java", "-Dexec.mainClass=" .. mainClass },
					components = {
						{ "on_output_quickfix", open_on_exit = "failure" },
						"default",
					},
				}
			end,
		})

		-- Run Custom Java Class
		table.insert(tasks, {
			name = "Java Run Class",
			desc = "Compile and run a specific Java class",
			tags = { overseer.TAG.RUN },
			params = {
				className = {
					desc = "Class name (without package, e.g., 'Main', 'Test')",
					type = "string",
					default = "App",
				},
			},
			builder = function(params)
				local groupId = get_maven_groupId()
				local mainClass = groupId and (groupId .. "." .. params.className) or params.className
				return {
					cmd = { "mvn" },
					args = { "exec:java", "-Dexec.mainClass=" .. mainClass },
					components = {
						{ "on_output_quickfix", open_on_exit = "failure" },
						"default",
					},
				}
			end,
		})

		-- Run Current File
		table.insert(tasks, {
			name = "Java Run Current File",
			desc = "Compile and run the currently open Java file",
			tags = { overseer.TAG.RUN },
			builder = function()
				local groupId = get_maven_groupId()
				local currentFile = vim.fn.expand("%:t:r") -- filename without extension
				local mainClass = groupId and (groupId .. "." .. currentFile) or currentFile
				return {
					cmd = { "mvn" },
					args = { "exec:java", "-Dexec.mainClass=" .. mainClass },
					components = {
						{ "on_output_quickfix", open_on_exit = "failure" },
						"default",
					},
				}
			end,
		})

		-- Maven Validate
		table.insert(tasks, {
			name = "Maven Validate",
			desc = "Validate the Maven project structure",
			tags = { overseer.TAG.BUILD },
			builder = function()
				return {
					cmd = { "mvn" },
					args = { "validate" },
					components = {
						"default",
					},
				}
			end,
		})

		-- Spring Boot Run (if spring-boot-maven-plugin exists)
		table.insert(tasks, {
			name = "Spring Boot Run",
			desc = "Run Spring Boot application",
			tags = { overseer.TAG.RUN },
			builder = function()
				return {
					cmd = { "mvn" },
					args = { "spring-boot:run" },
					components = {
						{ "on_output_quickfix", open_on_exit = "failure" },
						"default",
					},
				}
			end,
		})

		return tasks
	end,
	cache_key = function(opts)
		return opts.dir
	end,
}
