
# Stage 1: Builder

FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependency files first (better caching)
COPY app/frontend/package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY app/frontend/ .

# Build Next.js app
RUN npm run build


# Stage 2: Runtime

FROM node:20-alpine

WORKDIR /app

# Set production environment
ENV NODE_ENV=production

# Copy only build output and deps
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package*.json ./

# Install only production dependencies
RUN npm install --omit=dev

EXPOSE 3000

CMD ["npm", "start"]
