return {
    'robitx/gp.nvim',
    config = function()
        require('gp').setup({
            agents = {
                { name = 'ChatGPT3-5' },
                { name = 'CodeGPT3-5' },
                {
                    name = 'ChatGPT4',
                    chat = true,
                    command = false,
                    model = { model = 'gpt-4', temperature = 1.1, top_p = 1 },
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
                    model = { model = 'gpt-4', temperature = 0.8, top_p = 1 },
                    system_prompt = 'You are an AI working as a code editor.\n\n'
                        .. 'Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n'
                        .. 'START AND END YOUR ANSWER WITH:\n\n```',
                },
            },
        })

        -- VISUAL mode mappings
        -- s, x, v modes are handled the same way by which_key
        require('which-key').register({
            -- ...
            ['<C-g>'] = {
                c = { ":<C-u>'<,'>GpChatNew<cr>", 'Visual Chat New' },
                p = { ":<C-u>'<,'>GpChatPaste<cr>", 'Visual Chat Paste' },
                t = { ":<C-u>'<,'>GpChatToggle<cr>", 'Visual Toggle Chat' },

                ['<C-x>'] = { ":<C-u>'<,'>GpChatNew split<cr>", 'Visual Chat New split' },
                ['<C-v>'] = { ":<C-u>'<,'>GpChatNew vsplit<cr>", 'Visual Chat New vsplit' },
                ['<C-t>'] = { ":<C-u>'<,'>GpChatNew tabnew<cr>", 'Visual Chat New tabnew' },

                r = { ":<C-u>'<,'>GpRewrite<cr>", 'Visual Rewrite' },
                a = { ":<C-u>'<,'>GpAppend<cr>", 'Visual Append (after)' },
                b = { ":<C-u>'<,'>GpPrepend<cr>", 'Visual Prepend (before)' },
                i = { ":<C-u>'<,'>GpImplement<cr>", 'Implement selection' },

                g = {
                    name = 'generate into new ..',
                    p = { ":<C-u>'<,'>GpPopup<cr>", 'Visual Popup' },
                    e = { ":<C-u>'<,'>GpEnew<cr>", 'Visual GpEnew' },
                    n = { ":<C-u>'<,'>GpNew<cr>", 'Visual GpNew' },
                    v = { ":<C-u>'<,'>GpVnew<cr>", 'Visual GpVnew' },
                    t = { ":<C-u>'<,'>GpTabnew<cr>", 'Visual GpTabnew' },
                },

                n = { '<cmd>GpNextAgent<cr>', 'Next Agent' },
                s = { '<cmd>GpStop<cr>', 'GpStop' },
                x = { ":<C-u>'<,'>GpContext<cr>", 'Visual GpContext' },

                w = {
                    name = 'Whisper',
                    w = { ":<C-u>'<,'>GpWhisper<cr>", 'Whisper' },
                    r = { ":<C-u>'<,'>GpWhisperRewrite<cr>", 'Whisper Rewrite' },
                    a = { ":<C-u>'<,'>GpWhisperAppend<cr>", 'Whisper Append (after)' },
                    b = { ":<C-u>'<,'>GpWhisperPrepend<cr>", 'Whisper Prepend (before)' },
                    p = { ":<C-u>'<,'>GpWhisperPopup<cr>", 'Whisper Popup' },
                    e = { ":<C-u>'<,'>GpWhisperEnew<cr>", 'Whisper Enew' },
                    n = { ":<C-u>'<,'>GpWhisperNew<cr>", 'Whisper New' },
                    v = { ":<C-u>'<,'>GpWhisperVnew<cr>", 'Whisper Vnew' },
                    t = { ":<C-u>'<,'>GpWhisperTabnew<cr>", 'Whisper Tabnew' },
                },
            },
            -- ...
        }, {
            mode = 'v', -- VISUAL mode
            prefix = '',
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = true,
        })

        -- NORMAL mode mappings
        require('which-key').register({
            -- ...
            ['<C-g>'] = {
                c = { '<cmd>GpChatNew<cr>', 'New Chat' },
                t = { '<cmd>GpChatToggle<cr>', 'Toggle Chat' },
                f = { '<cmd>GpChatFinder<cr>', 'Chat Finder' },

                ['<C-x>'] = { '<cmd>GpChatNew split<cr>', 'New Chat split' },
                ['<C-v>'] = { '<cmd>GpChatNew vsplit<cr>', 'New Chat vsplit' },
                ['<C-t>'] = { '<cmd>GpChatNew tabnew<cr>', 'New Chat tabnew' },

                r = { '<cmd>GpRewrite<cr>', 'Inline Rewrite' },
                a = { '<cmd>GpAppend<cr>', 'Append (after)' },
                b = { '<cmd>GpPrepend<cr>', 'Prepend (before)' },

                g = {
                    name = 'generate into new ..',
                    p = { '<cmd>GpPopup<cr>', 'Popup' },
                    e = { '<cmd>GpEnew<cr>', 'GpEnew' },
                    n = { '<cmd>GpNew<cr>', 'GpNew' },
                    v = { '<cmd>GpVnew<cr>', 'GpVnew' },
                    t = { '<cmd>GpTabnew<cr>', 'GpTabnew' },
                },

                n = { '<cmd>GpNextAgent<cr>', 'Next Agent' },
                s = { '<cmd>GpStop<cr>', 'GpStop' },
                x = { '<cmd>GpContext<cr>', 'Toggle GpContext' },

                w = {
                    name = 'Whisper',
                    w = { '<cmd>GpWhisper<cr>', 'Whisper' },
                    r = { '<cmd>GpWhisperRewrite<cr>', 'Whisper Inline Rewrite' },
                    a = { '<cmd>GpWhisperAppend<cr>', 'Whisper Append (after)' },
                    b = { '<cmd>GpWhisperPrepend<cr>', 'Whisper Prepend (before)' },
                    p = { '<cmd>GpWhisperPopup<cr>', 'Whisper Popup' },
                    e = { '<cmd>GpWhisperEnew<cr>', 'Whisper Enew' },
                    n = { '<cmd>GpWhisperNew<cr>', 'Whisper New' },
                    v = { '<cmd>GpWhisperVnew<cr>', 'Whisper Vnew' },
                    t = { '<cmd>GpWhisperTabnew<cr>', 'Whisper Tabnew' },
                },
            },
            -- ...
        }, {
            mode = 'n', -- NORMAL mode
            prefix = '',
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = true,
        })

        -- INSERT mode mappings
        require('which-key').register({
            -- ...
            ['<C-g>'] = {
                c = { '<cmd>GpChatNew<cr>', 'New Chat' },
                t = { '<cmd>GpChatToggle<cr>', 'Toggle Chat' },
                f = { '<cmd>GpChatFinder<cr>', 'Chat Finder' },

                ['<C-x>'] = { '<cmd>GpChatNew split<cr>', 'New Chat split' },
                ['<C-v>'] = { '<cmd>GpChatNew vsplit<cr>', 'New Chat vsplit' },
                ['<C-t>'] = { '<cmd>GpChatNew tabnew<cr>', 'New Chat tabnew' },

                r = { '<cmd>GpRewrite<cr>', 'Inline Rewrite' },
                a = { '<cmd>GpAppend<cr>', 'Append (after)' },
                b = { '<cmd>GpPrepend<cr>', 'Prepend (before)' },

                g = {
                    name = 'generate into new ..',
                    p = { '<cmd>GpPopup<cr>', 'Popup' },
                    e = { '<cmd>GpEnew<cr>', 'GpEnew' },
                    n = { '<cmd>GpNew<cr>', 'GpNew' },
                    v = { '<cmd>GpVnew<cr>', 'GpVnew' },
                    t = { '<cmd>GpTabnew<cr>', 'GpTabnew' },
                },

                x = { '<cmd>GpContext<cr>', 'Toggle GpContext' },
                s = { '<cmd>GpStop<cr>', 'GpStop' },
                n = { '<cmd>GpNextAgent<cr>', 'Next Agent' },

                w = {
                    name = 'Whisper',
                    w = { '<cmd>GpWhisper<cr>', 'Whisper' },
                    r = { '<cmd>GpWhisperRewrite<cr>', 'Whisper Inline Rewrite' },
                    a = { '<cmd>GpWhisperAppend<cr>', 'Whisper Append (after)' },
                    b = { '<cmd>GpWhisperPrepend<cr>', 'Whisper Prepend (before)' },
                    p = { '<cmd>GpWhisperPopup<cr>', 'Whisper Popup' },
                    e = { '<cmd>GpWhisperEnew<cr>', 'Whisper Enew' },
                    n = { '<cmd>GpWhisperNew<cr>', 'Whisper New' },
                    v = { '<cmd>GpWhisperVnew<cr>', 'Whisper Vnew' },
                    t = { '<cmd>GpWhisperTabnew<cr>', 'Whisper Tabnew' },
                },
            },
            -- ...
        }, {
            mode = 'i', -- INSERT mode
            prefix = '',
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = true,
        })
    end,
}
