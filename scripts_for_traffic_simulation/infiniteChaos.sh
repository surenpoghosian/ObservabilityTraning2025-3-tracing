#!/bin/bash

API_URL="http://localhost:3000"
NORMAL_USERS=50
CHAOTIC_USERS=250
SPIKE_INTERVAL=20 # every 20s
SEED_USERS=10

echo "🚀 Infinite chaos begins... hit Ctrl+C to stop."
echo "👥 Normal users: $NORMAL_USERS | 🔥 Chaos users: $CHAOTIC_USERS"

# Prepopulate some users
for i in $(seq 1 $SEED_USERS); do
  curl -s -X POST "$API_URL/users" \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"SeedUser$i\", \"email\": \"seed$i@example.com\"}" > /dev/null
done

# Normal users = realistic, slower requests
normal_user() {
  while true; do
    ID=$((RANDOM % 50 + 1))
    ACTION=$((RANDOM % 5))
    case $ACTION in
      0) curl -s "$API_URL/users" > /dev/null ;;
      1) curl -s "$API_URL/users/$ID" > /dev/null ;;
      2) curl -s -X POST "$API_URL/users" \
             -H "Content-Type: application/json" \
             -d "{\"name\": \"User$RANDOM\", \"email\": \"user$RANDOM@example.com\"}" > /dev/null ;;
      3) curl -s -X PUT "$API_URL/users/$ID" \
             -H "Content-Type: application/json" \
             -d "{\"name\": \"Updated$RANDOM\", \"email\": \"updated$RANDOM@example.com\"}" > /dev/null ;;
      4) curl -s -X DELETE "$API_URL/users/$ID" > /dev/null ;;
    esac
    sleep $(awk -v min=0.3 -v max=0.9 'BEGIN{srand(); print min+rand()*(max-min)}')
  done
}

# Chaos users = controlled spike traffic
chaotic_user() {
  local last_spike=$SECONDS
  while true; do
    local now=$SECONDS
    if (( now - last_spike >= SPIKE_INTERVAL )); then
      echo "💥 Spike triggered at $(date +%T)"
      for i in {1..50}; do
        ID=$((RANDOM % 100 + 1))
        curl -s -X GET "$API_URL/users/$ID" > /dev/null &
        curl -s "$API_URL/users" > /dev/null &
        curl -s "$API_URL/health" > /dev/null &
        curl -s -X DELETE "$API_URL/users/$ID" > /dev/null &
      done
      wait
      last_spike=$SECONDS
    else
      curl -s "$API_URL/health" > /dev/null
      sleep 0.5
    fi
  done
}

# Launch normal traffic threads
for i in $(seq 1 $NORMAL_USERS); do
  normal_user &
done

# Launch chaos threads
for i in $(seq 1 $CHAOTIC_USERS); do
  chaotic_user &
done

# Wait for Ctrl+C
wait
