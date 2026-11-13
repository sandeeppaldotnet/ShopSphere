# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

WORKDIR /src

# Copy API project
COPY ShopSphere.Api/ShopSphere.Api.csproj ShopSphere.Api/

# Restore dependencies
RUN dotnet restore ShopSphere.Api/ShopSphere.Api.csproj

# Copy remaining source files
COPY ShopSphere.Api/ ShopSphere.Api/

# Publish application
RUN dotnet publish ShopSphere.Api/ShopSphere.Api.csproj \
    -c Release \
    -o /app/publish \
    --no-restore

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final

WORKDIR /app

COPY --from=build /app/publish .

# Render's default HTTP port
ENV ASPNETCORE_HTTP_PORTS=10000

EXPOSE 10000

ENTRYPOINT ["dotnet", "ShopSphere.Api.dll"]