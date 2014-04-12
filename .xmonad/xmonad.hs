import XMonad
import XMonad.Core

import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Man

import XMonad.Layout
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile

import XMonad.Hooks.ManageDocks

import XMonad.Util.EZConfig
import XMonad.Util.Run
import qualified Data.Map as M
import System.IO

main = do
   xmonad $ defaultConfig
      { terminal = "terminator"
      , focusedBorderColor = myActiveBorderColor
      , modMask = mod4Mask
      , keys = myKeys
      , borderWidth = 2
      , layoutHook = avoidStruts $ myLayoutHook
     }   

-- Layouts
myLayoutHook = smartBorders $ (tiled ||| Mirror tiled ||| Full)
  where
      tiled = ResizableTall nmaster delta ratio []
      nmaster = 1
      delta = 3/100
      ratio = 1/2

-- Colors
myFgColor = "white"
myBgColor = "#099999"
myHighlightedFgColor = "white"
myHighlightedBgColor = "#FF3300"
myActiveBorderColor = "#C80003"

-- Prompt config
myXPConfig = defaultXPConfig {
  position = Top,
  promptBorderWidth = 0,
  height = 15,
  bgColor = myBgColor,
  fgColor = myFgColor,
  fgHLight = myHighlightedFgColor,
  bgHLight = myHighlightedBgColor
  }

-- Union default and new key bindings
myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)

-- Add new and/or redefine key bindings
newKeys conf@(XConfig {XMonad.modMask = modm}) = [
  -- Use shellPrompt instead of default dmenu
  ((modm, xK_p), shellPrompt myXPConfig)
   ]
