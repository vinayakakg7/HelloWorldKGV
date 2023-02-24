FROM maven as build
WORKDIR /app
copy . .
RUN mvn install


FROM openjdk:11.0
WORKDIR /app
COPY --from=build /app/target/HelloWorld.jar /app/
EXPOSE 9090
CMD ["java" , "-jar" , "HelloWorld.jar" ]