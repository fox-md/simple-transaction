FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env

WORKDIR /app

# Copy csproj and restore as distinct layers
#COPY ../src/*.csproj ./
#RUN dotnet restore

# Copy everything else and build
COPY ../src/Services/Identity/. ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2

WORKDIR /app
#COPY publish/ .
COPY --from=build-env /app/out .

RUN apt-get update && \
    apt-get -y install nano && \
    apt-get -y install net-tools && \
    apt-get -y install dnsutils && \
    apt-get -y install telnet && \
    apt-get -y install iputils-ping

EXPOSE 80
CMD ["dotnet", "Identity.WebApi.dll"]
