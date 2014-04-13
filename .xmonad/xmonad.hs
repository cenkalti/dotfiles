import XMonad
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import Graphics.X11.ExtraTypes.XF86
import qualified Data.Map as M

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
        { terminal           = "xterm"
        , normalBorderColor  = "black"
        , focusedBorderColor = "red"
        , modMask            = mod4Mask
        , keys               = myKeys
        , borderWidth        = 2
        , layoutHook         = myLayout
        , manageHook         = manageHook defaultConfig <+> manageDocks
        , focusFollowsMouse  = False
        }

-- The available layouts.  Note that each layout is separated by |||, which
-- denotes layout choice.
myLayout = avoidStruts $ tiled ||| Mirror tiled ||| Full
    where
        -- default tiling algorithm partitions the screen into two panes
        tiled   = Tall nmaster delta ratio
        -- The default number of windows in the master pane
        nmaster = 1
        -- Default proportion of screen occupied by master pane
        ratio   = 0.618
        -- Percent of screen to increment by when resizing panes
        delta   = 3/100

-- Prompt config
myXPConfig = defaultXPConfig
    { font              = "xft:Bitstream Vera Sans Mono:size=12:antialias=true"
    , position          = Top
    , promptBorderWidth = 0
    , height            = 20
    }

-- Union default and new key bindings
myKeys x = M.union (M.fromList (newKeys x)) (keys defaultConfig x)

-- Add new and/or redefine key bindings
newKeys conf@(XConfig {XMonad.modMask = modm}) = [
    -- Use shellPrompt instead of default dmenu
    ((modm, xK_p), shellPrompt myXPConfig),
    ((mod4Mask, xF86XK_MonBrightnessUp), spawn "xbacklight +4 -time 0"),
    ((mod4Mask, xF86XK_MonBrightnessDown), spawn "xbacklight -4 -time 0")
    ]
