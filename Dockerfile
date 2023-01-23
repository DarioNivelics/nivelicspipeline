
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

# Actualizar paquetes alpine / instalar Nginx / instlar jdk 1ava 11
RUN apk update && apk upgrade && apk add nginx && apk add openjdk11

# Copíar compilado
#ARG JAR_FILE=target/*.jar
#COPY ${JAR_FILE} app.jar
COPY --from=maven /home/app/target/docker-0.0.1-SNAPSHOT.jar /usr/local/lib/app.jar

# Exponer puerto 80
EXPOSE 80

# Comando Ejecutar jarfile
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/usr/local/lib/app.jar"]

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

########################### COMANDOS DE EJECUCION #################################

#Ejecutar dockerfile para crear imagen
#docker build -t  docker .
#levantar contenedor
#docker run -d --name contenedormicro -p 80:80 docker
