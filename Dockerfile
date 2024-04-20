FROM node:16-buster-slim AS builder

ARG VERSION

WORKDIR /build

RUN apt-get update && \
    apt-get install -y git python3 build-essential

RUN git clone https://github.com/janoside/btc-rpc-explorer . && \
    git checkout $VERSION

# Make sure we can pull git npm dependencies
RUN git config --global url."https://github.com/".insteadOf git@github.com: && \
    git config --global url."https://".insteadOf ssh://

RUN npm install

FROM node:16-buster-slim

RUN apt-get update && apt-get install -y git

USER 1000

WORKDIR /data

COPY --from=builder /build .

EXPOSE 3002

CMD [ "npm", "start" ]
