#!/bin/bash
npm run prepublish
docker build -t Sysunite/`node -p "require('./package.json').name"`:`node -p "require('./package.json').version"` .
