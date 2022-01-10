FROM golang:1.13-buster AS build
WORKDIR /app
# Build the golang code
COPY hello_world.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o hello_app .

FROM alpine:latest
# Inform docker that the container listens on the specified port
EXPOSE 80
# Add 'default' user
ENV USER=default
RUN apk add --update sudo
RUN adduser -D $USER \
    && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER
# Copy the binaries and run the application
WORKDIR /app/
COPY --from=build /app/hello_app ./
# Grant permissions to 'default' user
RUN chown -R ${USER}:${USER} /app
RUN chmod 755 /app
# Drop root user
USER ${USER}

CMD ["./hello_app"]
