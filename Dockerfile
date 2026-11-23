FROM node:20-bookworm-slim

# Install redis-server and essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    redis-server \
    ca-certificates \
    curl \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy root backend package files
COPY backend/package*.json ./
RUN npm install --omit=dev

# Install dependencies for gateway
COPY backend/gateway/package*.json ./gateway/
RUN cd gateway && npm install --omit=dev

# Install dependencies for auth
COPY backend/services/auth/package*.json ./services/auth/
RUN cd services/auth && npm install --omit=dev

# Install dependencies for chat
COPY backend/services/chat/package*.json ./services/chat/
RUN cd services/chat && npm install --omit=dev

# Install dependencies for agent
COPY backend/services/agent/package*.json ./services/agent/
RUN cd services/agent && npm install --omit=dev

# Install dependencies for billing
COPY backend/services/billing/package*.json ./services/billing/
RUN cd services/billing && npm install --omit=dev

# Copy application code
COPY backend/shared ./shared
COPY backend/gateway ./gateway
COPY backend/services ./services

# Copy startup script
COPY backend/start.sh ./start.sh
RUN chmod +x ./start.sh

EXPOSE 8000 10000

CMD ["./start.sh"]
