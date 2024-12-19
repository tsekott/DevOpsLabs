FROM alpine
WORKDIR /home/httpserver
COPY ./main .
RUN apk add libstdc++
RUN apk add libc6-compat
ENTRYPOINT ["./main"]