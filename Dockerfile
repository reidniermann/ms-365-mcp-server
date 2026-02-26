FROM node:24-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm i

COPY . .
RUN npm run generate
RUN npm run build

FROM node:20-alpine AS release

WORKDIR /app

COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package*.json ./

ENV NODE_ENV=production
RUN npm i --ignore-scripts --omit=dev

EXPOSE 3000

ENTRYPOINT ["node", "dist/index.js", "--http", "0.0.0.0:3000", "--org-mode", "--enable-dynamic-registration"]
