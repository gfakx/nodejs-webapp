# Base Image
FROM node:lts-alpine3.17
# Set the working Directory
WORKDIR /app
# Copy Package.json
COPY package*.json ./
# Install Dependencies
RUN npm install
# Copy source code to the container work directory
COPY . .
# Expose Port
EXPOSE 3000
# Entry for CMD
CMD [ "node", "server.js" ]
