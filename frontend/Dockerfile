# ---------- Stage 1: Build React App ----------
    FROM node:16-alpine AS build

    # Set working directory
    WORKDIR /app
    
    # Copy package.json and install deps
    COPY package*.json ./
    RUN npm install
    
    # Copy rest of code and build the app
    COPY . .
    RUN npm run build
    
    
    # ---------- Stage 2: NGINX Web Server ----------
    FROM nginx:alpine
    
    # Copy React build output from previous stage
    COPY --from=build /app/build /usr/share/nginx/html
    
    # Expose port 80 for the frontend
    EXPOSE 80
    
    # Start NGINX
    CMD ["nginx", "-g", "daemon off;"]
    