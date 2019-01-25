#!/bin/bash
npm run prepublish
docker rm kong-controller-cont
docker build -t kong-controller .
docker run --name kong-controller-cont -it -p 7090:7090 kong-controller
