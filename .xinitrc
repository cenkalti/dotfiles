xsetroot -cursor_name left_ptr
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
trayer --edge bottom --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --alpha 0 --tint 0x000000 --height 27 &
exec xmonad
