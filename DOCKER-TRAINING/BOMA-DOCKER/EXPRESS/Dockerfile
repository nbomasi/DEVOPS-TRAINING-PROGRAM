FROM node
RUN mkdir -p /home/app
WORKDIR /home/app
COPY package.json /home/package.json
# . . Means entire host directory and container directory
RUN npm install
#COPY . /home/app/
COPY ./app /home/app/
# npm install  will look for local directory to get "express", it will get the dependency file from package.json
CMD ["node", "/home/app/server.js"]
