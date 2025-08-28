FROM debian:stable-slim AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    bash \
    tar \
    bzip2 \
    autoconf \
    libtool \
    emscripten \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY src/ .

RUN tar -xjf libs/expat-2.7.1.tar.bz2 -C libs && \
    tar -xjf libs/rnv-1.7.11.tar.bz2 -C libs

RUN bash scripts/build_expat.sh

RUN bash scripts/build_rnv.sh

FROM scratch AS export
COPY --from=builder /src/dist/ /dist/

# Dummy entrypoint - this won't be run
ENTRYPOINT [ "/bin/sh" ]
