FROM registry.redhat.io/ubi8/openjdk-11:1.14-12
WORKDIR /opt/app
ARG JAR_FILE=target/Muis-Fuse-MasterDataImport_Request_V1-transformation-1.0.0.jar
COPY ${JAR_FILE} app.jar

COPY certs/certs_prod/keystore_prod_iam.jks /certs/keystore_iam.jks
#COPY certs/certs_rec/keystore_rec_iam.jks /certs/keystore_iam.jks

COPY certs/certs_prod/openshift_iam_prod.cer /tmp/openshift_iam.cer
#COPY certs/certs_rec/openshift_iam_rec.cer /tmp/openshift_iam.cer

#COPY soatest.cer /tmp

USER root

RUN keytool -import -noprompt -deststorepass changeit -alias openshift -file /tmp/openshift_iam.cer -keystore /etc/java/java-11-openjdk/java-11-openjdk-11.0.18.0.10-2.el8_7.x86_64/lib/security/cacerts

#RUN keytool -import -noprompt -deststorepass changeit -alias soatest -file /tmp/soatest.cer -keystore /etc/java/java-11-openjdk/java-11-openjdk-11.0.18.0.10-2.el8_7.x86_64/lib/security/cacerts
#RUN keytool -import -noprompt -deststorepass changeit -alias openshift -file /tmp/openshift.cer -keystore /etc/pki/ca-trust/extracted/java/cacerts
#RUN keytool -import -noprompt -deststorepass changeit -alias openshift -file /tmp/openshift.cer -keystore /etc/pki/java/cacerts
ENTRYPOINT ["java","-jar","app.jar"]

# mvn spring-boot:run
# mvn clean install
# Start Docker deamon
# docker build -t quay.io/msentissi/3scale-trf-master:iam_1.12-prod .
# Tag it and push to quay
# docker tag 3scale-trf-master:iam_1.12-prod quay.io/msentissi/3scale-trf-master:iam_1.12-prod
# docker login quay.io
# docker push quay.io/msentissi/3scale-trf-master:iam_1.12-prod