FROM eclipse-temurin:17

WORKDIR /app

COPY . .

RUN chmod +x mvnw
RUN ./mvnw clean package -DskipTests

EXPOSE 10000

ENTRYPOINT ["java","-jar","target/dealvault-0.0.1-SNAPSHOT.jar"]