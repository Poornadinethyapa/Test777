# Multi-stage build for frontend
FROM node:18-alpine AS frontend-builder

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm ci

COPY frontend/ ./
RUN npm run build

# Production image
FROM node:18-alpine

WORKDIR /app

# Install only production dependencies
COPY frontend/package*.json ./
RUN npm ci --only=production

# Copy built files
COPY --from=frontend-builder /app/frontend/.next ./.next
COPY --from=frontend-builder /app/frontend/public ./public
COPY --from=frontend-builder /app/frontend/next.config.js ./
COPY --from=frontend-builder /app/frontend/package.json ./

EXPOSE 3000

ENV NODE_ENV=production

CMD ["npm", "start"]

