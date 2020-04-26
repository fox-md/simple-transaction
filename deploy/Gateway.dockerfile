FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env

WORKDIR /app

# Copy everything else and build
COPY ../src/Gateway/Gateway.WebApi/. ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
ENV ID_ENDPOINT_HOST="localhost"
ENV ID_ENDPOINT_PORT=54203
ENV TX_ENDPOINT_HOST="localhost"
ENV TX_ENDPOINT_PORT=60243
COPY Gateway.entrypoint.sh /entrypoint.sh
WORKDIR /app
#COPY publish/ .
COPY --from=build-env /app/out .

RUN chmod +x /entrypoint.sh && \
    apt-get update && \
    apt-get -y install nano && \
    apt-get -y install net-tools && \
    apt-get -y install dnsutils && \
    apt-get -y install telnet && \
    apt-get -y install iputils-ping

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["dotnet", "Gateway.WebApi.dll"]
