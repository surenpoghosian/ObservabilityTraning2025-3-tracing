#!/bin/bash

API_URL="http://localhost:3000"
END_TIME=$((SECONDS + 120)) # run for ~2 minutes
NORMAL_USERS=15
CHAOTIC_USERS=5
SPIKE_INTERVAL=20 # every 20 seconds, we spike

echo "🚀 Starting chaos traffic to $API_URL for ~2 minutes..."
echo "👥 Normal users: $NORMAL_USERS | 🔥 Chaos users: $CHAOTIC_USERS"

# Prepopulate users
for i in $(seq 1 10); do
  curl -s -X POST "$API_URL/users" \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"SeedUser$i\", \"email\": \"seed$i@example.com\"}" > /dev/null
done

# Normal user traffic (steady)
normal_user() {
  while [ $SECONDS -lt $END_TIME ]; do
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
    sleep $(awk -v min=0.3 -v max=0.8 'BEGIN{srand(); print min+rand()*(max-min)}')
  done
}

# Chaotic spike traffic (random spikes every SPIKE_INTERVAL seconds)
chaotic_user() {
  while [ $SECONDS -lt $END_TIME ]; do
    if (( SECONDS % SPIKE_INTERVAL < 5 )); then
      # SPIKE MODE: blast the API with 20 requests very fast
      for i in {1..20}; do
        ID=$((RANDOM % 100 + 1))
        curl -s -X GET "$API_URL/users/$ID" > /dev/null &
        curl -s "$API_URL/users" > /dev/null &
        curl -s "$API_URL/health" > /dev/null &
      done
      wait
      sleep 1
    else
      # Low-frequency noise outside of spikes
      curl -s "$API_URL/health" > /dev/null
      sleep 0.5
    fi
  done
}

# Launch normal users
for i in $(seq 1 $NORMAL_USERS); do
  normal_user &
done

# Launch chaos users
for i in $(seq 1 $CHAOTIC_USERS); do
  chaotic_user &
done

wait
echo "✅ Chaos complete — go enjoy your dashboards!"
