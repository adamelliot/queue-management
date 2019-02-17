# Building Images to Prepare for Mender Deployment

## Prerequisites

- **Ubuntu 18.04**
- 10 gigabytes of storage

## Step 1: Building Base Image (Bootstrapping)

The first image that needs to be built is the base raspbian image that will be "menderized". This image is a modified version of the released image from Raspbian. It has much of the unneeded packages removed, and the base level of packages for all the features in our app.

First download the raspbian image from: [Raspberry Pi Images](https://www.raspberrypi.org/downloads/raspbian/). Download the [Raspbian Lite Image](https://downloads.raspberrypi.org/raspbian_lite_latest).

To shrink and prime the image run:
```
raspbian-trimmer/generate-image.sh 2018-11-13-raspbian-stretch-lite.img
```

## Step 2: Menderizing the image

The next step of the process involves turning the standard Raspbian image into **Menderized** image which can do OTA updates. To do this we will use the `mender-convert` utility.

```
git clone https://github.com/mendersoftware/mender-convert.git
cd mender-convert
git checkout 2743366

./docker-build
```

To generate the menderized image you will need to provide some information to the conversion tool:

1. Base Image (Built in **Step #1**)
2. URL Which will be Hosting Mender [https://mender.pathfinder.gov.bc.ca]
3. The service certificate the devices need to register with (all have the same cert)
4. The total store needs to be more than double the size of the source image

**WARNING:** With the input image you need to have it in the same folder as the convert tool, or a subfolder as it's volumed into the conversion tool via Docker and paths get mangled around. I suggest using the `input` folder, as that's the paradigm the tool has been using.

```
./docker-mender-convert from-raw-disk-image \
 	--raw-disk-image "input/2018-11-13-raspbian-stretch-lite.img" \
 	--mender-disk-image "digital-signage-base-image.sdimg" \
 	--device-type "raspberrypi3" \
 	--mender-client "/mender" \
 	--artifact-name "2018-11-13-raspbian-stretch-lite" \
 	--bootloader-toolchain "arm-linux-gnueabihf" \
 	--server-cert "/mender-convert/server.crt" \
 	--server-url "https://mender.pathfinder.gov.bc.ca" \
 	--storage-total-size-mb "3000" \
 	--data-part-size-mb "1000"
```

Building for Demo server:
```
./docker-mender-convert from-raw-disk-image \
 	--raw-disk-image "input/2018-11-13-raspbian-stretch-lite.img" \
 	--mender-disk-image "digital-signage-base-image.sdimg" \
 	--device-type "raspberrypi3" \
 	--mender-client "/mender" \
 	--artifact-name "2018-11-13-raspbian-stretch-lite" \
 	--bootloader-toolchain "arm-linux-gnueabihf" \
 	--demo-host-ip 10.0.0.5 \
 	--demo \
 	--storage-total-size-mb "3000" \
 	--data-part-size-mb "1000"
```

### Step 3: Creating Artifacts

