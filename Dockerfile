# Stage 1: Build plugin using Maven
FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /app

# Provide custom settings if needed (snapshots/inc incrementals). Uncomment if you have settings.xml
# COPY settings.xml /root/.m2/settings.xml

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create runtime image
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy the built HPI/JAR
COPY --from=builder /app/target/*.hpi /app/
COPY --from=builder /app/target/*.jar /app/

# Optional: Add entrypoint or CMD if needed
# ENTRYPOINT ["java", "-jar", "your-plugin.hpi"]
