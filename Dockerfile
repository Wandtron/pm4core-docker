FROM pm4-base:local

ARG PM_VERSION

WORKDIR /tmp
RUN wget https://github.com/ProcessMaker/processmaker/archive/refs/tags/v${PM_VERSION}.zip -O processmaker.zip
RUN unzip processmaker.zip && rm -rf /code/pm4 && mv processmaker-* /code/pm4

WORKDIR /code/pm4
RUN composer install\
    --no-cache \
    #--no-dev \
    #--optimize-autoloader \
    && rm -rf /tmp/* /var/tmp/*
COPY build-files/laravel-echo-server.json .
RUN npm install --unsafe-perm=true && npm run prod

COPY build-files/laravel-echo-server.json .
COPY build-files/init.sh .
CMD bash init.sh && supervisord --nodaemon
