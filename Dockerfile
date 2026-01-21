# Stage 1: Build dell'applicazione
FROM maven:3.9-amazoncorretto-21 AS build
WORKDIR /app

# Copia il pom.xml e scarica le dipendenze (per sfruttare la cache Docker)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copia il codice sorgente e compila l'applicazione
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Immagine runtime
FROM amazoncorretto:21-alpine
WORKDIR /app

# Copia il JAR dall'immagine di build
COPY --from=build /app/target/soccorsoweb-*.jar /app/soccorso-web.jar

# Espone la porta 8080
EXPOSE 8080

# Comando di avvio
ENTRYPOINT ["java", "-jar", "/app/soccorso-web.jar"]
