Tensorflow GPU on Ubuntu 16.04
====

## Overview

- Method: virtualenv
- ubuntu 16.04 
- python version 3.5 (default on ubuntu 16.04) 

## Tensorflow
- Virtualenv : tensorflow CPU
```
sudo apt-get install -y python-pip python3-dev python-virtualenv
virtualenv --python=/usr/bin/python3 tensorflow
source ~/tensorflow/bin/activate
(tensorflow) pip3 install --upgrade tensorflow
(tensorflow) deactivate
```

- Virtualenv : tensorflow GPU
```
sudo apt-get install -y python-pip python3-dev python-virtualenv
virtualenv --python=/usr/bin/python3 tensorflow-gpu
source ~/tensorflow-gpu/bin/activate
(tensorflow-gpu) pip3 install --upgrade tensorflow-gpu
(tensorflow-gpu) deactivate
```
## Reference
- https://www.tensorflow.org/install/install_linux#InstallingVirtualenv
