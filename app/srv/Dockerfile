FROM node

WORKDIR /app-dir

COPY source_code/package*.json ./

RUN npm install

COPY source_code/ .

EXPOSE 5000

CMD ["npm", "run", "start"]
