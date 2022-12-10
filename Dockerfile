FROM python:3.11 AS build

ARG BOTTLE
ARG TITLE

COPY ${BOTTLE} /

RUN tar xvf ${BOTTLE} --one-top-level=${TITLE} --strip-components=1

FROM scratch

ARG TITLE
ARG SOURCE

COPY --from=build /${TITLE} /

LABEL com.github.package.type="homebrew_bottle"
LABEL org.opencontainers.image.source=${SOURCE}
LABEL org.opencontainers.image.title="celsiusnarhwal/htt/${TITLE}"