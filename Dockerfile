FROM php:8.0-cli
MAINTAINER Maximiliano Contartesi @ TECNOGO

RUN apt-get update \
    && apt-get install -y libfontconfig1 autoconf libxrender1 libxext6 libpng-dev libfreetype6-dev libjpeg62-turbo-dev libzip-dev zlib1g-dev libonig-dev libxml2-dev curl apt-transport-https gpg unixodbc unixodbc-dev wget git cron unzip libcurl4-openssl-dev pkg-config libssl-dev supervisor \
    && rm -rf /var/lib/apt/lists/* && \
    cp /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime && \
    echo "Argentina/Buenos_Aires" > /etc/timezone && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /usr/share/keyrings/cloud.google.gpg && apt-get update -y && apt-get install google-cloud-sdk -y && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd zip mysqli soap intl bcmath pdo pdo_mysql opcache

RUN pecl install mongodb && \
    pecl install sqlsrv && \
    pecl install pdo_sqlsrv && \
    pecl install grpc && \
    pecl install protobuf && \
    docker-php-ext-enable mongodb && \
    docker-php-ext-enable sqlsrv && \
    docker-php-ext-enable pdo_sqlsrv && \
    docker-php-ext-enable grpc && \
    docker-php-ext-enable protobuf

RUN apt-get clean

