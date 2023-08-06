# Base Image
FROM node:lts-alpine3.17

# Set the working Directory
WORKDIR /app

# Create a user named "appuser" and switch to that user
RUN adduser -D appuser
USER appuser

# Copy only the package files first
COPY package*.json ./

# Install Dependencies
RUN npm install

# Copy the rest of the application
COPY --chown=appuser:appuser . .

# Expose Port
EXPOSE 3000

# Entry for CMD
CMD [ "node", "server.js" ]
