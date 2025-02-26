FROM gradle:8.5-jdk21 AS builder
WORKDIR /app

COPY gradle gradle
COPY build.gradle settings.gradle gradlew ./

RUN ./gradlew dependencies --no-daemon

COPY . .

RUN ./gradlew clean build -x test --no-daemon

FROM eclipse-temurin:21-jre AS runtime

WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
