-- PR-style diff review: file panel plus side-by-side diff against any revision
return {
    'sindrets/diffview.nvim',
    dependencies = {
        'folke/which-key.nvim',
    },
    config = function()
        -- Diff the working tree against the commit HEAD branched from on the
        -- remote's default branch, as a GitHub PR does plus uncommitted work. The default branch is read from
        -- origin/HEAD so repos on master work too.
        local function open_pr_diff()
            local dir = vim.fn.expand('%:p:h')
            if vim.fn.isdirectory(dir) == 0 then
                dir = vim.fn.getcwd()
            end
            local function git(args)
                local out = vim.fn.systemlist(vim.list_extend({ 'git', '-C', dir }, args))
                if vim.v.shell_error ~= 0 then
                    return nil
                end
                return out[1]
            end

            local base = git({ 'symbolic-ref', '--short', 'refs/remotes/origin/HEAD' })
            if not base then
                for _, candidate in ipairs({ 'origin/main', 'origin/master', 'main', 'master' }) do
                    if git({ 'rev-parse', '--verify', '--quiet', candidate }) then
                        base = candidate
                        break
                    end
                end
            end
            if not base then
                vim.notify('PR diff: no default branch found', vim.log.levels.ERROR)
                return
            end

            local fork = git({ 'merge-base', base, 'HEAD' })
            if not fork then
                vim.notify('PR diff: no merge-base between ' .. base .. ' and HEAD', vim.log.levels.ERROR)
                return
            end

            -- A single rev compares against the working tree, so uncommitted
            -- changes show too and the right side stays editable.
            vim.cmd('DiffviewOpen ' .. fork)
            vim.notify('PR diff: ' .. base .. ' branch point ' .. fork:sub(1, 8))
        end

        require('diffview').setup({})
        require('which-key').add({
            { '<leader>gP', open_pr_diff, desc = 'PR Diff vs Branch Point' },
            { '<leader>gh', ':DiffviewFileHistory %<CR>', desc = 'File History' },
            { '<leader>gq', ':DiffviewClose<CR>', desc = 'Close Diffview' },
        })
    end,
}
