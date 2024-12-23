# docker-images
Custom docker images builder

## build image
docker build -t image_name:v`date "+%Y-%m-%d"`

## export image
docker save --output image_name-v`date "+%Y.%m.%d"`.tar image_name:v`date "+%Y-%m-%d"`