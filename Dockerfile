FROM eclipse-temurin:17

COPY target/bank-app-1.0.4.jar app.jar

EXPOSE 8989

ENTRYPOINT ["java","-jar","/app.jar"]
