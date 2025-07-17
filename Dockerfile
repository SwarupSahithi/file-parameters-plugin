# === Stage 1: builder with Maven & Java 17 ===
FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /app

# Add your Maven settings if needed (uncomment & copy here)
# COPY settings.xml /root/.m2/settings.xml

# Copy pom and source
COPY pom.xml .
COPY src ./src

# Pre-warm dependencies (optional, can speed up builds)
RUN mvn dependency:go-offline -B

# Build plugin (skip tests to reduce build time)
RUN mvn clean package -DskipTests

# === Stage 2: artifact extraction ===
FROM busybox AS extractor
WORKDIR /out

# Copy plugin artifacts
COPY --from=builder /app/target/*.hpi .
COPY --from=builder /app/target/*.jar .

# === Stage 3 (optional): lightweight runtime image ===
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy only the HPI for runtime plugin deployment
COPY --from=extractor /out/*.hpi ./

# Default command
CMD ["sh", "-c", "echo \"Artifacts are in /app\" && ls -l /app"]
