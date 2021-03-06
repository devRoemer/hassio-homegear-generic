Copy-Item Dockerfile -Destination ..\homegear\
Copy-Item -Recurse -Path rootfs -Destination ..\homegear\
docker run --rm --privileged homeassistant/amd64-builder --amd64
Remove-Item -Recurse -Force ..\homegear\rootfs
Remove-Item ..\homegear\Dockerfile