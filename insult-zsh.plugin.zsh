# zsh-roast.plugin.zsh
#
# A context-aware command-not-found handler for Zsh.
#
# Supported:
#   - Linux
#   - macOS
#
# No external dependencies.
# Everything is configured in this file.

# =============================================================================
# CONFIGURATION
# =============================================================================

# Roast level:
#   0 = disabled
#   1 = dry
#   2 = sarcastic
#   3 = hostile
typeset -gi ZSH_ROAST_LEVEL=2

# Percentage chance of displaying a roast.
typeset -gi ZSH_ROAST_CHANCE=100

# Theme:
#   mixed
#   unix
#   programmer
#   science
typeset -g ZSH_ROAST_THEME="mixed"

# Show the failed command.
typeset -gi ZSH_ROAST_SHOW_COMMAND=1

# Enable ANSI colors when supported.
typeset -gi ZSH_ROAST_COLOR=1

# Prefer command-specific jokes.
typeset -gi ZSH_ROAST_CONTEXTUAL=1

# Avoid immediately repeating random roasts.
typeset -gi ZSH_ROAST_AVOID_REPEATS=1

# Enable typo inference.
typeset -gi ZSH_ROAST_TYPO_DETECTION=1

# Maximum Damerau-Levenshtein distance:
#   1 = conservative
#   2 = recommended
#   3 = aggressive
typeset -gi ZSH_ROAST_MAX_TYPO_DISTANCE=2

# Show "Did you mean: ...?"
typeset -gi ZSH_ROAST_SHOW_SUGGESTION=1

# Search installed commands known to Zsh when no contextual match wins.
typeset -gi ZSH_ROAST_SEARCH_INSTALLED_COMMANDS=1

# For longer commands, installed-command search requires matching first char.
typeset -gi ZSH_ROAST_FIRST_CHAR_FILTER_LENGTH=5

# Custom messages.
typeset -ga ZSH_ROAST_CUSTOM=(
  "CERN computing has seen enough for today."
  "Linus would like a word."
)

# =============================================================================
# INTERNAL STATE
# =============================================================================

typeset -g _ZSH_ROAST_LAST_MESSAGE=""
typeset -g _ZSH_ROAST_LAST_SUGGESTION=""

# Detect OS without invoking uname.
#
# Zsh exposes $OSTYPE on both Linux and macOS:
#
#   linux-gnu
#   darwin23.0
#   darwin24.0
#   ...
typeset -g _ZSH_ROAST_OS="other"

case "$OSTYPE" in
  darwin*)
    _ZSH_ROAST_OS="macos"
    ;;
  linux*)
    _ZSH_ROAST_OS="linux"
    ;;
esac

# =============================================================================
# MESSAGE POOLS
# =============================================================================

typeset -ga ZSH_ROAST_DRY=(
  "Command not found. Neither was your documentation."
  "That command exists only in your imagination."
  "The shell checked. Still no."
  "Interesting command. Shame it doesn't exist."
  "I searched \$PATH. It has never heard of this."
  "Computer says no."
  "Bold syntax. Completely fictional."
  "That executable appears to be conceptual."
  "The command line equivalent of knocking on the wrong door."
  "Close. In the sense that the Moon is close."
  "An executable was expected. Creativity was received."
  "No implementation found for your proposed command."
  "The shell remains unconvinced."
)

typeset -ga ZSH_ROAST_SARCASTIC=(
  "Excellent command. Have you considered installing it?"
  "Ah yes, the famous 'make up a command and hope' strategy."
  "The shell admires your confidence."
  "Syntax powered entirely by optimism."
  "Another successful deployment to /dev/null."
  "Your command has been peer reviewed and rejected."
  "The compiler would like to distance itself from this."
  "I checked \$PATH twice. You're still wrong."
  "Outstanding. We have discovered a command nobody implemented."
  "Stack Overflow cannot save you from this one."
  "The terminal has forwarded your complaint to /dev/null."
  "Works on your machine? Apparently not."
  "This is technically a command in the same way pseudocode is technically software."
  "Confidence: high. Correctness: unavailable."
  "The command appears to be aspirational."
  "You typed it with such authority, too."
)

typeset -ga ZSH_ROAST_HOSTILE=(
  "The shell expected very little and you still managed to surprise it."
  "Your keyboard deserves better."
  "Somewhere, a sysadmin just felt a disturbance in the force."
  "Please stop inventing Unix commands."
  "Even Bash would judge you for that one."
  "The kernel has declined to participate in whatever this is."
  "You had one job: type an executable that exists."
  "The terminal is considering revoking your shell access."
  "Maybe test that hypothesis somewhere other than production."
  "This command has failed both technically and aesthetically."
  "Your \$PATH is innocent. This one's on you."
  "At least the typo was deterministic."
  "You somehow introduced undefined behavior before execution."
  "The shell has opened an incident report."
  "The failure occurred between keyboard and chair."
)

typeset -ga ZSH_ROAST_UNIX=(
  "grep found nothing, including evidence this command exists."
  "Every directory in \$PATH looked. Everyone agrees: no."
  "Even /dev/null wouldn't accept this."
  "POSIX has declined to comment."
  "The Unix philosophy recommends doing one thing well. This did zero things."
  "Your command has been SIGKILLed by reality."
  "Exit status 127: Unix for 'nice try.'"
  "The shell checked \$PATH and filed a missing-person report."
  "This belongs in /dev/null, recursively."
  "The man page is missing because so is the command."
  "No executable, no hope."
  "fork() declined to get involved."
  "The shell expanded everything except your chances of success."
  "ENOENT sends its regards."
)

typeset -ga ZSH_ROAST_PROGRAMMER=(
  "Works on nobody's machine."
  "Have you tried turning your command off and not typing it again?"
  "LGTM, except for the part where it doesn't exist."
  "Ship it. Preferably to another terminal."
  "That's not technical debt. That's technical bankruptcy."
  "The implementation appears to be left as an exercise for the user."
  "Your command passed zero tests with excellent consistency."
  "Undefined behavior would have been an improvement."
  "Production readiness: -1."
  "This bug has excellent reproduction steps."
  "Congratulations, you found an edge case called 'wrong command.'"
  "CI failed before CI even started."
  "The happy path has left the building."
  "The API contract did not include imaginary executables."
  "This commit would not survive code review."
  "The regression appears to be you."
)

typeset -ga ZSH_ROAST_SCIENCE=(
  "Your hypothesis has been experimentally falsified."
  "Result: 5 sigma evidence that this command does not exist."
  "The null hypothesis survives another day."
  "Your command has a cross section consistent with zero."
  "Statistically significant typo detected."
  "This result will not survive peer review."
  "The trigger rejected your command before reconstruction."
  "No executable candidate passed selection."
  "Your command is outside the detector acceptance."
  "We searched the full dataset. No evidence for this executable."
  "Systematic uncertainty cannot explain this."
  "Please rerun the analysis with a command that exists."
  "The observed significance of this executable is 0 sigma."
  "Background-only hypothesis strongly preferred."
  "This command failed the selection cuts."
  "The collaboration has declined to approve this result."
  "Your executable candidate has been classified as background."
  "We need more luminosity. Or a valid command."
)

# =============================================================================
# CONTEXTUAL COMMANDS
# =============================================================================

typeset -ga ZSH_ROAST_CONTEXT_COMMANDS=(
  git

  docker
  podman

  python
  python3
  pip
  pip3

  kubectl

  ssh
  scp
  rsync
  sshfs

  rm
  sudo

  make
  cmake
  meson
  ninja

  gcc
  g++
  clang
  clang++
  cc
  c++

  cargo
  rustc
  go

  npm
  npx
  node

  curl
  wget

  grep
  rg
  find

  vim
  nvim
  emacs
  code

  tmux

  zsh
  bash

  nvcc

  root

  ffmpeg
  ffprobe

  tar
  zip
  unzip

  brew

  systemctl
  journalctl
  service

  apt
  apt-get
  aptitude
  dpkg
  dnf
  yum
  pacman
  zypper
  apk

  launchctl
  open
  pbcopy
  pbpaste

  sbatch
  srun
)

# =============================================================================
# COLOR HANDLING
# =============================================================================

_zsh_roast_setup_colors() {
  if (( ZSH_ROAST_COLOR )) &&
     [[ -t 2 ]] &&
     [[ -z "${NO_COLOR:-}" ]] &&
     [[ "${TERM:-}" != "dumb" ]]; then

    typeset -g ZSH_ROAST_RED=$'\e[1;31m'
    typeset -g ZSH_ROAST_YELLOW=$'\e[1;33m'
    typeset -g ZSH_ROAST_DIM=$'\e[2m'
    typeset -g ZSH_ROAST_ITALIC=$'\e[3m'
    typeset -g ZSH_ROAST_RESET=$'\e[0m'
  else
    typeset -g ZSH_ROAST_RED=""
    typeset -g ZSH_ROAST_YELLOW=""
    typeset -g ZSH_ROAST_DIM=""
    typeset -g ZSH_ROAST_ITALIC=""
    typeset -g ZSH_ROAST_RESET=""
  fi
}

# =============================================================================
# CONFIG VALIDATION
# =============================================================================

_zsh_roast_validate_config() {
  (( ZSH_ROAST_LEVEL < 0 )) && ZSH_ROAST_LEVEL=0
  (( ZSH_ROAST_LEVEL > 3 )) && ZSH_ROAST_LEVEL=3

  (( ZSH_ROAST_CHANCE < 0 )) && ZSH_ROAST_CHANCE=0
  (( ZSH_ROAST_CHANCE > 100 )) && ZSH_ROAST_CHANCE=100

  (( ZSH_ROAST_MAX_TYPO_DISTANCE < 0 )) &&
    ZSH_ROAST_MAX_TYPO_DISTANCE=0

  (( ZSH_ROAST_MAX_TYPO_DISTANCE > 3 )) &&
    ZSH_ROAST_MAX_TYPO_DISTANCE=3

  (( ZSH_ROAST_FIRST_CHAR_FILTER_LENGTH < 1 )) &&
    ZSH_ROAST_FIRST_CHAR_FILTER_LENGTH=1

  case "$ZSH_ROAST_THEME" in
    mixed|unix|programmer|science)
      ;;
    *)
      ZSH_ROAST_THEME="mixed"
      ;;
  esac
}

# =============================================================================
# DAMERAU-LEVENSHTEIN DISTANCE
# =============================================================================

# Optimal-string-alignment Damerau-Levenshtein distance.
#
# Counts:
#
#   insertion
#   deletion
#   substitution
#   adjacent transposition
#
# Examples:
#
#   gti    -> git     = 1
#   pyhton -> python  = 1
#   cmkae  -> cmake   = 1

_zsh_roast_distance() {
  local a="$1"
  local b="$2"
  local -i max="${3:-999}"

  local -i len_a=${#a}
  local -i len_b=${#b}

  local -i i j
  local -i cost
  local -i deletion
  local -i insertion
  local -i substitution
  local -i transposition
  local -i value
  local -i row_min

  local -a previous_previous
  local -a previous
  local -a current

  if [[ "$a" == "$b" ]]; then
    print -r -- 0
    return 0
  fi

  if (( len_a == 0 )); then
    print -r -- "$len_b"
    return 0
  fi

  if (( len_b == 0 )); then
    print -r -- "$len_a"
    return 0
  fi

  if (( len_a - len_b > max || len_b - len_a > max )); then
    print -r -- $(( max + 1 ))
    return 0
  fi

  previous=()

  for (( j = 0; j <= len_b; ++j )); do
    previous[$(( j + 1 ))]=$j
  done

  previous_previous=()

  for (( i = 1; i <= len_a; ++i )); do
    current=()
    current[1]=$i
    row_min=$i

    for (( j = 1; j <= len_b; ++j )); do
      if [[ "${a[i]}" == "${b[j]}" ]]; then
        cost=0
      else
        cost=1
      fi

      deletion=$(( previous[j + 1] + 1 ))
      insertion=$(( current[j] + 1 ))
      substitution=$(( previous[j] + cost ))

      value=$deletion

      (( insertion < value )) &&
        value=$insertion

      (( substitution < value )) &&
        value=$substitution

      if (( i > 1 && j > 1 )) &&
         [[ "${a[i]}" == "${b[j - 1]}" ]] &&
         [[ "${a[i - 1]}" == "${b[j]}" ]]; then

        transposition=$(( previous_previous[j - 1] + 1 ))

        (( transposition < value )) &&
          value=$transposition
      fi

      current[$(( j + 1 ))]=$value

      (( value < row_min )) &&
        row_min=$value
    done

    if (( row_min > max )); then
      print -r -- $(( max + 1 ))
      return 0
    fi

    previous_previous=("${previous[@]}")
    previous=("${current[@]}")
  done

  print -r -- "${previous[$(( len_b + 1 ))]}"
}

# =============================================================================
# CANDIDATE DISTANCE
# =============================================================================

_zsh_roast_candidate_distance() {
  local typed="$1"
  local candidate="$2"
  local -i max="$3"

  local -i typed_len=${#typed}
  local -i candidate_len=${#candidate}
  local -i difference
  local -i distance

  [[ -n "$candidate" ]] || return 1
  [[ "$typed" == "$candidate" ]] && return 1

  difference=$(( typed_len - candidate_len ))
  (( difference < 0 )) &&
    difference=$(( -difference ))

  (( difference > max )) &&
    return 1

  distance="$(
    _zsh_roast_distance \
      "$typed" \
      "$candidate" \
      "$max"
  )"

  (( distance <= max )) ||
    return 1

  print -r -- "$distance"
}

# =============================================================================
# TYPO INFERENCE
# =============================================================================

_zsh_roast_find_typo() {
  local typed="${1:t}"

  local candidate
  local best=""
  local second_best=""

  local -i distance
  local -i best_distance
  local -i second_best_distance
  local -i max="$ZSH_ROAST_MAX_TYPO_DISTANCE"

  (( ZSH_ROAST_TYPO_DETECTION )) ||
    return 1

  (( max > 0 )) ||
    return 1

  # Very short commands generate too many false positives.
  (( ${#typed} >= 3 )) ||
    return 1

  best_distance=$(( max + 1 ))
  second_best_distance=$(( max + 1 ))

  # -------------------------------------------------------------------------
  # Phase 1: contextual commands
  # -------------------------------------------------------------------------

  for candidate in "${ZSH_ROAST_CONTEXT_COMMANDS[@]}"; do
    distance="$(
      _zsh_roast_candidate_distance \
        "$typed" \
        "$candidate" \
        "$max"
    )" || continue

    if (( distance < best_distance )); then
      second_best="$best"
      second_best_distance=$best_distance

      best="$candidate"
      best_distance=$distance

    elif [[ "$candidate" != "$best" ]] &&
         (( distance < second_best_distance )); then
      second_best="$candidate"
      second_best_distance=$distance
    fi
  done

  # Distance 1 against one of our high-value contextual commands is
  # sufficiently strong to accept directly.
  if [[ -n "$best" ]] &&
     (( best_distance == 1 )); then
    print -r -- "$best"
    return 0
  fi

  # -------------------------------------------------------------------------
  # Phase 2: commands currently known to Zsh
  # -------------------------------------------------------------------------

  if (( ZSH_ROAST_SEARCH_INSTALLED_COMMANDS )); then

    # Refresh the Zsh command hash.
    #
    # `rehash` is a Zsh builtin. This is portable between Linux and macOS
    # and does not spawn any external utilities.
    rehash

    for candidate in ${(k)commands}; do
      [[ -n "$candidate" ]] ||
        continue

      [[ "$typed" == "$candidate" ]] &&
        continue

      # Cheap first-character heuristic for longer names.
      if (( ${#typed} >= ZSH_ROAST_FIRST_CHAR_FILTER_LENGTH )) &&
         [[ "${typed[1]}" != "${candidate[1]}" ]]; then
        continue
      fi

      distance="$(
        _zsh_roast_candidate_distance \
          "$typed" \
          "$candidate" \
          "$max"
      )" || continue

      if (( distance < best_distance )); then
        second_best="$best"
        second_best_distance=$best_distance

        best="$candidate"
        best_distance=$distance

      elif [[ "$candidate" != "$best" ]] &&
           (( distance < second_best_distance )); then
        second_best="$candidate"
        second_best_distance=$distance
      fi
    done
  fi

  [[ -n "$best" ]] ||
    return 1

  (( best_distance <= max )) ||
    return 1

  # If two candidates tie at distance > 1, decline to guess.
  if (( best_distance > 1 )) &&
     [[ -n "$second_best" ]] &&
     (( second_best_distance == best_distance )); then
    return 1
  fi

  print -r -- "$best"
}

# =============================================================================
# CONTEXTUAL ROASTS
# =============================================================================

_zsh_roast_contextual() {
  local cmd="${1:t}"

  case "$cmd" in
    git)
      print -r -- "Git cannot save you from this."
      ;;

    docker|podman)
      print -r -- "Container not found. Command not found. Confidence remains inexplicably high."
      ;;

    python|python3)
      print -r -- "Not even Python's dynamic typing can make that command exist."
      ;;

    pip|pip3)
      print -r -- "Have you tried installing increasingly random packages until the error changes?"
      ;;

    kubectl)
      print -r -- "Kubernetes is complicated enough without inventing new commands."
      ;;

    ssh)
      print -r -- "Good news: you failed before reaching the remote machine."
      ;;

    scp|rsync)
      print -r -- "The data transfer has been optimized to zero bytes."
      ;;

    sshfs)
      print -r -- "The remote filesystem remains safely unmounted."
      ;;

    rm)
      print -r -- "For once, I'm glad that command doesn't exist."
      ;;

    sudo)
      print -r -- "Root privileges would not improve this decision."
      ;;

    make|cmake|meson|ninja)
      print -r -- "The build system cannot build a command that exists only in your heart."
      ;;

    gcc|g++|clang|clang++|cc|c++)
      print -r -- "Compilation failed at an unusually early stage: finding the compiler."
      ;;

    cargo|rustc)
      print -r -- "The borrow checker is innocent this time."
      ;;

    go)
      print -r -- "Go prefers explicit errors. Here is one."
      ;;

    npm|npx|node)
      print -r -- "Not even node_modules contains this one."
      ;;

    curl|wget)
      print -r -- "The network is fine. The command is the outage."
      ;;

    grep|rg)
      print -r -- "Search completed: zero matches for a valid executable."
      ;;

    find)
      print -r -- "find: unable to locate your command or your judgment."
      ;;

    vim|nvim)
      print -r -- "You cannot exit Vim because you haven't managed to enter it."
      ;;

    emacs)
      print -r -- "Emacs could probably do this, if only you could invoke it."
      ;;

    code)
      print -r -- "VS Code cannot autocomplete commands you hallucinated."
      ;;

    tmux)
      print -r -- "No session exists in which this command makes sense."
      ;;

    zsh)
      print -r -- "Zsh has reviewed your attempt to invoke Zsh and found it wanting."
      ;;

    bash)
      print -r -- "Even Bash would have rejected that."
      ;;

    root)
      print -r -- "ROOT has enough undefined behavior already."
      ;;

    nvcc)
      print -r -- "GPU acceleration will not make this mistake useful."
      ;;

    ffmpeg|ffprobe)
      print -r -- "The codec is not the problem this time."
      ;;

    tar)
      print -r -- "The archive contains everything except this executable."
      ;;

    zip|unzip)
      print -r -- "Compression cannot reduce this mistake any further."
      ;;

    brew)
      if [[ "$_ZSH_ROAST_OS" == "macos" ]]; then
        print -r -- "Homebrew cannot ferment a command you invented."
      else
        print -r -- "Linuxbrew cannot rescue this command either."
      fi
      ;;

    systemctl|journalctl|service)
      if [[ "$_ZSH_ROAST_OS" == "macos" ]]; then
        print -r -- "Wrong operating system. macOS would like you to meet launchd."
      else
        print -r -- "systemd has enough problems without this one."
      fi
      ;;

    apt|apt-get|aptitude|dpkg)
      if [[ "$_ZSH_ROAST_OS" == "macos" ]]; then
        print -r -- "APT on macOS? Bold choice."
      else
        print -r -- "Package management cannot install common sense."
      fi
      ;;

    dnf|yum)
      print -r -- "The RPM database has no package for this decision."
      ;;

    pacman)
      print -r -- "Arch users are expected to read the wiki before inventing commands."
      ;;

    zypper)
      print -r -- "Even openSUSE cannot package this command."
      ;;

    apk)
      print -r -- "Alpine is minimal. Your command is even more minimal: it doesn't exist."
      ;;

    launchctl)
      if [[ "$_ZSH_ROAST_OS" == "macos" ]]; then
        print -r -- "launchd has declined to launch your imagination."
      else
        print -r -- "launchctl wandered very far from macOS."
      fi
      ;;

    open)
      if [[ "$_ZSH_ROAST_OS" == "macos" ]]; then
        print -r -- "Finder cannot open something that does not exist."
      else
        print -r -- "This isn't macOS. Try not to summon Finder here."
      fi
      ;;

    pbcopy|pbpaste)
      if [[ "$_ZSH_ROAST_OS" == "macos" ]]; then
        print -r -- "The clipboard would prefer valid commands."
      else
        print -r -- "The macOS clipboard utilities appear to be geographically lost."
      fi
      ;;

    sbatch|srun)
      print -r -- "The scheduler rejected your job before you even submitted it."
      ;;

    *)
      return 1
      ;;
  esac

  return 0
}

# =============================================================================
# BUILD MESSAGE POOL
# =============================================================================

_zsh_roast_build_pool() {
  local -a pool

  case "$ZSH_ROAST_THEME" in
    unix)
      pool=(
        "${ZSH_ROAST_UNIX[@]}"
      )
      ;;

    programmer)
      pool=(
        "${ZSH_ROAST_PROGRAMMER[@]}"
      )
      ;;

    science)
      pool=(
        "${ZSH_ROAST_SCIENCE[@]}"
      )
      ;;

    mixed|*)
      case "$ZSH_ROAST_LEVEL" in
        1)
          pool=(
            "${ZSH_ROAST_DRY[@]}"
            "${ZSH_ROAST_UNIX[@]}"
          )
          ;;

        2)
          pool=(
            "${ZSH_ROAST_DRY[@]}"
            "${ZSH_ROAST_SARCASTIC[@]}"
            "${ZSH_ROAST_UNIX[@]}"
            "${ZSH_ROAST_PROGRAMMER[@]}"
            "${ZSH_ROAST_SCIENCE[@]}"
          )
          ;;

        3)
          pool=(
            "${ZSH_ROAST_SARCASTIC[@]}"
            "${ZSH_ROAST_HOSTILE[@]}"
            "${ZSH_ROAST_UNIX[@]}"
            "${ZSH_ROAST_PROGRAMMER[@]}"
            "${ZSH_ROAST_SCIENCE[@]}"
          )
          ;;
      esac
      ;;
  esac

  if (( ${#ZSH_ROAST_CUSTOM[@]} )); then
    pool+=("${ZSH_ROAST_CUSTOM[@]}")
  fi

  reply=("${pool[@]}")
}

# =============================================================================
# RANDOM MESSAGE SELECTION
# =============================================================================

_zsh_roast_pick() {
  local -a pool
  local roast=""
  local -i attempts=0
  local -i max_attempts=8
  local -i index

  _zsh_roast_build_pool
  pool=("${reply[@]}")

  (( ${#pool[@]} )) ||
    return 1

  while (( attempts < max_attempts )); do
    index=$(( RANDOM % ${#pool[@]} + 1 ))
    roast="${pool[$index]}"

    if (( ! ZSH_ROAST_AVOID_REPEATS )) ||
       [[ "$roast" != "$_ZSH_ROAST_LAST_MESSAGE" ]] ||
       (( ${#pool[@]} == 1 )); then
      break
    fi

    (( attempts++ ))
  done

  _ZSH_ROAST_LAST_MESSAGE="$roast"

  print -r -- "$roast"
}

# =============================================================================
# SELECT MESSAGE
# =============================================================================

_zsh_roast_select_message() {
  local typed="${1:t}"
  local intended=""
  local roast=""

  _ZSH_ROAST_LAST_SUGGESTION=""

  if (( ZSH_ROAST_TYPO_DETECTION )); then
    intended="$(_zsh_roast_find_typo "$typed")" ||
      intended=""
  fi

  if [[ -n "$intended" ]]; then
    _ZSH_ROAST_LAST_SUGGESTION="$intended"

    if (( ZSH_ROAST_CONTEXTUAL )); then
      roast="$(_zsh_roast_contextual "$intended")" && {
        _ZSH_ROAST_LAST_MESSAGE="$roast"
        print -r -- "$roast"
        return 0
      }
    fi
  fi

  if (( ZSH_ROAST_CONTEXTUAL )); then
    roast="$(_zsh_roast_contextual "$typed")" && {
      _ZSH_ROAST_LAST_MESSAGE="$roast"
      print -r -- "$roast"
      return 0
    }
  fi

  _zsh_roast_pick
}

# =============================================================================
# DISPLAY
# =============================================================================

_zsh_roast_display() {
  local command_name="$1"
  local roast

  (( ZSH_ROAST_LEVEL > 0 )) ||
    return 0

  (( RANDOM % 100 < ZSH_ROAST_CHANCE )) ||
    return 0

  roast="$(_zsh_roast_select_message "$command_name")" ||
    return 0

  printf '\n' >&2

  printf '%s%s%s%s\n' \
    "$ZSH_ROAST_RED" \
    "$ZSH_ROAST_ITALIC" \
    "$roast" \
    "$ZSH_ROAST_RESET" >&2

  if (( ZSH_ROAST_SHOW_COMMAND )); then
    printf '%scommand not found: %s%s\n' \
      "$ZSH_ROAST_DIM" \
      "$command_name" \
      "$ZSH_ROAST_RESET" >&2
  fi

  if (( ZSH_ROAST_SHOW_SUGGESTION )) &&
     [[ -n "$_ZSH_ROAST_LAST_SUGGESTION" ]]; then

    printf '%sDid you mean: %s?%s\n' \
      "$ZSH_ROAST_YELLOW" \
      "$_ZSH_ROAST_LAST_SUGGESTION" \
      "$ZSH_ROAST_RESET" >&2
  fi

  printf '\n' >&2
}

# =============================================================================
# PRESERVE EXISTING COMMAND-NOT-FOUND HANDLER
# =============================================================================

# Ubuntu, Debian, Oh My Zsh plugins, and other environments may already
# provide command_not_found_handler.
#
# Preserve it rather than silently replacing it.

if (( ${+functions[command_not_found_handler]} )) &&
   (( ! ${+functions[_zsh_roast_previous_command_not_found_handler]} )); then

  functions[_zsh_roast_previous_command_not_found_handler]=\
"${functions[command_not_found_handler]}"
fi

# =============================================================================
# MAIN HANDLER
# =============================================================================

command_not_found_handler() {
  local command_name="$1"
  local -i previous_status

  _zsh_roast_validate_config
  _zsh_roast_setup_colors

  _zsh_roast_display "$command_name"

  if (( ${+functions[_zsh_roast_previous_command_not_found_handler]} )); then
    _zsh_roast_previous_command_not_found_handler "$@"
    previous_status=$?

    (( previous_status != 0 )) &&
      return "$previous_status"
  fi

  return 127
}

# =============================================================================
# INITIALIZATION
# =============================================================================

_zsh_roast_validate_config
_zsh_roast_setup_colors
