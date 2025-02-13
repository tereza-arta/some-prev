#Build stage
FROM node AS builder

#ARG REACT_APP_API_URL
#ENV REACT_APP_API_URL $REACT_APP_API_URL

WORKDIR /app-dir

#RUN sed -E -i'' "s/(.*API_URL=).*/\1$THEENV/" './source_code/.env'

COPY source_code/package*.json ./

RUN npm i react-scripts@latest

COPY source_code/ .

RUN npm run build
    #sed -E -i'' "s/(.*API_URL=).*/\1$THEENV/" './.env'

#Final stage
FROM nginx

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app-dir/build /usr/share/nginx/html

EXPOSE 3000
