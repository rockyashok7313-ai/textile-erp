FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY TextileERP.API/*.csproj TextileERP.API/
RUN dotnet restore TextileERP.API/TextileERP.API.csproj
COPY TextileERP.API/ TextileERP.API/
RUN dotnet publish TextileERP.API/TextileERP.API.csproj -c Release -o /app/output

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/output .
EXPOSE 80
ENTRYPOINT ["dotnet", "TextileERP.API.dll"]
