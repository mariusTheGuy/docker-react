# We are going to create a multistep build proccess: 'build phase' and 'run phase'
# so we will be able to use more than one base image
# BUILD PHASE:
# 'builder' : we can pick a name for this phase
# 'node:16-alpine' is the 1st base image of this Dockerfile
FROM node:16-alpine as builder
WORKDIR '/app'
# COPY package.json .
COPY package.json .
RUN npm install
COPY . .
RUN npm run build
# /app/build contains now the build files, the only ones we care about 

# RUN PHASE:
# Hosting some simple static content
# https://hub.docker.com/_/nginx 
# this is too an example of a 2nd base image
FROM nginx
EXPOSE 80
# copy over the result of 'npm run build', everything else is left behind
COPY --from=builder /app/build /usr/share/nginx/html
# RUN : no need to provide a start command, 'nginx' starts up the container for us