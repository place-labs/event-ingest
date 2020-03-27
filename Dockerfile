FROM crystallang/crystal:0.33.0-alpine
ADD . /src
WORKDIR /src

# Add trusted CAs for communicating with external services
RUN apk --no-cache add ca-certificates

# Build App
RUN shards build --error-trace --production

# Extract dependencies
RUN ldd bin/app | tr -s '[:blank:]' '\n' | grep '^/' | \
    xargs -I % sh -c 'mkdir -p $(dirname deps%); cp % deps%;'

# Build a minimal docker image
FROM scratch
WORKDIR /
ENV PATH=$PATH:/
COPY --from=0 /src/deps /
COPY --from=0 /src/bin/app /app

# This is required for Timezone support
COPY --from=0 /usr/share/zoneinfo/ /usr/share/zoneinfo/
# COPY --from=0 /usr/share/lib/zoneinfo/ /usr/share/lib/zoneinfo/
# COPY --from=0 /usr/lib/locale/TZ/ /usr/lib/locale/TZ/

# Run the app binding on port 8080
EXPOSE 8080
ENTRYPOINT ["/app"]
HEALTHCHECK CMD ["/app", "-c", "http://127.0.0.1:8080/"]
CMD ["/app", "-b", "0.0.0.0", "-p", "8080"]
