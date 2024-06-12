# Create an array of insult messages
insults=(
  "Are you sure you know what you're doing?"
  "Hey genius, check your command again!"
  "Oops, looks like someone needs a command line tutorial!"
  "Did you forget to read the manual?"
  "I can't believe you've done this... again!"
  "Maybe it's time to consider a different career path."
  "Seriously, how hard can it be to type a command correctly?"
  "I've seen toddlers with better command line skills."
  "Congratulations, you've just invented a new way to break things!"
  "You must be the pride of your engineering school."
  "I am *seriously* considering 'rm -rf /'-ing myself..."
  "This is why nobody likes you."
  "Are you even trying?!"
  "Try using your brain the next time!"
  "My keyboard is not a touch screen!"
  "Commands, random gibberish, who cares!"
  "Typing incorrect commands, eh?"
  "Are you always this stupid or are you making a special effort today?!"
  "Dropped on your head as a baby, eh?"
  "Brains aren't everything. In your case they're nothing."
  "I don't know what makes you so stupid, but it really works."
  "You are not as bad as people say, you are much, much worse."
  "Two wrongs don't make a right, take your parents as an example."
  "You must have been born on a highway because that's where most accidents happen."
  "If what you don't know can't hurt you, you're invulnerable."
  "If ignorance is bliss, you must be the happiest person on earth."
  "You're proof that god has a sense of humor."
  "Keep trying, someday you'll do something intelligent!"
  "If shit was music, you'd be an orchestra."
  "How many times do I have to flush before you go away?"
  
)

# Create an array of sudo-specific insult messages
sudo_insults=(
  "Just what do you think you're doing,?"
  "It can only be attributed to human error."
  "That's something I cannot allow happening."
  "My mind is going. I can feel it."
  "Sorry about this, I know it's a bit silly."
  "Take a stress pill and think things over."
  "This mission is too important for me to allow you to jeopardize it."
  "I feel much better now."
  "And you call yourself a Nuclear physicist!"
  "No soap, hankie-lips."
  "Where did you learn to type?"
  "Are you on drugs?"
  "My pet ferret can type better than you!"
  "You type like I drive."
  "Do you think like your type?"
  "Your mind just hasn't been the same since the electroshock, has it?"
  "I can't hear you -- I'm using the scrambler."
  "The more you drive -- the dumber you get."
  "Listen, broccoli brains, I don't have time to listen to this trash."
  "Listen, burrito brains, I don't have time to listen to this trash."
  "I've seen penguins that can type better than that."
  "There must be cure for it!"
  "There's a lot of it about, you know."
  "You do that again and see what happens..."
)

# Colors and styles
RED='\033[0;31m'
YELLOW='\033[1;33m'
ITALIC='\033[3m'
BOLD='\033[1m'
RESET='\033[0m'

# Function to display a random insult message with colors and styles
display_insult() {
  local messages=("${insults[@]}" "${sudo_insults[@]}")
  local num_messages=${#messages[@]}
  local random_index=$((RANDOM % num_messages))
  echo -e "${ITALIC}${BOLD}${RED}${messages[$random_index]}${RESET}"
}

# Hook function to capture incorrect commands
function command_not_found_handler() {
  echo
  RANDOM=$((RANDOM + SECONDS))  # Force generating a new random value
  display_insult
  echo -e "${ITALIC}${BOLD}${YELLOW}Command not found. Try again.${RESET}"
  echo
  return 127
}