FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["TestCouldDeployment.csproj", "./"]
RUN dotnet restore "TestCouldDeployment.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "TestCouldDeployment.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TestCouldDeployment.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestCouldDeployment.dll"]
