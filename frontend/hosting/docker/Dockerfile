# This is copied from: https://v2.vuejs.org/v2/cookbook/dockerize-vuejs-app.html
# I can take no credit for it. It's already on alpine (apk) so would be tricky to do better in the time frame

# Important Note:
# It would be tidier to use a builder container + then move the content across to the runtime container, this
# is definitely recommend as would prevent the image being so bulky but also prevent distributing the raw
# source code alongside the production application. I will come back to this if I have time.

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

# expose the port for the frontend service
EXPOSE 8080

# serve the frontend service
CMD [ "http-server", "dist" ]
