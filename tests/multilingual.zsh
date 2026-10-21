#!/usr/bin/env zsh
# Run with: zsh -f tests/multilingual.zsh
emulate -L zsh
setopt no_unset

local_dir="${0:A:h}"
source "$local_dir/../insult-zsh.plugin.zsh"

typeset -gi failures=0

check_language() {
  local typed="$1"
  local expected="$2"
  if ! _zsh_roast_detect_language "$typed"; then
    print -u2 -r -- "FAIL: '$typed' not recognized as $expected"
    (( failures++ ))
    return
  fi
  if [[ "$REPLY" != "$expected" ]]; then
    print -u2 -r -- "FAIL: '$typed' recognized as '$REPLY', expected '$expected'"
    (( failures++ ))
  fi
}

check_language "مرحبا" arabic
check_language "привет" cyrillic
check_language "γειά" greek
check_language "你好" chinese
check_language "こんにちは" japanese
check_language "한글" korean
check_language "नमस्ते" devanagari
check_language "café" latin
check_language "bonjour" french
check_language "HOLA" spanish
check_language "hallo" german
check_language "ciao" italian

if _zsh_roast_detect_language "qwerty"; then
  print -u2 -r -- "FAIL: unrecognized ASCII word falsely identified"
  (( failures++ ))
fi


# All curated language-specific roast messages must remain ASCII English.
# Non-English characters remain valid in commands, but not roast text.
typeset -a all_language_roasts=(
  "${ZSH_ROAST_LANGUAGE_ARABIC[@]}"
  "${ZSH_ROAST_LANGUAGE_CYRILLIC[@]}"
  "${ZSH_ROAST_LANGUAGE_GREEK[@]}"
  "${ZSH_ROAST_LANGUAGE_CHINESE[@]}"
  "${ZSH_ROAST_LANGUAGE_JAPANESE[@]}"
  "${ZSH_ROAST_LANGUAGE_KOREAN[@]}"
  "${ZSH_ROAST_LANGUAGE_DEVANAGARI[@]}"
  "${ZSH_ROAST_LANGUAGE_LATIN[@]}"
  "${ZSH_ROAST_LANGUAGE_FRENCH[@]}"
  "${ZSH_ROAST_LANGUAGE_SPANISH[@]}"
  "${ZSH_ROAST_LANGUAGE_GERMAN[@]}"
  "${ZSH_ROAST_LANGUAGE_ITALIAN[@]}"
)
for roast in "${all_language_roasts[@]}"; do
  if [[ "$roast" =~ '[^ -~]' ]]; then
    print -u2 -r -- "FAIL: found non-ASCII characters in a roast: $roast"
    (( failures++ ))
  fi
done

# The selected message must also be in English for every detected script.
ZSH_ROAST_NON_ENGLISH=1
for typed in "مرحبا" "привет" "γειά" "你好" "こんにちは" "한글" "नमस्ते" "café" "bonjour" "hola" "hallo" "ciao"; do
  _zsh_roast_select_message "$typed"
  if [[ "$REPLY" =~ '[^ -~]' ]]; then
    print -u2 -r -- "FAIL: selected a non-English roast for '$typed'"
    (( failures++ ))
  fi
done

# Level 1 must draw only from a language's first two messages.
ZSH_ROAST_LEVEL=1
ZSH_ROAST_AVOID_REPEATS=0
for (( i=1; i<=20; i++ )); do
  _zsh_roast_select_message "bonjour"
  if [[ "$REPLY" != "${ZSH_ROAST_LANGUAGE_FRENCH[1]}" &&
        "$REPLY" != "${ZSH_ROAST_LANGUAGE_FRENCH[2]}" ]]; then
    print -u2 -r -- "FAIL: level 1 selected an unexpected French roast"
    (( failures++ ))
  fi
done

# Disabling localized messages must revert to an ordinary roast.
ZSH_ROAST_NON_ENGLISH=0
_zsh_roast_select_message "bonjour"
if [[ "$REPLY" == "${ZSH_ROAST_LANGUAGE_FRENCH[1]}" ||
      "$REPLY" == "${ZSH_ROAST_LANGUAGE_FRENCH[2]}" ]]; then
  print -u2 -r -- "FAIL: localization remained active after disabling"
  (( failures++ ))
fi

if (( failures )); then
  print -u2 -r -- "$failures multilingual test(s) failed"
  exit 1
fi
print -r -- "Multilingual tests passed"
