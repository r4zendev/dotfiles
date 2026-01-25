#
# ███████╗███████╗███████╗
# ██╔════╝╚══███╔╝██╔════╝
# █████╗    ███╔╝ █████╗
# ██╔══╝   ███╔╝  ██╔══╝
# ██║     ███████╗██║
# ╚═╝     ╚══════╝╚═╝
# Enhanced fzf configuration with smart previews
# https://github.com/junegunn/fzf
#
# ============================================================================
# KEYBINDINGS & FEATURES
# ============================================================================
#
# Default Bindings (fzf.fish):
#   Ctrl-T       Search files (no preview - for inserting paths)
#   Alt-C        Change directory (with eza tree preview)
#   Ctrl-R       Command history search
#                - Ctrl-Y: copy command to clipboard (no line numbers)
#                - Enter: execute command
#
# Custom Bindings:
#   Ctrl-Q       Search files from home directory (~)
#                - Alt-F: toggle files only
#                - Alt-D: toggle directories only
#                - Alt-A: toggle all items
#                - Ctrl-/: toggle preview
#                - Ctrl-Y: copy path to clipboard
#                - Ctrl-D/U: half-page navigation
#                - Enter: open file in editor or cd to directory
#
#   Ctrl-G       Git file browser (fgit)
#                - Alt-M: show modified files
#                - Alt-S: show all tracked files
#                - Alt-U: show untracked files
#                - Enter: open file in $EDITOR
#
#   Alt-F        Interactive ripgrep search (frg)
#                - Live search: type to see results instantly
#                - Shows per-line matches with context
#                - Preview highlights matched line in file
#                - Enter: open file at matched line in $EDITOR
#
#   Alt-K        Interactive process killer (fkill)
#                - Tab: select multiple processes
#                - Ctrl-S: toggle all (select/deselect)
#                - Alt-C: re-sort by CPU
#                - Alt-M: re-sort by MEM
#                - Enter: kill selected processes
#
# Custom Functions:
#   fgit         Browse git tracked files (Ctrl-G)
#   fkill        Interactive process killer (Alt-K) - sorted by memory
#   frg          Ripgrep file content search (Alt-F) - file-grouped view
#
# Universal Controls:
#   Ctrl-/       Toggle preview window on/off
#   Ctrl-D/U     Half-page down/up in main list (fast navigation)
#   Arrow keys   Navigate list line-by-line
#   Page Up/Down Full page scrolling
#   Mouse        Scroll both list and preview
#
# Smart Previews:
#   - Directories: Tree view with eza (2 levels, icons, hidden files)
#   - Text files: Syntax highlighted with bat
#   - Images: File metadata and EXIF data (if exiftool installed)
#   - Other: File info, size, and partial content
#
# Notes:
#   - Ctrl-Q searches from home directory (~) for global file access
#   - Ctrl-T has no preview (designed for inserting paths into commands)
#   - All Ctrl-A bindings avoided (tmux prefix conflict)
#
# ============================================================================

# Only configure if fzf is installed
if not command -v fzf >/dev/null
    return
end

# ============================================================================
# Default Command & Options
# ============================================================================

# Use fd for finding files (faster than find, respects .gitignore)
set -Ux FZF_DEFAULT_COMMAND "fd -H -E '.git' -E 'node_modules'"

# Base fzf options with Catppuccin theme
set -Ux FZF_DEFAULT_OPTS "\
--highlight-line --info=inline-right --ansi --layout=reverse --border=rounded \
--color=bg+:#313244,bg:-1,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#F9E2AF,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4 \
--color=preview-border:#6C7086,preview-label:#CDD6F4 \
--bind='ctrl-/:toggle-preview' \
--bind='ctrl-d:half-page-down' \
--bind='ctrl-u:half-page-up'"

# ============================================================================
# Context-Specific Options
# ============================================================================

# Ctrl-T: File search (no preview - used for inserting paths in commands)
set -Ux FZF_CTRL_T_OPTS "\
--walker-skip .git,node_modules \
--no-preview \
--border-label=' Files ' \
--prompt='📄  ' \
--header='ENTER: insert path' \
--bind='ctrl-d:half-page-down' \
--bind='ctrl-u:half-page-up'"

# Alt-C: Directory search with tree preview
set -Ux FZF_ALT_C_OPTS "\
--walker-skip .git,node_modules \
--preview 'eza --tree --level=2 --icons --all --color=always --group-directories-first {} 2>/dev/null' \
--preview-window 'right:60%:border-left:wrap' \
--border-label=' Directories ' \
--prompt='📁  ' \
--header='CTRL-/: toggle preview' \
--bind='ctrl-/:toggle-preview' \
--bind='ctrl-d:half-page-down' \
--bind='ctrl-u:half-page-up'"

# Ctrl-R: Command history (no preview needed)
# Detect clipboard command
set -l copy_cmd
if command -v wl-copy >/dev/null
    set copy_cmd "wl-copy"
else if command -v pbcopy >/dev/null
    set copy_cmd "pbcopy"
else if command -v xclip >/dev/null
    set copy_cmd "xclip -selection clipboard"
else
    set copy_cmd "cat"
end

set -Ux FZF_CTRL_R_OPTS "\
--no-preview \
--border-label=' Command History ' \
--prompt='  ' \
--header='CTRL-Y: copy | ENTER: execute' \
--bind='ctrl-y:execute-silent(echo -n {} | sed \"s/^[[:space:]]*[0-9]*[[:space:]]*//\" | $copy_cmd)+abort' \
--bind='ctrl-d:half-page-down' \
--bind='ctrl-u:half-page-up'"

# ============================================================================
# fzf.fish plugin configuration
# ============================================================================

# Configure fd options for fzf.fish
set -U fzf_fd_opts --hidden --follow --exclude=.git --exclude=node_modules

# Smart preview commands for fzf.fish
set -U fzf_preview_dir_cmd eza --tree --level=2 --icons --all --color=always --group-directories-first
set -U fzf_preview_file_cmd bat --color=always --style=numbers,changes --line-range=:500

# Initialize fzf for Fish
fzf --fish | source

# ============================================================================
# Custom Keybindings
# ============================================================================

# Ctrl-Q: Search from home directory with smart preview
bind \cq '__fzf_search_home'
if bind -M insert >/dev/null 2>&1
    bind -M insert \cq '__fzf_search_home'
end

# Ctrl-G: Git file browser (most frequently used, worth Ctrl key)
bind \cg 'fgit'
if bind -M insert >/dev/null 2>&1
    bind -M insert \cg 'fgit'
end

# Alt-F: Interactive ripgrep search (Alt to avoid conflict with Ctrl-F forward-char)
bind \ef frg
if bind -M insert >/dev/null 2>&1
    bind -M insert \ef frg
end

# Alt-K: Process killer (Alt to preserve Ctrl-K kill-line)
bind \ek 'fkill; commandline -f repaint'
if bind -M insert >/dev/null 2>&1
    bind -M insert \ek 'fkill; commandline -f repaint'
end
