cp ./Dockerfile ../homegear/
cp -R ./rootfs ../homegear/
docker run --rm --privileged homeassistant/amd64-builder  --amd64
rm -rf ../homegear/rootfs
rm ../homegear/Dockerfile