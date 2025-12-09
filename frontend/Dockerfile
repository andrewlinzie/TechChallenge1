# ---------- Stage 1: Build React App ----------
    FROM node:16-alpine AS build

    WORKDIR /app
    
    # Copy package.json first (keeps npm install cached)
    COPY package*.json ./
    RUN npm install
    
    # CACHE BUST (forces rebuild)
    ARG CACHE_BREAK=1
    
    # Copy rest of app
    COPY . .
    RUN npm run build
    
    # ---------- Stage 2: NGINX Web Server ----------
    FROM nginx:alpine
    
    COPY --from=build /app/build /usr/share/nginx/html
    EXPOSE 80
    CMD ["nginx", "-g", "daemon off;"]
    