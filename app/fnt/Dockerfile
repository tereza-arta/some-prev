#Build stage
FROM node AS builder

WORKDIR /app-dir

COPY app/fnt/source_code/package*.json ./

RUN npm i react-scripts@latest

COPY app/fnt/source_code/ .

RUN npm run build

#Final stage
FROM nginx

COPY app/fnt/nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app-dir/build /usr/share/nginx/html

EXPOSE 3000
