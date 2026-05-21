return {
	-- 1. Gitsigns: Отображение изменений слева и быстрый просмотр hunks
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
			current_line_blame = true, -- Показывать автора коммита в конце строки
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 500,
			},
			current_line_blame_formatter = "   <author> • <author_time:%Y-%m-%d>",
			preview_config = { border = "rounded" },

			on_attach = function(bufnr)
				local gs = require("gitsigns")

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- Навигация по изменениям (Hunks)
				map("n", "]h", function()
					gs.nav_hunk("next")
				end, "Next Hunk")
				map("n", "[h", function()
					gs.nav_hunk("prev")
				end, "Prev Hunk")

				-- Быстрые действия (Leader g)
				map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
				map("n", "<leader>ghi", gs.preview_hunk_inline, "Inline Diff")
				map("n", "<leader>ghd", gs.diffthis, "Diff View (Side-by-side)")
				map("n", "<leader>ghr", gs.reset_hunk, "Reset Hunk")
				map("n", "<leader>ghs", gs.stage_hunk, "Stage Hunk")
				map("n", "<leader>gtd", gs.toggle_deleted, "Toggle Deleted Lines")

				-- Полноценный всплывающий blame для текущей строки
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, "Git Blame (Popup)")
			end,
		},
	},

	-- 2. Git Conflict: Быстрое inline-разрешение конфликтов слияния
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = function()
			require("git-conflict").setup({
				default_mappings = false, -- Отключаем дефолтные клавиши, чтобы не залипала кнопка 'c'
				list_opener = "copen",
				disable_diagnostics = false,
				debug = false,
				highlights = {
					incoming = "DiffAdd",
					current = "DiffText",
				},
			})

			-- Удобные бесконфликтные keymap
			local map = vim.keymap.set
			map("n", "<leader>gco", "<cmd>GitConflictChooseOurs<cr>", { desc = "Choose Ours (Current)" })
			map("n", "<leader>gct", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Choose Theirs (Incoming)" })
			map("n", "<leader>gcb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Choose Both" })
			map("n", "<leader>gc0", "<cmd>GitConflictChooseNone<cr>", { desc = "Choose None" })
			map("n", "]x", "<cmd>GitConflictNextConflict<cr>", { desc = "Next Git Conflict" })
			map("n", "[x", "<cmd>GitConflictPrevConflict<cr>", { desc = "Prev Git Conflict" })
			map("n", "<leader>gcl", "<cmd>GitConflictListQf<cr>", { desc = "List Conflicts in Quickfix" })
		end,
	},

	-- 3. Diffview: Удобные side-by-side дифы и 3-way merge конфликтов
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
			{ "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
			{ "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (Current file)" },
			{ "<leader>gdH", "<cmd>DiffviewFileHistory<cr>", { desc = "Project Git History" } },
		},
		config = function()
			require("diffview").setup({
				enhanced_diff_hl = true,
			})
		end,
	},

	-- 4. Gitgraph: Красивый интерактивный Unicode-граф веток и коммитов
	{
		"isakbm/gitgraph.nvim",
		dependencies = { "sindrets/diffview.nvim" },
		keys = {
			{
				"<leader>gl",
				function()
					require("gitgraph").draw({}, { all = true, max_count = 5000 })
				end,
				desc = "GitGraph Show",
			},
		},
		opts = {
			symbols = {
				merge_commit = "●",
				commit = "○",
			},
			format = {
				timestamp = "%Y-%m-%d %H:%M:%S",
				fields = { "hash", "timestamp", "author", "branch_name", "tag_name", "message" },
			},
			hooks = {
				-- Интерактивное меню действий при нажатии Enter на коммите
				on_select_commit = function(commit)
					vim.ui.select({
						"1. Посмотреть изменения (Diffview)",
						"2. Перейти на этот коммит/ветку (Checkout)",
						"3. Сбросить коммиты с сохранением кода (Reset Soft)",
						"4. Сбросить коммиты и стереть код (Reset Hard)",
						"5. Создать новую ветку отсюда",
					}, {
						prompt = "Выберите действие для коммита "
							.. commit.hash:sub(1, 7)
							.. ":",
					}, function(choice)
						if not choice then
							return
						end

						if choice:match("1") then
							vim.cmd("DiffviewOpen " .. commit.hash .. "^!")
						elseif choice:match("2") then
							local handle = io.popen("git checkout " .. commit.hash .. " 2>&1")
							local result = handle:read("*a")
							handle:close()
							vim.notify(result, vim.log.levels.INFO)
							require("gitgraph").draw({}, { all = true, max_count = 5000 })
						elseif choice:match("3") then
							vim.ui.input({
								prompt = "Вы уверены, что хотите сделать reset --soft? (y/n): ",
							}, function(confirm)
								if confirm == "y" then
									local handle = io.popen("git reset --soft " .. commit.hash .. " 2>&1")
									local result = handle:read("*a")
									handle:close()
									vim.notify(result, vim.log.levels.INFO)
									require("gitgraph").draw({}, { all = true, max_count = 5000 })
								end
							end)
						elseif choice:match("4") then
							vim.ui.input({
								prompt = "ВНИМАНИЕ: Сбросить все изменения (reset --hard)? (y/n): ",
							}, function(confirm)
								if confirm == "y" then
									local handle = io.popen("git reset --hard " .. commit.hash .. " 2>&1")
									local result = handle:read("*a")
									handle:close()
									vim.notify(result, vim.log.levels.INFO)
									require("gitgraph").draw({}, { all = true, max_count = 5000 })
								end
							end)
						elseif choice:match("5") then
							vim.ui.input(
								{ prompt = "Введите имя новой ветки: " },
								function(branch_name)
									if branch_name and branch_name ~= "" then
										local handle =
											io.popen("git branch " .. branch_name .. " " .. commit.hash .. " 2>&1")
										local result = handle:read("*a")
										handle:close()
										vim.notify(result, vim.log.levels.INFO)
										require("gitgraph").draw({}, { all = true, max_count = 5000 })
									end
								end
							)
						end
					end)
				end,
			},
		},
		config = function(_, opts)
			require("gitgraph").setup(opts)

			-- Настройка автозакрытия графа по нажатию клавиши 'q'
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "gitgraph",
				callback = function(event)
					vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
				end,
			})
		end,
	},
}
