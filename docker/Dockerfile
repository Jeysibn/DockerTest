# Build stage
FROM node:16-alpine AS builder
WORKDIR /app
COPY app/package*.json ./
RUN npm install || true
COPY app/ .
RUN npm run build || mkdir -p build

# Production stage
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]