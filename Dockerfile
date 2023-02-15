FROM registry.redhat.io/ubi8/openjdk-11:1.14-12
WORKDIR /opt/app
ARG JAR_FILE=target/Muis-Fuse-MasterDataImport_Request_V1-transformation-1.0.0.jar
COPY ${JAR_FILE} app.jar
EXPOSE 8087/tcp
ENTRYPOINT ["java","-jar","app.jar"]

# Start Docker deamon
# docker login quay.io
# docker build -t quay.io/msentissi/muis-fuse-masterdataimport_request_v1-transformation:1.0.0 .
# docker push quay.io/msentissi/muis-fuse-masterdataimport_request_v1-transformation:1.0.0