local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes TODO
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
-- keymap("n", "<C-h>", "<C-w>h", opts)
-- keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<S-h>", "<C-w>h", opts)
keymap("n", "<S-l>", "<C-w>l", opts)


-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
-- keymap("n", "<S-l>", ":bnext<CR>", opts)
-- keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<C-l>", ":bnext<CR>", opts)
keymap("n", "<C-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to exit insert mode 
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "p", '"_dP', opts)
keymap("v", "<C-j>", ":m .+1<CR>==", opts)
keymap("v", "<C-k>", ":m .-2<CR>==", opts)
-- keymap("v", "<A-j>", ":m .+1<CR>==", opts)
-- keymap("v", "<A-k>", ":m .-2<CR>==", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<C-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<C-k>", ":move '<-2<CR>gv-gv", opts)
-- keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
-- keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Hop Plugin --
-- keymap("n", "t", ":HopLine <CR>", opts)
-- keymap("n", "T", ":HopWord <CR>", opts)
keymap("n", "<C-m>", ":HopWord <CR>", opts)
-- Had to remove "f" as it blocked on alpha plugin
keymap("n", "F", ":HopWordCurrentLine <CR>", opts)

-- Toggle Telekasten Todo 
keymap("n", "<C-x>", ":Telekasten toggle_todo<CR>", opts)
keymap("v", "<C-x>", ":'<,'> Telekasten toggle_todo<CR>", opts)

-- Composite custom script to follow markdown links
keymap("n", "<CR>", ":lua require('user.composite').follow_link()<CR>", opts)

-- Shortcut to bring back last/lost buffers
keymap("n", "<C-BS>", ":edit #<CR>", opts)

-- Aerial shortcut to jump to next heading
keymap("n", "<C-[>", ":lua require('aerial').prev(step)<CR>", opts)
keymap("n", "<C-]>", ":lua require('aerial').next(step)<CR>", opts)

-- Prevent plugins(like aerial) from hijacking the key
keymap("n", "<ESC>", "<ESC>", opts)

-- Remap which-key spellchecker to Ctrl-i
require("which-key.keys").register({ ["<C-i>"] = {"spelling", plugin = "spelling" } }, { mode = "n"} )
-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
