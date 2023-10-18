FROM mysql:5.7

ENV MYSQL_ROOT_PASSWORD Passw0rd123!
ENV MYSQL_DATABASE redmine
ENV MYSQL_USER redmine
ENV MYSQL_PASSWORD Passw0rd123!
# Add the init.sql script to the container
ADD init.sql /docker-entrypoint-initdb.d/

EXPOSE 3336
CMD ["mysqld"]