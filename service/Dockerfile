FROM realturner/signal-backup-build:latest AS build

WORKDIR /build

COPY . .

RUN make all -j4

# TODO: optmize docker image size
FROM realturner/signal-backup-build:latest

WORKDIR /kbup

COPY --from=build /build/build/target/release .

ENTRYPOINT ["/kbup/kbupd"]

CMD ["help"]
