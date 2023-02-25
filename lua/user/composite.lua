 -- ## Include files in the subdirectories
 -- Open the composite file, in neovim if not already open
 -- Generated composite.md files compiling the tasks
 local api = vim.api
 local fn = vim.fn

 local function list_todo_items()
   local todo_items = {}
   -- local compositefiledir = "/Users/imangodf/Documents/Obsidian/CommonPlace/composite.md"
   local compositeFileRegex = 'composite%.md$'
   local files = fn.globpath(api.nvim_eval("expand('%:p:h')"), "**", 1, 1)
   for _, file in ipairs(files) do
     -- if file ~= compositefiledir and fn.filereadable(file) == 1 then
     if not string.match(file, compositeFileRegex) and fn.filereadable(file) == 1 then
       local lines = api.nvim_call_function("readfile", {file})
       local file_todos = {}
       for _, line in ipairs(lines) do
         if string.match(line, "^%s*%- %[[x ]%]") then
           table.insert(file_todos, line)
         end
       end

       --Sort the tables content by list '- [ ]' first
       table.sort(file_todos)

       -- Append todo_items list with file_todos list
       if next(file_todos) ~= nil then
         table.insert(todo_items, {filepath = file, todos = file_todos})
       end
     end
   end

    -- close any open composite.md buffers
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
      -- if vim.api.nvim_buf_get_name(buffer) == compositefiledir then
      if string.match(vim.api.nvim_buf_get_name(buffer), compositeFileRegex) then
        vim.api.nvim_command('bwipeout!' .. buffer)
      end
    end

   -- write to the composite file
   local output_file = io.open("composite.md", "w")
   for _, item in ipairs(todo_items) do

     -- format title
     -- output_file:write(string.format("## %s\n", item.filepath))
     -- output_file:write(string.format("## %s\n", vim.fn.fnamemodify(item.filepath, ':t')))
     local filename = vim.fn.fnamemodify(item.filepath, ':t')
     local shortFilename = string.gsub(filename, '%.md$', '')
     output_file:write(string.format("[%s](%s)\n",  shortFilename, item.filepath))

     for _, todo in ipairs(item.todos) do
       output_file:write(string.format(" %s\n", todo))
     end
     output_file:write("\n")
   end
   output_file:close()

   -- open the file
   -- │ local dir = vim.fn.getcwd()
   --   local files = vim.fn.glob(dir .. '/*composite.md')
   -- │ if #files > 0 then
   -- │   print('File ending in composite.md found in current working directory')
   -- │ else
   -- │   print('No file ending in composite.md found in current working directory')
   -- │ end
   local dir = vim.fn.getcwd()
   local files = vim.fn.glob(dir .. '/*composite.md')
   -- vim.api.nvim_command('edit ' .. compositefiledir)
   vim.api.nvim_command('edit ' .. files)
 end

 return {
   list_todo_items = list_todo_items,
 }

-- ## Markdown Group Fomatting
-- local api = vim.api
-- local fn = vim.fn
--
-- local function list_todo_items()
--   local todo_items = {}
--   local files = fn.globpath(api.nvim_eval("expand('%:p:h')"), "*", 0, 1)
--   for _, file in ipairs(files) do
--     if fn.filereadable(file) == 1 then
--       local lines = api.nvim_call_function("readfile", {file})
--       local file_todos = {}
--       for _, line in ipairs(lines) do
--         if string.match(line, "^%s*%- %[%s*x%s*%]") then
--           table.insert(file_todos, line)
--         end
--       end
--       if next(file_todos) ~= nil then
--         table.insert(todo_items, {filename = file, todos = file_todos})
--       end
--     end
--   end
--   local output_file = io.open("composite.md", "w")
--   for _, item in ipairs(todo_items) do
--     output_file:write(string.format("## %s\n", item.filename))
--     for _, todo in ipairs(item.todos) do
--       output_file:write(string.format("- %s\n", todo))
--     end
--     output_file:write("\n")
--   end
--   output_file:close()
-- end
--
-- return {
--   list_todo_items = list_todo_items,
-- }

-- ## print out todo_items in a local composite.md file
-- local api = vim.api
-- local fn = vim.fn
--
-- local function list_todo_items()
--   local todo_items = {}
--   local files = fn.globpath(api.nvim_eval("expand('%:p:h')"), "*", 0, 1)
--   for _, file in ipairs(files) do
--     if fn.filereadable(file) == 1 then
--       local lines = api.nvim_call_function("readfile", {file})
--       for _, line in ipairs(lines) do
--         if string.match(line, "^%s*%- %[%s*x%s*%]") then
--           table.insert(todo_items, {filename = file, line = line})
--         end
--       end
--     end
--   end
--   local output_file = io.open("composite.md", "w")
--   for _, item in ipairs(todo_items) do
--     output_file:write(string.format("%s: %s\n", item.filename, item.line))
--   end
--   output_file:close()
-- end
--
-- return {
--   list_todo_items = list_todo_items,
-- }

-- ## print todo_items in folder
-- local api = vim.api
-- local fn = vim.fn
--
-- local function list_todo_items()
--   local todo_items = {}
--   local files = fn.globpath(api.nvim_eval("expand('%:p:h')"), "*", 0, 1)
--   for _, file in ipairs(files) do
--     if fn.filereadable(file) == 1 then
--       local lines = api.nvim_call_function("readfile", {file})
--       for _, line in ipairs(lines) do
--         if string.match(line, "^%s*%- %[%s*x%s*%]") then
--           table.insert(todo_items, {filename = file, line = line})
--         end
--       end
--     end
--   end
--   return todo_items
-- end
--
-- return {
--   list_todo_items = list_todo_items,
-- }

-- ## print todo_items
-- local api = vim.api
--
-- local function list_todo_items()
--   local todo_items = {}
--   local bufnr = api.nvim_get_current_buf()
--   local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
--   for _, line in ipairs(lines) do
--     if string.match(line, "^%s*%- %[%s*x%s*%]") then
--       table.insert(todo_items, line)
--     end
--   end
--   return todo_items
-- end
--
-- return {
--   list_todo_items = list_todo_items,
-- }

-- ## highlight todo_items
-- local api = vim.api
--
-- local function find_todo_items()
--   local bufnr = api.nvim_get_current_buf()
--   local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
--   local todo_items = {}
--   for i, line in ipairs(lines) do
--     if string.match(line, "^%s*%- %[%s*x%s*%]") then
--       table.insert(todo_items, {line = line, line_number = i})
--     end
--   end
--   return todo_items
-- end
--
-- local function highlight_todo_items()
--   local todo_items = find_todo_items()
--   for _, item in ipairs(todo_items) do
--     api.nvim_buf_add_highlight(0, -1, "Todo", item.line_number - 1, 0, -1)
--   end
-- end
--
-- return {
--   find_todo_items = find_todo_items,
--   highlight_todo_items = highlight_todo_items,
-- }
--
