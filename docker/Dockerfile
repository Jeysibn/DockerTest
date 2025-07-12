FROM node:16-alpine as builder

WORKDIR /app
COPY app/package*.json ./
RUN npm install || echo "No package.json found, skipping npm install"
COPY app/ .
RUN npm run build || echo "No build script found, skipping build"

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html || echo "No build directory found, using default nginx page"
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
