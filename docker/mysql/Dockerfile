FROM mysql:5.7

LABEL maintainer="Ivan Boldyrev <iboldurev@gmail.com>"

RUN chown -R mysql:root /var/lib/mysql/

COPY etc/mysql/conf.d/my.cnf /etc/mysql/conf.d/my.cnf

CMD ["mysqld"]
