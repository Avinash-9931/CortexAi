#!/bin/bash

# Trap signals for graceful shutdown
cleanup() {
    echo "Shutting down CortexAI services..."
    kill $(jobs -p) 2>/dev/null || true
    exit 0
}
trap cleanup SIGTERM SIGINT

echo "=== Starting CortexAI Backend Unified Container ==="

# 1. Start local Redis if REDIS_URL points to localhost, 127.0.0.1, or is not provided
if [ -z "$REDIS_URL" ] || echo "$REDIS_URL" | grep -q "localhost\|127.0.0.1"; then
    echo "Starting local Redis server..."
    redis-server --daemonize yes
    export REDIS_URL="redis://127.0.0.1:6379"
fi

# 2. Set internal service endpoints
export AUTH_SERVICE="${AUTH_SERVICE:-http://127.0.0.1:8001}"
export CHAT_SERVICE="${CHAT_SERVICE:-http://127.0.0.1:8002}"
export AGENT_SERVICE="${AGENT_SERVICE:-http://127.0.0.1:8003}"
export BILLING_SERVICE="${BILLING_SERVICE:-http://127.0.0.1:8004}"

# Save Render's public PORT for Gateway (defaults to 8000 or Render's $PORT)
GATEWAY_PORT="${PORT:-8000}"

# 3. Start microservices with their dedicated internal ports
echo "Starting Auth Service on port 8001..."
AUTH_PORT=8001 node services/auth/index.js &

echo "Starting Chat Service on port 8002..."
CHAT_PORT=8002 node services/chat/index.js &

echo "Starting Agent Service on port 8003..."
AGENT_PORT=8003 node services/agent/index.js &

echo "Starting Billing Service on port 8004..."
BILLING_PORT=8004 node services/billing/index.js &

# Wait for background services to initialize
sleep 2

# 4. Start API Gateway on Render's public port
echo "Starting API Gateway on public port ${GATEWAY_PORT}..."
PORT="${GATEWAY_PORT}" node gateway/index.js &

# Wait for any process to exit
wait -n
exit $?
