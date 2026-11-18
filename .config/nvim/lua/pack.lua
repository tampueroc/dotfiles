local M = {}

---@class PluginSpec
---@field src string
---@field name? string
---@field version? string|vim.VersionRange
---@field module_name? string
---@field opts? table|fun():table
---@field on_setup? fun():nil
---@field setup? false

local function plugin_name(src)
    return src:match(".+/(.+)")
end

local function ensure_packpath()
    local site = vim.fn.stdpath("data") .. "/site"
    if not vim.tbl_contains(vim.opt.packpath:get(), site) then
        vim.opt.packpath:prepend(site)
    end
end

---@param plugins PluginSpec[]
local function configure(plugins)
    ensure_packpath()

    local specs = vim.iter(plugins)
        :map(function(plugin)
            return {
                src = "https://github.com/" .. plugin.src,
                name = plugin.name or plugin_name(plugin.src),
                version = plugin.version,
            }
        end)
        :totable()

    vim.pack.add(specs, { load = false })

    for _, plugin in ipairs(plugins) do
        local name = plugin.name or plugin_name(plugin.src)

        vim.cmd.packadd(name)

        if plugin.setup ~= false then
            local module_name = plugin.module_name or plugin_name(plugin.src):gsub("%.nvim$", "")
            local ok, mod = pcall(require, module_name)

            if ok and type(mod.setup) == "function" then
                local opts = type(plugin.opts) == "function" and plugin.opts() or plugin.opts
                mod.setup(opts or {})
            end
        end

        if plugin.on_setup then
            plugin.on_setup()
        end
    end
end

local function add_on_event(event, pattern, plugins)
    vim.api.nvim_create_autocmd(event, {
        pattern = pattern,
        once = true,
        callback = function()
            configure(plugins)
        end,
    })
end

function M.map_keys(keys)
    for _, key in ipairs(keys) do
        vim.keymap.set(key.mode or "n", key[1], key[2], { desc = key.desc })
    end
end

function M.add(plugins)
    configure(plugins)
end

function M.add_on_event(event, plugins)
    add_on_event(event, nil, plugins)
end

function M.add_on_file_type(patterns, plugins)
    add_on_event("FileType", patterns, plugins)
end

function M.on_plugin_update(plugin_name_, cmd)
    vim.api.nvim_create_autocmd("PackChanged", {
        callback = function(args)
            if args.data.spec.name == plugin_name_
                and (args.data.kind == "install" or args.data.kind == "update")
            then
                if type(cmd) == "string" then
                    vim.system({ "sh", "-c", cmd }, { cwd = args.data.path })
                else
                    cmd()
                end
            end
        end,
    })
end

return M
