FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env

# Copy sources
COPY src/Services/Transaction/. /app/src/Services/Transaction
COPY src/Frameworks/Transaction/. /app/src/Frameworks/Transaction

WORKDIR /app/src/Services/Transaction

RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
ENV SQL_SERVER_HOST="localhost"
ENV SQL_SERVER_DATABASE="SimpleTransaction"
ENV SQL_SERVER_USER="sa"
ENV SQL_SERVER_PASS="SuperSecretPass"
COPY deploy/Transaction.entrypoint.sh /entrypoint.sh
WORKDIR /app
COPY --from=build-env /app/src/Services/Transaction/out .

RUN chmod +x /entrypoint.sh && \
    apt-get update && \
    apt-get -y install nano && \
    apt-get -y install net-tools && \
    apt-get -y install dnsutils && \
    apt-get -y install telnet && \
    apt-get -y install iputils-ping

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["dotnet", "Transaction.WebApi.dll"]
