FROM registry.cn-hangzhou.aliyuncs.com/yoyosoft/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM registry.cn-hangzhou.aliyuncs.com/yoyosoft/dotnet/core/sdk AS build
WORKDIR /src

COPY ["demo/Hanfire.Api/Hanfire.Api.csproj", "demo/Hanfire.Api/"]
#COPY ["Hangfire.HttpJob.csproj", "Hangfire.HttpJob/"]
#COPY ["Hangfire.Tags.Mysql.csproj", "Hangfire.Tags.Mysql/"]
RUN dotnet restore "demo/Hanfire.Api/Hanfire.Api.csproj"

COPY . .
WORKDIR "/src/demo/Hanfire.Api"
RUN dotnet build "Hanfire.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Hanfire.Api.csproj" -c Release -o /app/publish


FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "Hanfire.Api.dll"]





