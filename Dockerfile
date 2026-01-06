# Pakai base image Node.js versi stabil
FROM node:18-alpine

# Bikin folder kerja di dalam container
WORKDIR /app

# Copy package.json dulu biar cache-nya jalan (biar build cepet)
COPY package.json .

# Install library
RUN npm install

# Copy semua sisa file (server.js, dll)
COPY . .

# Buka port 3000
EXPOSE 4321

# Jalanin servernya
CMD ["node", "server.js"]