 -- ## Include files in the subdirectories
 -- Open the composite file, in neovim if not already open
 -- Generated composite.md files compiling the tasks
 local api = vim.api
 local fn = vim.fn

 -- we need to fix the url to be shorter, so obsidan app can be aware
 local function list_todo_items()
   local todo_items = {}
   -- local compositefiledir = "/Users/imangodf/Documents/Obsidian/CommonPlace/composite.md"
   local compositeFileRegex = 'composite%.md$'
   local files = fn.globpath(api.nvim_eval("expand('%:p:h')"), "**", 1, 1)

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
   local output_file = io.open("composite.md", "w")
   if output_file == nil then return end

   for _, item in ipairs(todo_items) do
     local filename = vim.fn.fnamemodify(item.filepath, ':t')
     local shortFilename = string.gsub(filename, '%.md$', '')
     local shortFilenameMd = shortFilename .. ".md"
     -- output_file:write(string.format("##### [%s](%s)\n", shortFilename, item.filepath))
     output_file:write(string.format("##### [%s](%s)\n", shortFilename, shortFilenameMd))
     for _, todo in ipairs(item.todos) do
      output_file:write(string.format(" %s\n", todo))
     end
     output_file:write("\n")
   end
   output_file:close()

   local dir = vim.fn.getcwd()
   local files = vim.fn.glob(dir .. '/*composite.md')
   vim.api.nvim_command('edit ' .. files)
 end


 local function follow_link()
  --must be in the right format of link script should just fall off after <CR>

  -- extract filename from the current line
  local line_num = vim.fn.line('.')
  local line_text = vim.fn.getline(line_num)
  local filename = string.match(line_text, "%((.-)%)")

  if filename == nil then return end
  local target_path = vim.fn.fnamemodify(filename, ':p')

  -- check if the file exists
  if vim.fn.filereadable(target_path) == 1 then
    -- open the file in a new buffer
    vim.cmd('e ' .. target_path)
  else
    -- print('File not found: ' .. target_path)
  end
 end

 -- we could even convert the list_todo_items script into telescope picker
 return {
   list_todo_items = list_todo_items,
   follow_link = follow_link,
 }
