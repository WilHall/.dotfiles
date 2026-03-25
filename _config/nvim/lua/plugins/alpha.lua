return {
  {
    "goolord/alpha-nvim",
    dependencies = {
      "echasnovski/mini.icons",
    },
    config = function()
      local alpha = require("alpha")
      local startify = require("alpha.themes.startify")

      local custom_dirs = {
        { shortcut = "a", label = "Controllers/Admin", dir = "app/controllers/admin" },
        { shortcut = "b", label = "Admin/Views", dir = "app/views/admin" },
        { shortcut = "c", label = "Users", dir = "app/controllers/users" },
      }

      local function dir_buttons()
        local tbl = {}
        for _, d in ipairs(custom_dirs) do
          local cmd = ":cd " .. d.dir .. " | Telescope find_files<CR>"
          table.insert(tbl, startify.button(d.shortcut, d.label, cmd))
        end
        return tbl
      end

      local function git_modified_buttons(max_items, shortcut_start)
        max_items = max_items or 10
        shortcut_start = shortcut_start or 60

        local handle = io.popen("git ls-files -m | head -n " .. tostring(max_items))
        if not handle then
          return {}
        end

        local lines = {}
        for line in handle:lines() do
          table.insert(lines, line)
        end
        handle:close()

        local tbl = {}
        for i, fn in ipairs(lines) do
          local sc = tostring(shortcut_start + i - 1)
          local short_fn = vim.fn.fnamemodify(fn, ":.")
          table.insert(tbl, startify.file_button(fn, sc, short_fn, false))
        end
        return tbl
      end

      startify.section.directories = {
        type = "group",
        val = {
          { type = "padding", val = 1 },
          { type = "text", val = "Dirs", opts = { hl = "SpecialComment", shrink_margin = false } },
          { type = "padding", val = 1 },
          {
            type = "group",
            val = function()
              local v = dir_buttons()
              if #v == 0 then
                return { { type = "text", val = "(none)", opts = { hl = "Comment" } } }
              end
              return v
            end,
            opts = { shrink_margin = false },
          },
        },
      }

      startify.section.git_modified = {
        type = "group",
        val = {
          { type = "padding", val = 1 },
          { type = "text", val = "Git Modified", opts = { hl = "SpecialComment", shrink_margin = false } },
          { type = "padding", val = 1 },
          {
            type = "group",
            val = function()
              local v = git_modified_buttons(8, 70)
              if #v == 0 then
                return { { type = "text", val = "(none)", opts = { hl = "Comment" } } }
              end
              return v
            end,
            opts = { shrink_margin = false },
          },
        },
      }

      -- Insert our custom sections into the start screen layout.
      startify.config.layout = {
        { type = "padding", val = 1 },
        startify.section.header,
        { type = "padding", val = 2 },
        startify.section.top_buttons,
        startify.section.directories,
        startify.section.mru_cwd,
        startify.section.mru,
        startify.section.git_modified,
        { type = "padding", val = 1 },
        startify.section.bottom_buttons,
        startify.section.footer,
      }

      alpha.setup(startify.config)
    end,
  },
}

