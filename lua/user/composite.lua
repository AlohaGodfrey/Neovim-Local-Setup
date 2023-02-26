 -- ## Include files in the subdirectories
 -- Open the composite file, in neovim if not already open
 -- Generated composite.md files compiling the tasks
 local M = {}
 local api = vim.api
 local fn = vim.fn

 -- we need to fix the url to be shorter, so obsidan app can be aware
 function M.list_todo_items()
   local target_file_name = "Composite"
   local todo_items = {}
   -- local compositefiledir = "/Users/imangodf/Documents/Obsidian/CommonPlace/composite.md"
   local compositeFileRegex = target_file_name .. '%.md$'
   local files = fn.globpath(api.nvim_eval("expand('%:p:h')"), "**", 1, 1)

   -- Search all files for todo items
   for _, file in ipairs(files) do

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
   local base_path = vim.fn.expand('%:p:h')
   local target_path = base_path .. "/" .. target_file_name ..".md"
   -- local target_path = string.format("%s/%s.md", base_path, target_file_name)
   local output_file = io.open(target_path, "w")
   if output_file == nil then return end

   -- Write a title
   local directoryName = string.format("### %s \n \n", base_path:match(".*/(.*)"))
   output_file:write(directoryName)

   -- Fill in todo data
   for _, item in ipairs(todo_items) do
     local filename = vim.fn.fnamemodify(item.filepath, ':t')
     local shortFilename = string.gsub(filename, '%.md$', '')
     local shortFilenameMd = shortFilename .. ".md"
     -- output_file:write(string.format("##### [%s](%s)\n", shortFilename, item.filepath))
     -- output_file:write(string.format("##### [%s](%s)\n", shortFilename, shortFilenameMd))
     output_file:write(string.format("##### [[%s]]\n", shortFilename, shortFilenameMd))
     for _, todo in ipairs(item.todos) do
      output_file:write(string.format(" %s\n", todo))
     end
     output_file:write("\n")
   end
   output_file:close()

   -- Open composite file
   local glob_string = string.format("/*%s.md", target_file_name)
   local current_dir = vim.fn.getcwd()
   -- local target_file_path = vim.fn.glob(current_dir .. '/*Composite.md')
   local target_file_path = vim.fn.glob(current_dir .. glob_string)
   vim.api.nvim_command('edit ' .. target_file_path)
 end


 function M.follow_link()
  --must be in the right format of link script should just fall off after <CR>

  -- extract filename from the current line
  local line_num = vim.fn.line('.')
  local line_text = vim.fn.getline(line_num)

  -- check if filename is valid markdown format for obsidian i.e [[foo]]
  local check_filename = line_text:match("%[%[(.-)%]%]") -- matches the text between [[ and ]]
  if not check_filename then return end

  -- generate the filepath
  local relative_path = vim.fn.expand('%:p:h')
  local target_file_path = relative_path .. "/" .. check_filename .. ".md"

  -- check if the file exists
  if vim.fn.filereadable(target_file_path) == 1 then
    -- open the file in a new buffer
    vim.cmd('e ' .. target_file_path)
  end
 end

 -- we could even convert the list_todo_items script into telescope picker
 return M
