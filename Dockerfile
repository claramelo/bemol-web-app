FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src/TodoApi/

COPY ./TodoApi/ .
RUN dotnet restore
RUN dotnet publish -c release -o /app --self-contained false --no-restore

FROM  mcr.microsoft.com/dotnet/core/aspnet:3.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["./TodoApi"]