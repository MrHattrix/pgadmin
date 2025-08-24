# Use plain Debian + install pgadmin4 in web mode
FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget curl gnupg python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install pgAdmin4
RUN curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | apt-key add - \
    && echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/debian bullseye pgadmin4" > /etc/apt/sources.list.d/pgadmin4.list \
    && apt-get update \
    && apt-get install -y pgadmin4-web \
    && rm -rf /var/lib/apt/lists/*

# Configure web mode
RUN /usr/pgadmin4/bin/setup-web.sh --yes

ENV PGADMIN_DEFAULT_EMAIL=admin@admin.com
ENV PGADMIN_DEFAULT_PASSWORD=admin

EXPOSE 80

CMD ["gunicorn", "--chdir", "/usr/pgadmin4/web", "pgAdmin4:app", "-b", "0.0.0.0:80", "-w", "4"]
