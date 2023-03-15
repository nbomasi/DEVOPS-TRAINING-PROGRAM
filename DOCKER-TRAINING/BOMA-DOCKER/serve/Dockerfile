FROM node:latest
RUN npm install -g serve
COPY ./display ./display  
# the second display is the directory on the container to be created
# copy from the first to the second display
CMD serve ./display