return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      -- basic telescope configuration
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)

          local make_finder = function()
              local paths = {}
              for _, item in ipairs(harpoon_files.items) do
                  table.insert(paths, item.value)
              end
              return require("telescope.finders").new_table({ results = paths })
          end

          require("telescope.pickers").new({}, {
              prompt_title = "Harpoon",
              finder = make_finder(),
              previewer = conf.file_previewer({}),
              sorter = conf.generic_sorter({}),
              attach_mappings = function(prompt_buffer_number, map)
                  map("n", "d", function()
                      local state = require("telescope.actions.state")
                      local selected_entry = state.get_selected_entry()
                      local current_picker = state.get_current_picker(prompt_buffer_number)

                      harpoon:list():remove_at(selected_entry.index)
                      current_picker:refresh(make_finder())
                  end)

                  return true
              end
          }):find()

      end

      -- keybindings
      require("which-key").register({
          ["<leader>ha"] = { function() harpoon:list():add() end, "Add file to Harpoon" },
          ["<leader>hh"] = { function() toggle_telescope(harpoon:list()) end, "Open Harpoon Window" },
      })
    end,
}
