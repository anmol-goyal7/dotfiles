-- Default applications and paths.
--
-- The values live in UserConfigs/01-UserDefaults.conf rather than here because
-- three shell scripts still read that file directly -- RofiSearch.sh wants
-- $Search_Engine, Kool_Quick_Settings.sh edits it, bin/keys expands $term and
-- friends. One source of truth beats keeping a Lua copy in sync with it, so
-- this parses it instead of restating it.

local HOME = os.getenv("HOME")

local M = {
    home        = HOME,
    configs     = HOME .. "/.config/hypr/configs",
    scripts     = HOME .. "/.config/hypr/scripts",
    userscripts = HOME .. "/.config/hypr/UserScripts",
    userconfigs = HOME .. "/.config/hypr/UserConfigs",
    dotbin      = HOME .. "/repos/dotfiles/bin",
    localbin    = HOME .. "/.local/bin",
}

-- "$term = kitty  # comment" -> vars.term = "kitty"
local vars = {}
local f = io.open(M.userconfigs .. "/01-UserDefaults.conf", "r")
if f then
    for line in f:lines() do
        local k, v = line:match("^%s*%$([%w_]+)%s*=%s*(.-)%s*$")
        if k then
            v = v:gsub("%s*#.*$", "")
            vars[k] = v
        end
    end
    f:close()
end

M.term    = vars.term or "kitty"
M.files   = vars.files or "kitty --class yazi -e yazi"
M.browser = vars.browser or "google-chrome-stable"
M.editor  = "nvim"

return M
