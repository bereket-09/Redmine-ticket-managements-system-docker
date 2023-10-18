FROM ruby:2.6.10
LABEL maintainer="Bereket beki@test.com"

# Install dependencies
RUN apt-get update && apt-get install -y build-essential libmagickcore-dev libmagickwand-dev libmariadb-dev-compat libpq-dev nginx nodejs unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Foreman
RUN gem install foreman

# Create Redmine directory
RUN mkdir -p /usr/src/redmine

# Copy Redmine and extract
COPY redmine-5.0.6.zip /usr/src/redmine/
WORKDIR /usr/src/redmine
RUN unzip redmine-5.0.6.zip && rm redmine-5.0.6.zip

# Copy modified database.yml
COPY database.yml config/

# Copy init.sql file
COPY Tables/init.sql /docker-entrypoint-initdb.d/

# Install gems
RUN gem install bundler:2.2.25
RUN bundle install --without development test --path vendor/bundle --jobs $(nproc)

# Set up nginx configuration
RUN rm /etc/nginx/sites-enabled/default && ln -s /usr/src/redmine/config/nginx.conf /etc/nginx/sites-enabled/redmine

# Expose port
EXPOSE 80

# Startup script
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Start MySQL service
RUN apt-get update && apt-get install -y mysql-server

RUN service mysql start && mysql -uroot -e "CREATE USER 'redmine'@'%' IDENTIFIED WITH mysql_native_password BY 'password';" && \
    mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'redmine'@'%';" && \
    mysql -uroot -e "CREATE DATABASE redmine CHARACTER SET utf8 COLLATE utf8_general_ci;"
  
CMD ["foreman", "start"]