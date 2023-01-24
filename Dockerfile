#########################################################laboratorio 2 Nivelics#########################################


# El objetivo es automatizar el despliegue y compilacion de una microservicio en springboot con maven
#sobre un contenedor en una distribucion de alpine y expuesto mediante prxy inverso por nginx

# Dockerfile By dario.lopez

# Descargar distribucion alpine
FROM alpine:latest

# Actualizar paquetes alpine / instalar Nginx / instlar jdk 1ava 11 /openrc /supervisord
RUN apk update && apk upgrade && apk add --no-cache supervisor openssh nginx && apk add openrc && apk add openjdk11 && apk add nano && openrc &&  touch /run/openrc/softlevel

### maven install
ENV MAVEN_VERSION 3.5.4
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

#copiar micro al contenedor

COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

#cfg reverse proxy nginx
COPY default.conf /etc/nginx/http.d/


# Exponer puerto 80
EXPOSE 80

#cfg supervisord levantar multiples instancias
COPY supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

########################### COMANDOS DE EJECUCION #################################

#Ejecutar dockerfile para crear imagen
#docker build -t  i_docker .
#levantar contenedor
#docker run -d --name c_micro -p 80:80 i_docker
#conectarse a la maquina
#docker exec -it c_micro /bin/sh