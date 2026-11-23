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
COPY package*.json ./
RUN npm install --omit=dev

# Install dependencies for gateway
COPY gateway/package*.json ./gateway/
RUN cd gateway && npm install --omit=dev

# Install dependencies for auth
COPY services/auth/package*.json ./services/auth/
RUN cd services/auth && npm install --omit=dev

# Install dependencies for chat
COPY services/chat/package*.json ./services/chat/
RUN cd services/chat && npm install --omit=dev

# Install dependencies for agent
COPY services/agent/package*.json ./services/agent/
RUN cd services/agent && npm install --omit=dev

# Install dependencies for billing
COPY services/billing/package*.json ./services/billing/
RUN cd services/billing && npm install --omit=dev

# Copy application code
COPY shared ./shared
COPY gateway ./gateway
COPY services ./services

# Copy startup script
COPY start.sh ./start.sh
RUN chmod +x ./start.sh

EXPOSE 8000 10000

CMD ["./start.sh"]
