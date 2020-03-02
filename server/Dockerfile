FROM golang:latest


ARG app_env
ENV APP_ENV $app_env


# Copy the code from the host and compile it
WORKDIR /server

COPY . /server

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