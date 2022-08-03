#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
RUN apt-get update && \

     apt-get install -yq --no-install-recommends \

     libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \

     libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \

     libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \

     libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \

     libnss3 libgdiplus libgbm1

WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

WORKDIR /src

COPY ["src/Application.Connect/Application.Connect.csproj", "src/Application.Connect/"]

COPY ["src/Application.Services.Integration.Messaging.Pdf/Application.Services.Integration.Messaging.Pdf.csproj", "src/Application.Services.Integration.Messaging.Pdf/"]

COPY ["src/Application.Shared/Application.Shared.csproj", "src/Application.Shared/"]

COPY ["src/Application.Connect.Integration.HostedService/Application.Connect.Integration.HostedService.csproj", "src/Application.Connect.Integration.HostedService/"]

COPY ["src/Application.Services.Data.EntityFramework/Application.Services.Data.EntityFramework.csproj", "src/Application.Services.Data.EntityFramework/"]

COPY ["src/Application.Services.Common/Application.Services.Common.csproj", "src/Application.Services.Common/"]

COPY ["src/Application.IdentityServer.Shared/Application.IdentityServer.Shared.csproj", "src/Application.IdentityServer.Shared/"]

COPY ["src/Application.Services.Data.Common/Application.Services.Data.Common.csproj", "src/Application.Services.Data.Common/"]

COPY ["src/Application.Connect.Integration.Delivery.Pipeline/Application.Connect.Integration.Delivery.Pipeline.csproj", "src/Application.Connect.Integration.Delivery.Pipeline/"]

COPY ["src/Application.Services.CareUpdateService/Application.Services.CareUpdateService.csproj", "src/Application.Services.CareUpdateService/"]

COPY ["src/Application.Connect.Integration.Common/Application.Connect.Integration.Common.csproj", "src/Application.Connect.Integration.Common/"]

COPY ["src/Application.Connect.Integration.Messaging.Hl7v2/Application.Connect.Integration.Messaging.Hl7v2.csproj", "src/Application.Connect.Integration.Messaging.Hl7v2/"]

COPY ["src/Application.Connect.Integration.Delivery.Pipeline.Common/Application.Connect.Integration.Delivery.Pipeline.Common.csproj", "src/Application.Connect.Integration.Delivery.Pipeline.Common/"]

COPY ["src/Application.Connect.Integration.Delivery.Pipeline.Samples/Application.Connect.Integration.Delivery.Pipeline.Samples.csproj", "src/Application.Connect.Integration.Delivery.Pipeline.Samples/"]



RUN dotnet restore "src/Application.Connect/Application.Connect.csproj"



WORKDIR "/src/Application.Connect"

COPY . .



RUN dotnet build "src/Application.Connect/Application.Connect.csproj" -c Release -o /app/build



FROM build AS publish

RUN dotnet publish "src/Application.Connect/Application.Connect.csproj" -c Release -o /app/publish



FROM base AS final

WORKDIR /app

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "Application.Connect.dll"]

