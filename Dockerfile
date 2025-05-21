# Use Node.js 16 as the base image (as specified in .nvmrc)
FROM node:16-alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy project files
COPY . .

# Build the static site
RUN npm run build

# Use nginx to serve the static site
FROM nginx:alpine

# Copy the built static site from the previous stage
COPY --from=0 /app/_site /usr/share/nginx/html

# Copy a custom nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
