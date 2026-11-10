FROM maven:3.9.9-eclipse-temurin-21

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends entr \
    && rm -rf /var/lib/apt/lists/*

COPY pom.xml ./
COPY src ./src
COPY dev-entrypoint.sh /usr/local/bin/dev-entrypoint

RUN sed -i 's/\r$//' /usr/local/bin/dev-entrypoint \
    && chmod +x /usr/local/bin/dev-entrypoint

EXPOSE 8080

ENTRYPOINT ["dev-entrypoint"]
