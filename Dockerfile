FROM openjdk:11-jdk AS builder
COPY . /source
WORKDIR /source
RUN ./gradlew clean build

FROM tomcat:jdk11-openjdk
USER root
ARG app_version=DEV
ENV APP_VERSION=$app_version
COPY --from=builder /source/build/libs/gradle-demo-with-docker-1.0.0.war /usr/local/tomcat/webapps/gradle-demo-with-docker.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
