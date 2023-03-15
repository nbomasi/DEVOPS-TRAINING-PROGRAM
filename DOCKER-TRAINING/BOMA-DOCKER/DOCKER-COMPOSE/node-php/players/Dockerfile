FROM node
RUN mkdir -p /home/app
WORKDIR /home/app
#RUN npm install -g nodemon
#RUN nodemon index.js
# The line above installs nodemon which is a node that allow AUTOMATIC update of JS file when it is edited
COPY package.json /home/package.json
# . . Means entire host directory and container directory
RUN npm install
#RUN mv /app/node_modules /node_modules
COPY . /home/app/


#COPY ./app /home/app/
# npm install  will look for local directory to get "express", it will get the dependency file from package.json
CMD ["node", "/home/app/server.js"]
