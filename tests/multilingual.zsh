#!/usr/bin/env zsh
# Run with: zsh -f tests/multilingual.zsh

emulate -L zsh
setopt no_unset

local_dir="${0:A:h}"
source "$local_dir/../insult-zsh.plugin.zsh"
typeset -gi failures=0

check_non_english() {
  local typed="$1"
  if ! _zsh_roast_is_non_english "$typed"; then
    print -u2 -r -- "FAIL: '$typed' not recognized as non-English"
    (( failures++ ))
  fi
}

# All non-ASCII scripts should trigger the same generic treatment.
for typed in "مرحبا" "привет" "γειά" "你好" "こんにちは" "한글" "नमस्ते" "café" "🙂"; do
  check_non_english "$typed"
done

# Common ASCII-only words remain recognized without language classification.
for typed in bonjour BONJOUR hola hallo ciao gracias danke grazie; do
  check_non_english "$typed"
done

for typed in git gti python3 qwerty ''; do
  if _zsh_roast_is_non_english "$typed"; then
    print -u2 -r -- "FAIL: '$typed' incorrectly recognized as non-English"
    (( failures++ ))
  fi
done

# Every shared roast must be written in printable ASCII English.
for roast in "${ZSH_ROAST_NON_ENGLISH_MESSAGES[@]}"; do
  if [[ "$roast" =~ '[^ -~]' ]]; then
    print -u2 -r -- "FAIL: non-ASCII roast message: $roast"
    (( failures++ ))
  fi
done

ZSH_ROAST_TYPO_DETECTION=0
ZSH_ROAST_AVOID_REPEATS=0
ZSH_ROAST_LEVEL=1
ZSH_ROAST_NON_ENGLISH=1

# For every language, level 1 may only select from entries 1-4.
for typed in "مرحبا" "привет" "γειά" "你好" "こんにちは" "한글" "नमस्ते" "café" bonjour hola hallo ciao; do
  _zsh_roast_select_message "$typed"
  if [[ "$REPLY" != "${ZSH_ROAST_NON_ENGLISH_MESSAGES[1]}" &&
        "$REPLY" != "${ZSH_ROAST_NON_ENGLISH_MESSAGES[2]}" &&
        "$REPLY" != "${ZSH_ROAST_NON_ENGLISH_MESSAGES[3]}" &&
        "$REPLY" != "${ZSH_ROAST_NON_ENGLISH_MESSAGES[4]}" ]]; then
    print -u2 -r -- "FAIL: '$typed' selected a message outside the shared level-1 pool"
    (( failures++ ))
  fi
done

# Disabling special selection restores the usual message pool.
ZSH_ROAST_NON_ENGLISH=0
_zsh_roast_select_message bonjour
for roast in "${ZSH_ROAST_NON_ENGLISH_MESSAGES[@]}"; do
  if [[ "$REPLY" == "$roast" ]]; then
    print -u2 -r -- "FAIL: special pool active after disabling"
    (( failures++ ))
    break
  fi
done

if (( failures )); then
  print -u2 -r -- "$failures non-English roast test(s) failed"
  exit 1
fi
print -r -- "Non-English roast tests passed"
