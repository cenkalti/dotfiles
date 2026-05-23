-- Claude Code IDE integration. Claude runs in an external WezTerm tab via
-- `agent run` (~/projects/work). Existing Claude sessions can still connect
-- on demand with `/ide`.
return {
    'coder/claudecode.nvim',
    event = 'VeryLazy',
    opts = {
        terminal_cmd = 'agent run',
        terminal = {
            provider = 'external',
            provider_opts = {
                -- First %s = cwd, second %s = command (`agent run` with env vars
                -- CLAUDE_CODE_SSE_PORT and ENABLE_IDE_INTEGRATION already set by
                -- the plugin, inherited through `agent run` -> syscall.Exec claude).
                external_terminal_cmd = 'wezterm cli spawn --cwd %s -- %s',
            },
        },
    },
    keys = {
        { '<leader>k', nil, desc = 'AI/Claude Code' },
        { '<leader>kc', '<cmd>ClaudeCode<cr>', desc = 'Launch agent run' },
        { '<leader>kb', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
        { '<leader>ks', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
        {
            '<leader>ks',
            '<cmd>ClaudeCodeTreeAdd<cr>',
            desc = 'Add file',
            ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
        },
        { '<leader>ka', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
        { '<leader>kd', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
}
