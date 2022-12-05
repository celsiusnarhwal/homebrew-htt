FROM ubuntu:latest AS build

COPY *.tar.gz .

RUN mkdir bottle && tar -xvf *.tar.gz -C bottle

FROM scratch

COPY --from=build /bottle /