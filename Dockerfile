FROM registry.redhat.io/ubi8/openjdk-11:1.14-12
WORKDIR /opt/app
ARG JAR_FILE=target/Muis-Fuse-MasterDataImport_Request_V1-transformation-1.0.0.jar
COPY ${JAR_FILE} app.jar

#COPY certs/certs_prod/keystore_prod_iam.jks /certs/keystore_iam.jks
#COPY certs/certs_rec/keystore_rec_iam.jks /certs/keystore_iam.jks

#COPY certs/certs_prod/openshift_iam_prod.cer /tmp/openshift_iam.cer
#COPY certs/certs_rec/openshift_iam_rec.cer /tmp/openshift_iam.cer

#COPY soatest.cer /tmp

USER root
RUN mkdir -p /opt/app/sap-libs /certs /certs2
###RUN keytool -import -noprompt -deststorepass changeit -alias openshift -file /tmp/openshift_iam.cer -keystore /etc/java/java-11-openjdk/java-11-openjdk-11.0.18.0.10-2.el8_7.x86_64/lib/security/cacerts

#RUN keytool -import -noprompt -deststorepass changeit -alias soatest -file /tmp/soatest.cer -keystore /etc/java/java-11-openjdk/java-11-openjdk-11.0.18.0.10-2.el8_7.x86_64/lib/security/cacerts
#RUN keytool -import -noprompt -deststorepass changeit -alias openshift -file /tmp/openshift.cer -keystore /etc/pki/ca-trust/extracted/java/cacerts
#RUN keytool -import -noprompt -deststorepass changeit -alias openshift -file /tmp/openshift.cer -keystore /etc/pki/java/cacerts
# Copy the entrypoint script into the image
COPY /entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 777 /etc/java/java-11-openjdk/java-11-openjdk-11.0.18.0.10-2.el8_7.x86_64/lib/security/cacerts
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["sh", "/usr/local/bin/entrypoint.sh"]

# mvn spring-boot:run
# mvn clean install
# Start Docker deamon
# docker build -t quay.io/msentissi/3scale-trf-master:iam_1.14 .
# Tag it and push to quay
# docker tag 3scale-trf-master:iam_1.14 quay.io/msentissi/3scale-trf-master:iam_1.14
# docker login quay.io
# docker push quay.io/msentissi/3scale-trf-master:iam_1.14