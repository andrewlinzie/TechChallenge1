# Use lightweight Node image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json + package-lock.json
COPY package*.json ./

# Install only production deps
RUN npm install --production

# Copy the rest of the code
COPY . .

# Expose backend port (usually 8080)
EXPOSE 8080

# Start the server
CMD ["npm", "start"]
