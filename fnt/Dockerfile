#Build stage
FROM node AS builder

WORKDIR /app

COPY source_code/package*.json ./

RUN npm i react-scripts@latest

COPY source_code/ .

RUN npm run build

#Final stage
FROM nginx

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 3000
