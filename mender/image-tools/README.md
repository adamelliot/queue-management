# Building Images to Prepare for Mender Deployment

## Prerequisites

- **Ubuntu 18.04**
- 10 gigabytes of storage

## Step 1: Building Base Image (Bootstrapping)

The first image that needs to be built is the base raspbian image that will be "menderized". This image is a modified version of the released image from Raspbian. It has much of the unneeded packages removed, and the base level of packages for all the features in our app.

First download the raspbian image from: [Raspberry Pi Images](https://www.raspberrypi.org/downloads/raspbian/). Download the [Raspbian Lite Image](https://downloads.raspberrypi.org/raspbian_lite_latest).

To shrink and prime the image run:
```
raspbian-shrinker/generate-image.sh 2018-11-13-raspbian-stretch-lite.img
```

## Step 2: Menderizing the image

The next step of the process involves turning the standard Raspbian image into **Menderized** image which can do OTA updates. To do this we will use the `mender-convert` utility.

```
git clone https://github.com/mendersoftware/mender-convert.git
cd mender-convert
git checkout 2743366

./docker-build
```

To generate the **Menderized** image you will need to provide some information to the conversion tool:

1. Base Image (Built in **Step #1**)
2. URL Which will be Hosting Mender [https://mender.pathfinder.gov.bc.ca]
3. The service certificate the devices need to register with (use `server.crt` in this folder and store it in the `input` folder, which will be mounted in the docker image)
4. The total store needs to be more than double the size of the source image

**WARNING:** With the input image you need to have it in the same folder as the convert tool, or a subfolder as it's volumed into the conversion tool via Docker and paths get mangled around. I suggest using the `input` folder, as that's the paradigm the tool has been using.

```
./docker-mender-convert from-raw-disk-image \
    --raw-disk-image "input/raspbian-lite-shrunk.img" \
    --artifact-name "smartboard-base" \
    --device-type "raspberrypi3" \
    --mender-client "/mender" \
    --bootloader-toolchain "arm-linux-gnueabihf" \
    --server-url "https://menderdev.pathfinder.gov.bc.ca" \
    --storage-total-size-mb "4000" \
    --data-part-size-mb "1000"
```

Building for Demo server:
```
./docker-mender-convert from-raw-disk-image \
    --raw-disk-image "input/raspbian-lite-shrunk.img" \
    --artifact-name "smartboard-base" \
    --device-type "raspberrypi3" \
    --mender-client "/mender" \
    --bootloader-toolchain "arm-linux-gnueabihf" \
    --demo-host-ip 10.0.0.5 \
    --demo \
    --storage-total-size-mb "4000" \
    --data-part-size-mb "1000"
```

## Step 2b: Flashing Base Images

Mender convert will produce 3 image files. Only two we are really concerned with.  The first named `mender-raspberrypi3-smartboard-base.sdimg` (`.sdimg` is the part we're interested in) is the file you will flash to an SD card. You can do this with `dd` or your favorite flashing tool.

```
dd if=mender-raspberrypi3-smartboard-base.sdimg /dev/your-sd-card-device bs=1m
```

## Step 3: Creating Artifacts

The other image you will be interested in is the `mender-raspberrypi3-smartboard-base.ext4`, it is the file that you will use to build artifacts on top of. The Menderized image is what is paired with your Mender Host, and creating the image is only required when you need to change the base image or change hosts.

Creating an artifact takes 3 parameters:
1. Menderized Image (the `mender-raspberrypi3-smartboard-base.ext4`)
2. Name of output artifact ('smartboard-base-v1')
3. Config.env file that contains all the configuration options. See `config.example.env` to see what this files should contain

Then you can run:

```
# Run this the first time to make sure the container is built
artifact-builder/docker-build

# Build the artifact from the base image
artifact-builder/build-artifact \
    mender-convert-output/mender-raspberrypi3-smartboard-base.ext4 \
    smartboard-base-v1 \
    config.env
```

Now you've created a new `smartboard-base-v1.mender` and you and upload this in the Mender web administration at: [https://mender.pathfinder.gov.bc.ca/]