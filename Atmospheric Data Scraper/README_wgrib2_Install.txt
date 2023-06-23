Repo: https://github.com/jasper-software/jasper

1. Visit the Jasper project page on GitHub: https://github.com/jasper-software/jasper

2. Click on the green "Code" button and select "Download ZIP" to download the source code.

3. Extract the downloaded ZIP file.

4. Open a terminal, navigate to the extracted directory, and run the following commands to build and install Jasper:
```{bash}
mkdir build
cd build
cmake ..
make
sudo make install
```
5. After the installation, proceed with instructions to install wgrib2.
======================================================================================================================================================================================================================================
1. Open a terminal on your Linux system.

2. Update the package list by running the following command:
sudo apt update

3. Skip if installed manually. Install the necessary dependencies by running the following command:
sudo apt install build-essential gfortran libpng-dev libjasper-dev libjpeg-dev libnetcdf-dev

4. Download the wgrib2 source code. You can do this by visiting the following website:
http://www.cpc.ncep.noaa.gov/products/wesley/wgrib2/

Look for the "Download Source Code" link and download the latest version of the source code archive (e.g., wgrib2.tgz).

5. Extract the downloaded source code archive. In the terminal, navigate to the directory where you downloaded the archive and run the following command:
tar -xzf wgrib2.tgz

6. Change to the extracted directory:
cd grib2

7. Build and install wgrib2 by running the following commands:
make
sudo make install

8. After the installation is complete, you should be able to use wgrib2 from the command line. You can test it by running:
wgrib2 --version
