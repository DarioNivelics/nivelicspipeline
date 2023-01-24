
# Dockerfile By dario.lopez

####################  STEP 1  #####################################

# compila un microservicio de java con maven

FROM maven:latest as maven

COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

########################### STEP2 #################################

# Descargar distribucion alpine
FROM alpine:latest

# Actualizar paquetes alpine / instalar Nginx / instlar jdk 1ava 11 /openrc
RUN apk update && apk upgrade && apk add --no-cache supervisor openssh nginx && apk add openrc && apk add openjdk11 && apk add nano && openrc &&  touch /run/openrc/softlevel

# Copíar compilado
#ARG JAR_FILE=target/*.jar
#COPY ${JAR_FILE} app.jar
COPY --from=maven /home/app/target/docker-0.0.1-SNAPSHOT.jar /usr/local/lib/app.jar
COPY default.conf /etc/nginx/http.d/
# Exponer puerto 80
EXPOSE 80
EXPOSE 9000

# Comando Ejecutar jarfile
#CMD ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/usr/local/lib/app.jar"]

#CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

COPY supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

########################### COMANDOS DE EJECUCION #################################

#Ejecutar dockerfile para crear imagen
#docker build -t  i_docker .
#levantar contenedor
#docker run -d --name c_micro -p 80:80 i_docker
#conectarse a la maquina
#docker exec -it c_micro /bin/sh