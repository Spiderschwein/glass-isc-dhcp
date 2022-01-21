FROM node:16-slim
WORKDIR /home/node/app

EXPOSE 8081
EXPOSE 8082

ENV NODE_ENV=production
ENV ADMIN_USER="glassadmin"
ENV ADMIN_PASSWORD="glassadmin"
ENV WS_PORT=8082

# Install wget, procps (for top cmd) and isc-dhcp-server (for config checking)
RUN apt-get update && apt-get install wget procps isc-dhcp-server -y && rm -rf /var/cache/apt

# Install confd for configuration management (https://github.com/kelseyhightower/confd)
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 &&\
 mv confd-0.16.0-linux-amd64 /usr/local/bin/confd &&\
 chmod +x /usr/local/bin/confd

# cache node_modules
COPY package.json .
COPY package-lock.json .

RUN npm install

# copy the remainder of src
COPY . .

# Create Entrypoint for config generation
ENTRYPOINT [ "sh", "entrypoint.sh" ]
CMD npm start
