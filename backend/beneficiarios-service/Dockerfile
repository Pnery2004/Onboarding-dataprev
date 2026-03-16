FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /build

COPY . .
RUN mvn -pl beneficiarios-service -am clean package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app

COPY --from=build /build/beneficiarios-service/target/beneficiarios-service-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]

