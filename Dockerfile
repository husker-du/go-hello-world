FROM golang:1.13-buster AS build

WORKDIR /app

# build the golang code
COPY hello_world.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o hello_app .


FROM alpine:latest

# informs docker that the container listens on the specified network ports at runtime
EXPOSE 80

# install sudo as root
RUN apk add --update sudo

# add new user
ENV USER=default
RUN adduser -D $USER \
    && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER

# copy and run the app
WORKDIR /app/
COPY --from=build /app/hello_app ./

# grant permissions
RUN chown -R ${USER}:${USER} /app
RUN chmod 755 /app

# drop root user
USER ${USER}

CMD ["./hello_app"]
