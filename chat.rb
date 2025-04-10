# Write your solution here!
pp "howdy!"

require "openai"
require "dotenv/load"

client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

# Step 1: Set up the system message
message_list = [
  {
    "role" => "system",
    "content" => "You are a helpful assistant. Start by greeting the user with 'Hello! How can I help you today?'At the end of the sentence, display 50 '-' signs."
  }
]

# First API call — get the greeting
greeting_response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: message_list
  }
)

# Extract and show the assistant's greeting
assistant_greeting = greeting_response.dig("choices", 0, "message")
puts "Assistant: #{assistant_greeting["content"]}"

# Step 2: Prompt the user
print "You: "
user_input = gets.chomp

# Add the assistant's greeting and user's input to the message history
message_list << assistant_greeting
message_list << {
  "role" => "user",
  "content" => user_input
}

# Second API call — get assistant's response to the user's input
response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: message_list
  }
)

# Show assistant's actual answer (no greeting)
puts "Assistant: #{response.dig("choices", 0, "message", "content")}"
