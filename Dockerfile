# Base
FROM node:14-alpine as build

WORKDIR /app

# Dependencies
COPY package*.json ./
RUN npm install --only-production \
    && npm cache clean --force

# Build
COPY . .

RUN npm run build \
    && npm prune --production \
    && mkdir build \
    && cp -r node_modules/ dist/ build

# Application
FROM node:14-alpine

WORKDIR /app
COPY --from=build /app/build .

USER node
ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["node", "dist/main"]
