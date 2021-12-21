FROM golang:1.13-buster AS build
WORKDIR /app
COPY hello_world.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o hello_app .

FROM alpine:latest
EXPOSE 80
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=build /app/hello_app ./
CMD ["./hello_app"]