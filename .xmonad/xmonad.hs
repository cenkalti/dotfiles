import XMonad
 
main = do
     xmonad $ defaultConfig
          { terminal    = "terminal"
          , modMask     = mod4Mask
          , borderWidth = 3
          , focusedBorderColor = "blue"
          }
