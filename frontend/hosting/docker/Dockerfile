# This is copied from: https://v2.vuejs.org/v2/cookbook/dockerize-vuejs-app.html
# I can take no credit for it. It's already on alpine (apk) so would be tricky to do better in the time frame

FROM node:lts-alpine

# install simple http server for serving static content
RUN npm install -g http-server

# make the 'app' folder the current working directory
WORKDIR /app

# copy both 'package.json' and 'package-lock.json' (if available)
COPY frontend/package*.json ./

# install project dependencies
RUN npm install

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY ./frontend .

# build app for production with minification
RUN npm run build

EXPOSE 3030
EXPOSE 8080
CMD [ "http-server", "dist" ]
