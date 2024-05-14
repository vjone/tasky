# Building the binary of the App
FROM golang:1.19 AS build
WORKDIR /go/src/tasky
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/src/tasky/tasky

# Runtime Environment/Image for the App
FROM alpine:3.17.0 as release
WORKDIR /app
COPY --from=build  /go/src/tasky/tasky .
COPY --from=build  /go/src/tasky/assets ./assets
RUN echo "Hello Team!" > /app/wizexercise.txt; chmod 400 /app/wizexercise.txt
EXPOSE 8080
ENV MONGODB_URI mongodb://wizuser:xyz123@10.0.7.206:27017
ENV SECRET_KEY secret123
ENTRYPOINT ["/app/tasky"]
