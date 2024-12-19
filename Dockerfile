# Build stage
FROM alpine AS build
WORKDIR /home/httpserver

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    automake \
    autoconf

# Copy source files
COPY . .

# Build the application
RUN autoreconf --install && \
    ./configure && \
    make

# Runtime stage
FROM alpine
WORKDIR /home/httpserver

# Install runtime dependencies
RUN apk add --no-cache \
    libstdc++ \
    libc6-compat

# Copy binary from build stage
COPY --from=build /home/httpserver/main /home/httpserver/

ENTRYPOINT ["./main"]