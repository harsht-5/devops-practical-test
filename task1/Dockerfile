FROM node:20.0.0-alpine3.17
WORKDIR /app
COPY package.json package-lock.json app.js ./
RUN npm install
EXPOSE 3000
CMD ["node", "app.js"]