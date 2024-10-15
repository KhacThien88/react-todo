# pull official base image
FROM node:22.9.0-alpine

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

#RUN npm i -g npm
RUN npm cache clean --force
# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install

COPY . .

#Expose the React.js application container on port 3000
EXPOSE 3000

# The command to start the React.js application container
CMD ["npm", "start"]
