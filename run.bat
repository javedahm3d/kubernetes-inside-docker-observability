@echo off
if "%1"=="build" goto build
if "%1"=="run" goto run
if "%1"=="clean" goto clean
if "%1"=="all" goto all
goto all

:build
docker build --no-cache -t wiki-cluster .
goto end

:run
docker run --privileged --cgroupns=host -p 8080:8080 -it wiki-cluster
goto end

:all
docker build --no-cache -t wiki-cluster .
docker run --privileged --cgroupns=host -p 8080:8080 -it wiki-cluster
goto end

:clean
docker ps -q --filter "ancestor=wiki-cluster" > temp.txt
for /f %%i in (temp.txt) do docker stop %%i
docker ps -aq --filter "ancestor=wiki-cluster" > temp.txt
for /f %%i in (temp.txt) do docker rm %%i
del temp.txt
goto end

:end