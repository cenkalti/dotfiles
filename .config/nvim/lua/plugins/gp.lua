return {
    'robitx/gp.nvim',
    config = function()
        require('gp').setup({
            agents = {
                -- Remove default agents
                { name = 'ChatGPT3-5' },
                { name = 'CodeGPT3-5' },

                {
                    name = 'ChatGPT4',
                    chat = true,
                    command = false,
                    model = { model = 'gpt-4o', temperature = 0.2, top_p = 0.1 },
                    system_prompt = 'You are a general AI assistant.\n\n'
                        .. 'The user provided the additional info about how they would like you to respond:\n\n'
                        .. "- If you're unsure don't guess and say you don't know instead.\n"
                        .. '- Ask question if you need clarification to provide better answer.\n'
                        .. '- Think deeply and carefully from first principles step by step.\n'
                        .. '- Zoom out first to see the big picture and then zoom in to details.\n'
                        .. '- Use Socratic method to improve your thinking and coding skills.\n'
                        .. "- Don't elide any code from your output if the answer requires coding.\n"
                        .. "- Take a deep breath; You've got this!\n",
                },
                {
                    name = 'CodeGPT4',
                    chat = false,
                    command = true,
                    model = { model = 'gpt-4o', temperature = 0.2, top_p = 0.1 },
                    system_prompt = 'You are an AI working as a code editor.\n\n'
                        .. 'Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n'
                        .. 'START AND END YOUR ANSWER WITH:\n\n```',
                },
            },
            hooks = {
                Implement = function(gp, params)
                    local template = 'Having following from {{filename}}:\n\n'
                        .. '```{{filetype}}\n{{selection}}\n```\n\n'
                        .. 'Please rewrite this according to the contained instructions.'
                        .. '\n\nRespond exclusively with the snippet that should replace the selection above.'
                    local agent = gp.get_command_agent()
                    gp.Prompt(params, gp.Target.rewrite, nil, agent.model, template, agent.system_prompt)
                end,
                UnitTests = function(gp, params)
                    local template = 'I have the following code from {{filename}}:\n\n'
                        .. '```{{filetype}}\n{{selection}}\n```\n\n'
                        .. 'Please respond by writing table driven unit tests for the code above.'
                    local agent = gp.get_command_agent()
                    gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
                end,
                Explain = function(gp, params)
                    local template = 'I have the following code from {{filename}}:\n\n'
                        .. '```{{filetype}}\n{{selection}}\n```\n\n'
                        .. 'Please respond by explaining the code above.'
                    local agent = gp.get_chat_agent()
                    gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
                end,
            },
        })

        -- VISUAL mode mappings
        require('which-key').register({
            c = { ":<C-u>'<,'>GpChatNew<cr>", 'Visual Chat New' },
            p = { ":<C-u>'<,'>GpChatPaste<cr>", 'Visual Chat Paste' },
            t = { ":<C-u>'<,'>GpChatToggle<cr>", 'Visual Toggle Chat' },

            r = { ":<C-u>'<,'>GpRewrite<cr>", 'Visual Rewrite' },
            a = { ":<C-u>'<,'>GpAppend<cr>", 'Visual Append (after)' },
            b = { ":<C-u>'<,'>GpPrepend<cr>", 'Visual Prepend (before)' },
            i = { ":<C-u>'<,'>GpImplement<cr>", 'Implement selection' },
            u = { ":<C-u>'<,'>GpUnitTests<cr>", 'Write Unit Tests' },
            e = { ":<C-u>'<,'>GpExplain<cr>", 'Explain selection' },

            n = { '<cmd>GpNextAgent<cr>', 'Next Agent' },
            s = { '<cmd>GpStop<cr>', 'GpStop' },
            x = { ":<C-u>'<,'>GpContext<cr>", 'Visual GpContext' },
        }, {
            mode = 'v',
            prefix = '<C-g>',
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = true,
        })

        -- NORMAL mode mappings
        require('which-key').register({
            c = { '<cmd>GpChatNew<cr>', 'New Chat' },
            t = { '<cmd>GpChatToggle<cr>', 'Toggle Chat' },
            f = { '<cmd>GpChatFinder<cr>', 'Chat Finder' },

            r = { '<cmd>GpRewrite<cr>', 'Inline Rewrite' },
            a = { '<cmd>GpAppend<cr>', 'Append (after)' },
            b = { '<cmd>GpPrepend<cr>', 'Prepend (before)' },

            n = { '<cmd>GpNextAgent<cr>', 'Next Agent' },
            s = { '<cmd>GpStop<cr>', 'GpStop' },
            x = { '<cmd>GpContext<cr>', 'Toggle GpContext' },
        }, {
            mode = 'n',
            prefix = '<C-g>',
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = true,
        })
    end,
}
