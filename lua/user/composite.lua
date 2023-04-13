 -- ## Include files in the subdirectories
 -- Open the composite file, in neovim if not already open
 -- Generated composite.md files compiling the tasks
 local M = {}
 local api = vim.api
 local fn = vim.fn

 function M.list_todo_items()

   local target_file_name = "Composite"
   local composite_table = {}
   local compositeFileRegex = target_file_name .. '%.md$'

   -- Search all files for todo items
   M.return_list_todo_table(compositeFileRegex, composite_table)

   -- M.print_nested_table(composite_table, 2)
   M.write_to_file(target_file_name, composite_table)

   -- Open composite file
   local current_dir = vim.fn.expand('%:p:h')
   local target_file_path = string.format("%s/%s.md", current_dir, target_file_name)
   vim.api.nvim_command('edit ' .. target_file_path)
 end

 function M.write_to_file(target_file_name, composite_table)

   -- write to the composite file
   local base_path = vim.fn.expand('%:p:h')
   local target_path = base_path .. "/" .. target_file_name ..".md"
   local output_file = io.open(target_path, "w")
   if output_file == nil then return end

   -- Write a title
   local directoryName = string.format("### %s \n \n", base_path:match(".*/(.*)"))
   output_file:write(directoryName)

   -- Fill in todo data
   for _, item in ipairs(composite_table) do
     local filename = vim.fn.fnamemodify(item.filepath, ':t')
     local shortFilename = string.gsub(filename, '%.md$', '')
     local shortFilenameMd = shortFilename .. ".md"
     output_file:write(string.format("##### [[%s]]\n", shortFilename, shortFilenameMd))
     for _, todo in ipairs(item.todo_list) do
      output_file:write(string.format(" %s\n", todo))
     end
     output_file:write("\n")
   end
   output_file:close()
 end

 function M.return_list_todo_table(compositeFileRegex, composite_table)

   -- Search all files for todo items
   local files = fn.globpath(api.nvim_eval("expand('%:p:h')"), "**", 1, 1)
   for _, file in ipairs(files) do

     if not string.match(file, compositeFileRegex) and fn.filereadable(file) == 1 then
       local lines = api.nvim_call_function("readfile", {file})
       local todo_items = {}
       for _, line in ipairs(lines) do
         if string.match(line, "^%s*%- %[[x ]%]") then
           table.insert(todo_items, line)
         end
       end
       --Sort the tables content by list '- [ ]' first
       table.sort(todo_items)
       -- Append todo_items list with file_todos list
       if next(todo_items) ~= nil then
         table.insert(composite_table, {filepath = file, todo_list = todo_items})
       end
     end
   end
 end

 function M.follow_link()

  local workspaces = {
    ["commonplace"]  = "/Users/imangodf/Documents/Obsidian/CommonPlace",
    ["workplace"]  = "/Users/imangodf/workplace",
    ["aws"]  = "/Users/imangodf/Documents/Obsidian/AWS",
    ["nvim"] = "/Users/imangodf/.config/nvim",
  }
  --must be in the right format of link script should just fall off after <CR>
  -- extract filename from the current line
  local line_num = vim.fn.line('.')
  local line_text = vim.fn.getline(line_num)

  -- check if filename is valid markdown format for obsidian i.e [[foo]]
  local check_filename = line_text:match("%[%[(.-)%]%]") -- matches the text between [[ and ]]
  if not check_filename then return end

  -- specify the directory to search in
  local directoryPath = workspaces[Calculate_frecency_cwd()]
  if directoryPath == "CWD" then
    -- generate a relative filepath
    local relative_path = vim.fn.expand('%:p:h')
    local target_file_path = relative_path .. "/" .. check_filename .. ".md"
  end
  local filename = check_filename .. ".md"
  -- use the 'find' command to search for the file
  local command = "find " .. directoryPath .. " -name '" .. filename .. "'"

  local handle = io.popen(command)
  if handle ~= nil then
    local target_file_path = handle:read("*a")
    handle:close()
    -- check if the file was found
    if target_file_path ~= "" then
      -- Text needed to be surround by qoutes before operation
      local sanitiseText = target_file_path:gsub("%s*$", "")
      -- check if the file exists
      if vim.fn.filereadable(sanitiseText) == 1 then
        -- open the file in a new buffer
        vim.cmd('e ' .. target_file_path)
      end
    else
      print("File not found.")
    end
  end
 end

 function M.bidirectional_update()
    -- Cancelled update, will resume if I have time
    -- All we need to do is compare the tables, and overwrite the changes.
    -- Can't lie let me admit defeat, wasn't worth upgrading just revert
    -- file will grab updates from the composite.md file and propagate them to source upon write
    -- composite.md is a Transient file, lets just focus on propagating the status from done to undone

    -- Read composite file and sort into lists
    -- Capture the files and todos
    -- Compare and apply updates

    -- Open the file for reading
    -- local file = io.open("Composite.md", "r")

    local target_file_name = "Composite"
    local base_path = vim.fn.expand('%:p:h')
    local target_path = base_path .. "/" .. target_file_name ..".md"
    -- Initialize the todo_items table
    local composite_table = {}
    local file = io.open(target_path, "r")
    if file == nil then
      print("File Not Found")
      return
    end

   -- nested do-while loops one for filepath, another for todo_items
    while true do
      local line = file:read()
      local todo_items = {}
      if line == nil then
        break
      end

      -- local filepath_match = string.match(line,"^#+%s*(%[%[.+%]%])%s*$")
      local filepath_match = string.match(line,"%[%[(.-)%]%]")
      if filepath_match then
        local filename = vim.fn.expand('%:p:h') .. "/" .. filepath_match .. ".md"
        local todo_line = file:read()
        local todo_item = string.match(todo_line, "^%s*%- %[[x ]%].+$")
        while todo_item do
          table.insert(todo_items, todo_item)
          todo_line = file:read()
          if todo_line == nil then
            break
          end
          todo_item = string.match(todo_line, "^%s*%- %[[x ]%].+$")
        end
        table.insert(composite_table, {filepath = filename, todo_list = todo_items})
      end
    end
    -- Close the file
    file:close()

    -- Print the todo_items table for testing
    M.print_nested_table(composite_table, 2)

    -- Compare against the other tables
    local compositeFileRegex = 'Composite%.md$'
    local list_todo_table_cpy
    M.return_list_todo_table(compositeFileRegex, list_todo_table_cpy)
    M.print_nested_table(list_todo_table_cpy, 2)
    
    -- If there are any difference, find the item, and toggle the check box
 end

 function M.print_nested_table(tbl, indent)

    indent = indent or 0
    for k, v in pairs(tbl) do
      if type(v) == "table" then
        print(string.rep("  ", indent) .. k .. ":")
        M.print_nested_table(v, indent + 1)
      else
        print(string.rep("  ", indent) .. k .. ": " .. tostring(v))
      end
    end
 end

 function M.rewrap_file()

  local max_line_length = 92
  -- Get the contents of the current buffer
  local contents = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')

  -- Split the contents into lines
  local lines = {}
  for line in contents:gmatch("(.-)\r?\n") do
    table.insert(lines, line)
  end

  -- Rewrap each line, skipping URLs
  for i, line in ipairs(lines) do
    -- Check if the line is a URL (starts with http:// or https://)
    local is_url = line:find("^https?://") ~= nil
    
    if not is_url then
      local new_lines = {}
      while #line > max_line_length do
        local split_point = line:sub(1, max_line_length):find("%s[^%s]*$")
        if not split_point then
          split_point = max_line_length
        end
        table.insert(new_lines, line:sub(1, split_point))
        line = line:sub(split_point + 1)
      end
      table.insert(new_lines, line)
      lines[i] = table.concat(new_lines, '\n')
    end
  end

  -- Write the new contents back to the buffer
  local new_contents = table.concat(lines, '\n')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(new_contents, '\n'))
 end

  
 -- we could even convert the list_todo_items script into telescope picker
 return M
