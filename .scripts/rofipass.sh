#!/bin/bash
r=$(find .password-store | sed 's#.password-store/##' | sed '/.gpg-id/d' | sed '/.gpg/!d' | sed 's/.gpg//' | rofi -dmenu -p "Account: ")
case "$r" in
  "");;
  *) pass -c $r;;
esac
