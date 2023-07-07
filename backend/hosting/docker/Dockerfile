# This is copied from: https://v2.vuejs.org/v2/cookbook/dockerize-vuejs-app.html
# I can take no credit for it. It's already on alpine (apk) so would be tricky to do better in the time frame

FROM node:lts-alpine

# install simple http server for serving static content
RUN npm install -g http-server

# make the 'app' folder the current working directory
WORKDIR /app

# copy both 'package.json' and 'package-lock.json' (if available)
COPY backend/package*.json ./

# install project dependencies
RUN npm install

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY ./backend .

# build app for production with minification
RUN npm run build

EXPOSE 8080
EXPOSE 3030
CMD [ "http-server", "-p", "3030", "dist" ]
