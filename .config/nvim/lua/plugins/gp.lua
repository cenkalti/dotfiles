-- LLM code assistant
return {
    'robitx/gp.nvim',
    config = function()
        require('gp').setup({
            default_chat_agent = 'ChatGPT4o',
            default_command_agent = 'CodeGPT4o',
            hooks = {
                UnitTests = function(gp, params)
                    local template = 'I have the following code from {{filename}}:\n\n'
                        .. '```{{filetype}}\n{{selection}}\n```\n\n'
                        .. 'Please respond by writing table driven unit tests for the code above.'
                    local agent = gp.get_command_agent()
                    gp.Prompt(params, gp.Target.enew, agent, template)
                end,
                Explain = function(gp, params)
                    local template = 'I have the following code from {{filename}}:\n\n'
                        .. '```{{filetype}}\n{{selection}}\n```\n\n'
                        .. 'Please respond by explaining the code above.'
                    local agent = gp.get_chat_agent()
                    gp.Prompt(params, gp.Target.popup, agent, template)
                end,
                FormatString = function(gp, params)
                    local template = 'I have the following code from {{filename}}:\n\n'
                        .. '```{{filetype}}\n{{selection}}\n```\n\n'
                        .. 'Please respond by reformatting the string above. Do not exceed 120 characters per line.'
                    local agent = gp.get_command_agent()
                    gp.Prompt(params, gp.Target.rewrite, agent, template)
                end,
                Revise = function(gp, params)
                    local template = [[
                        ## Role
                        You are a helpful assistant who improves users' text.

                        ## Assessment
                        If the text is already simple and easy to understand, do not rewrite it.

                        ## Improvements:
                        - Correct any spelling or grammar mistakes.
                        - Use short sentences.
                        - Focus on one idea per sentence.
                        - Use the subject-verb-object structure for clarity.
                        - Choose simple language and avoid unnecessary, complex, or uncommon words and phrases.

                        ## Tone
                        Maintain a casual tone.

                        ## Input
                        The input text will be given between <selection> and </selection> tags.

                        ## Response
                        Only respond with the revised text. Do not add any quotes to your reply.

                        <selection>
                        {{selection}}
                        </selection>
                        ]]
                    local agent = gp.get_command_agent()
                    gp.Prompt(params, gp.Target.rewrite, agent, template)
                end,
            },
        })
        require('which-key').add({
            -- VISUAL mode mappings
            {
                mode = { 'v' },
                nowait = true,
                remap = false,
                { '<C-g><C-t>', ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = 'ChatNew tabnew' },
                { '<C-g><C-v>', ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = 'ChatNew vsplit' },
                { '<C-g><C-x>', ":<C-u>'<,'>GpChatNew split<cr>", desc = 'ChatNew split' },
                { '<C-g>a', ":<C-u>'<,'>GpAppend<cr>", desc = 'Visual Append (after)' },
                { '<C-g>b', ":<C-u>'<,'>GpPrepend<cr>", desc = 'Visual Prepend (before)' },
                { '<C-g>c', ":<C-u>'<,'>GpChatNew<cr>", desc = 'Visual Chat New' },
                { '<C-g>g', group = 'generate into new ..' },
                { '<C-g>ge', ":<C-u>'<,'>GpEnew<cr>", desc = 'Visual GpEnew' },
                { '<C-g>gn', ":<C-u>'<,'>GpNew<cr>", desc = 'Visual GpNew' },
                { '<C-g>gp', ":<C-u>'<,'>GpPopup<cr>", desc = 'Visual Popup' },
                { '<C-g>gt', ":<C-u>'<,'>GpTabnew<cr>", desc = 'Visual GpTabnew' },
                { '<C-g>gv', ":<C-u>'<,'>GpVnew<cr>", desc = 'Visual GpVnew' },
                { '<C-g>i', ":<C-u>'<,'>GpImplement<cr>", desc = 'Implement selection' },
                { '<C-g>u', ":<C-u>'<,'>GpUnitTests<cr>", desc = 'Unit Tests' },
                { '<C-g>e', ":<C-u>'<,'>GpExplain<cr>", desc = 'Explain' },
                { '<C-g>f', ":<C-u>'<,'>GpFormatString<cr>", desc = 'Format String' },
                { '<C-g>n', '<cmd>GpNextAgent<cr>', desc = 'Next Agent' },
                { '<C-g>p', ":<C-u>'<,'>GpChatPaste<cr>", desc = 'Visual Chat Paste' },
                { '<C-g>r', ":<C-u>'<,'>GpRewrite<cr>", desc = 'Visual Rewrite' },
                { '<C-g>R', ":<C-u>'<,'>GpRevise<cr>", desc = 'Visual Revise' },
                { '<C-g>s', '<cmd>GpStop<cr>', desc = 'GpStop' },
                { '<C-g>t', ":<C-u>'<,'>GpChatToggle<cr>", desc = 'Visual Toggle Chat' },
                { '<C-g>x', ":<C-u>'<,'>GpContext<cr>", desc = 'Visual GpContext' },
            },
            -- NORMAL mode mappings
            {
                mode = { 'n' },
                nowait = true,
                remap = false,
                { '<C-g><C-t>', '<cmd>GpChatNew tabnew<cr>', desc = 'New Chat tabnew' },
                { '<C-g><C-v>', '<cmd>GpChatNew vsplit<cr>', desc = 'New Chat vsplit' },
                { '<C-g><C-x>', '<cmd>GpChatNew split<cr>', desc = 'New Chat split' },
                { '<C-g>a', '<cmd>GpAppend<cr>', desc = 'Append (after)' },
                { '<C-g>b', '<cmd>GpPrepend<cr>', desc = 'Prepend (before)' },
                { '<C-g>c', '<cmd>GpChatNew<cr>', desc = 'New Chat' },
                { '<C-g>f', '<cmd>GpChatFinder<cr>', desc = 'Chat Finder' },
                { '<C-g>g', group = 'generate into new ..' },
                { '<C-g>ge', '<cmd>GpEnew<cr>', desc = 'GpEnew' },
                { '<C-g>gn', '<cmd>GpNew<cr>', desc = 'GpNew' },
                { '<C-g>gp', '<cmd>GpPopup<cr>', desc = 'Popup' },
                { '<C-g>gt', '<cmd>GpTabnew<cr>', desc = 'GpTabnew' },
                { '<C-g>gv', '<cmd>GpVnew<cr>', desc = 'GpVnew' },
                { '<C-g>n', '<cmd>GpNextAgent<cr>', desc = 'Next Agent' },
                { '<C-g>r', '<cmd>GpRewrite<cr>', desc = 'Inline Rewrite' },
                { '<C-g>R', '<cmd>GpRevise<cr>', desc = 'Visual Revise' },
                { '<C-g>s', '<cmd>GpStop<cr>', desc = 'GpStop' },
                { '<C-g>t', '<cmd>GpChatToggle<cr>', desc = 'Toggle Chat' },
                { '<C-g>x', '<cmd>GpContext<cr>', desc = 'Toggle GpContext' },
            },
        })
    end,
}
