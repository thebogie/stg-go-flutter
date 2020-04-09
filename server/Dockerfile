

FROM golang:latest
# Copy the code from the host and compile it
WORKDIR /server

COPY . /server
COPY ./config/config-docker.yaml /server/config.yaml


# added vendor services will need to be included here
RUN go mod download

# if dev setting will use pilu/fresh for code reloading via docker-compose volume sharing with local machine
# if production setting will build binary
CMD if [ ${APP_ENV} = production ]; \
	then \
	api; \
	else \
	go get github.com/pilu/fresh && \
	fresh; \
	#dlv debug /go/src/stg/api -l 0.0.0.0:2345 --headless=true --api-version=2 --accept-multiclient --log=true -- server; \
	fi
#ENTRYPOINT [ "dlv", "debug", "/go/src/stg/api", "-l", "0.0.0.0:2345" , "--headless=true" ,"--log=true", "--", "server"]
EXPOSE 5000
#dlv debug /go/src/stg/api -l 0.0.0.0:2345 --headless=true --log=true -- server


#FROM golang:latest
#WORKDIR /go/src/github.com/thebogie/stg-go-flutter/server
#COPY . /go/src/github.com/thebogie/stg-go-flutter/server
#RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o ./dist/example

#FROM alpine:latest
#RUN apk add --update ca-certificates
#RUN apk add --no-cache tzdata && \
#  cp -f /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime && \
#  apk del tzdata


#WORKDIR /app
#COPY ./config/config.yaml /var/app/
#COPY ./config/config.yaml /
#COPY --from=builder go/src/github.com/thebogie/stg-go-flutter/dist/example .

#ENV PORT=9090
#EXPOSE $PORT
#ENTRYPOINT ["./example"]


#FROM golang:latest


#ARG app_env
#ENV APP_ENV $app_env