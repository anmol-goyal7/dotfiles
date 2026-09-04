-- Shared helpers.
--
-- Everything binds through M.bind rather than hl.bind directly, so that every
-- bind lands in one registry. bin/keys reads that registry over hyprctl
-- instead of re-parsing config files: in Lua mode `hyprctl binds` reports the
-- dispatcher as an opaque "__lua" handle, so the live bind table alone is not
-- enough to show -- let alone run -- a bind.

local M = {}

M.mod = "SUPER"

-- The registry. Global on purpose: `hyprctl eval` and `hyprctl repl` can only
-- reach globals, and bin/keys drives both.
KEYBINDS = {}

local MOD_NAMES = {
    SUPER = "Super", SHIFT = "Shift", CTRL = "Ctrl", CONTROL = "Ctrl",
    ALT = "Alt", MOD5 = "Mod5", CAPS = "Caps",
}

local KEY_NAMES = {
    SPACE = "Space", space = "Space", slash = "/", period = ".", comma = ",",
    escape = "Esc", Escape = "Esc", Return = "Enter", RETURN = "Enter",
    grave = "`", bracketleft = "[", bracketright = "]", equal = "=",
    minus = "-", Delete = "Del", tab = "Tab", Tab = "Tab", Print = "PrtSc",
    mouse_down = "Scroll↓", mouse_up = "Scroll↑",
    ["mouse:272"] = "LMB", ["mouse:273"] = "RMB",
}

-- code:10 .. code:19 are the number row; the config binds by keycode so the
-- digits stay put under a non-US layout, but the cheatsheet should say "1".
for i = 0, 9 do
    KEY_NAMES["code:" .. (10 + i)] = tostring((i + 1) % 10)
end

-- "SUPER + SHIFT + S" -> "Super+Shift+S"
local function pretty(keys)
    local parts = {}
    for raw in tostring(keys):gmatch("[^+]+") do
        local part = raw:match("^%s*(.-)%s*$")
        if part ~= "" then table.insert(parts, part) end
    end
    local out = {}
    for i, part in ipairs(parts) do
        if i < #parts then
            table.insert(out, MOD_NAMES[part:upper()] or part)
        else
            table.insert(out, KEY_NAMES[part] or KEY_NAMES[part:upper()] or part)
        end
    end
    return table.concat(out, "+")
end

local current_submap = nil

---Bind a key and record it in KEYBINDS.
---opts.desc is the cheatsheet label; everything else goes through to hl.bind.
function M.bind(keys, dispatcher, opts)
    opts = opts or {}
    local desc = opts.desc
    local passthrough = {}
    for k, v in pairs(opts) do
        if k ~= "desc" then passthrough[k] = v end
    end
    if desc then passthrough.description = desc end

    local handle = hl.bind(keys, dispatcher, passthrough)

    table.insert(KEYBINDS, {
        keys    = keys,
        combo   = pretty(keys),
        desc    = desc or "",
        dsp     = dispatcher,
        submap  = current_submap,
        -- Mouse binds do nothing useful when fired from a menu, and a bind
        -- that only enters a submap would strand the picker in that submap.
        runnable = not (opts.mouse or current_submap ~= nil),
    })
    return handle
end

---Define a submap; binds made inside `fn` are tagged with the submap name.
function M.submap(name, fn)
    hl.define_submap(name, function()
        current_submap = name
        local ok, err = pcall(fn)
        current_submap = nil
        if not ok then error(err, 0) end
    end)
end

---Convenience: a bind that runs a shell command.
function M.exec(keys, cmd, opts)
    return M.bind(keys, hl.dsp.exec_cmd(cmd), opts)
end

-- ---- consumed by bin/keys -------------------------------------------------

---One record per line: index, combo, description, runnable. Tab separated.
function KEYS_LIST()
    local out = {}
    for i, b in ipairs(KEYBINDS) do
        local combo = b.submap and ("[" .. b.submap .. "] " .. b.combo) or b.combo
        local desc  = b.desc
        if desc == "" then desc = "(no description)" end
        table.insert(out, table.concat({
            i, combo, desc, b.runnable and "1" or "0",
        }, "\t"))
    end
    return table.concat(out, "\n")
end

---Fire the bind at index `i`.
function KEYS_RUN(i)
    local b = KEYBINDS[tonumber(i)]
    if b and b.runnable then hl.dispatch(b.dsp) end
end

return M
