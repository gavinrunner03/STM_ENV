IMAGE_NAME=stm32-dev
docker run -it --rm --privileged \
  -v /dev/bus/usb:/dev/bus/usb \
  -v "$(pwd)":/workspace \
  $IMAGE_NAME bash
