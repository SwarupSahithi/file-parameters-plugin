# Stage 1: Build
FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /app

# Copy settings.xml if needed (e.g. for Jenkins repo access)
COPY settings.xml /root/.m2/settings.xml

# Copy only the POM to pre-fetch deps excluding missing ones
COPY pom.xml ./
RUN mvn dependency:go-offline -B || echo "Ignoring offline error"

# Copy source and build package
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Extract artifacts
FROM busybox AS extractor
WORKDIR /out
COPY --from=builder /app/target/*.hpi . || true
COPY --from=builder /app/target/*.jar . || true

# Stage 3: Runtime (optional, adapt as needed)
FROM openjdk:17-jdk-slim
WORKDIR /app
# Copy built plugin(s)
COPY --from=extractor /out/ .

CMD ["/bin/bash"]

