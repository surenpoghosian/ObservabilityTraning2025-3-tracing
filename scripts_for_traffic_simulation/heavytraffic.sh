#!/bin/bash

API_URL="http://localhost:3000"
END_TIME=$((SECONDS + 120)) # run for ~2 minutes
CONCURRENT_USERS=20

echo "🚀 Starting traffic storm at $API_URL for ~2 minutes with $CONCURRENT_USERS users..."

# Prepopulate some users
for i in $(seq 1 10); do
  curl -s -X POST "$API_URL/users" \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"User$i\", \"email\": \"user$i@example.com\"}" > /dev/null
done

# Function for one simulated user session
user_session() {
  while [ $SECONDS -lt $END_TIME ]; do
    ACTION=$((RANDOM % 6))
    ID=$((RANDOM % 30 + 1))
    case $ACTION in
      0) # List users
         curl -s "$API_URL/users" > /dev/null ;;
      1) # Get user by ID
         curl -s "$API_URL/users/$ID" > /dev/null ;;
      2) # Create a user
         curl -s -X POST "$API_URL/users" \
              -H "Content-Type: application/json" \
              -d "{\"name\": \"Bot$RANDOM\", \"email\": \"bot$RANDOM@example.com\"}" > /dev/null ;;
      3) # Update user
         curl -s -X PUT "$API_URL/users/$ID" \
              -H "Content-Type: application/json" \
              -d "{\"name\": \"Updated$RANDOM\", \"email\": \"updated$RANDOM@example.com\"}" > /dev/null ;;
      4) # Delete user
         curl -s -X DELETE "$API_URL/users/$ID" > /dev/null ;;
      5) # Health check
         curl -s "$API_URL/health" > /dev/null ;;
    esac

    # Random wait to simulate real user timing
    sleep $(awk -v min=0.1 -v max=0.5 'BEGIN{srand(); print min+rand()*(max-min)}')
  done
}

# Launch multiple user sessions in parallel
for i in $(seq 1 $CONCURRENT_USERS); do
  user_session &
done

wait
echo "✅ Storm complete. Observability system now full of juicy data."
