FROM okteto/golang:1 as dev
RUN curl -SL https://github.com/accurics/terrascan/releases/download/v1.6.0/terrascan_1.6.0_Linux_x86_64.tar.gz  | tar -xz -C /usr/local/bin

WORKDIR /usr/src/app
COPY go.mod go.sum ./
RUN go mod download
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -o /usr/local/bin/guestbook

FROM debian:buster
COPY ./public/index.html public/index.html
COPY ./public/script.js public/script.js
COPY ./public/style.css public/style.css
COPY --from=dev /usr/local/bin/guestbook /usr/local/bin/guestbook
CMD ["/usr/local/bin/guestbook"]
EXPOSE 8080