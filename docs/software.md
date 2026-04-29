# Software

<div class="nav-button-container">
<a href="index.html" class="nav-button">Home</a>
<a href="start-here.html" class="nav-button">Start Here</a>
<a href="hardware.html" class="nav-button">Hardware</a>
<span class="nav-button active">Software</span>
<a href="program-emmc.html" class="nav-button">Program eMMC</a>
<a href="resources.html" class="nav-button">Resources</a>
</div>

## Software Build Instructions

All software compilation in this section must be done on a Linux host system.

Three options are presented here for generating the software components used to update the eMMC boot flash:

   1. A script-driven Yocto build which will generate all required software components in a WIC image file that can be copied to the eMMC flash on the Achilles SOM.
   2. Build individual software components and create your own eMMC image file.
   3. Use the provided WIC image to update the eMMC, and then build the individual software components and only update the partitions as needed for your application.

### Option 1: Yocto Build
For an overview of the Yocto Project, visit the [Yocto Project Getting Started](https://www.yoctoproject.org/software-overview/) webpage.

For the best user experience, it is recommended to use the GSRD build script described on the **Start Here** page.

Advanced users may choose to run the **reflex-yocto-build** script separately by following these instructions.

The Yocto build is done by simply running 2 scripts:

- yocto-packages.sh - detects your host build system Linux distribution and installs a set of essential packages required by Yocto 
- reflex-yocto-build - script used to build individual components or a complete image for the Achilles SOM (use --help to see available build options). 

One advantage to the Yocto build is that at the end of the build process, you have a complete image ready to copy to the Achilles eMMC.  A disadvantage is that the intial build time can be long (over an hour depending on your host build system).  Subsequent builds complete much faster, as only required tasks will run (e.g. no need to fetch source code again).  Also, customizing the Yocto BSP layer to your application requirements has a steep learning curve if you are not familiar with the Yocto/OpenEmbedded build system.

1. If not already done in the **Hardware** section, open a system terminal console and create a working directory: 

    ```bash
    mkdir -p ~/achilles && cd ~/achilles
    ```

2. Install packages required for the Yocto build: 

    ```bash
    wget https://raw.githubusercontent.com/reflexces/build-scripts/2023.07/yocto-packages.sh
    chmod +x yocto-packages.sh
    sudo ./yocto-packages.sh 
    ```

3. Download the Yocto Build Script: 

    ```bash
    wget https://raw.githubusercontent.com/reflexces/build-scripts/2023.07/reflex-yocto-build
    chmod +x reflex-yocto-build
    ```

4. Choose one of the script build options below.

To see all available boards and build options: 

```bash
./reflex-yocto-build --help
```

To build the default console image for the Achilles module (this option generates the WIC image file): 

```bash
./reflex-yocto-build --board achilles-v5-indus --image console
```

To build U-Boot only:

```bash
./reflex-yocto-build --board achilles-v5-indus --image virtual/bootloader
```

To build the Linux kernel only:

```bash
./reflex-yocto-build --board achilles-v5-indus --image virtual/kernel
```

After the build completes successfully, all of the generated output files can be found in the directory **achilles-build-files/tmp/deploy/images/achilles-v5-indus**.  The main file of interest, **achilles-console-image-achilles-v5-indus.wic**, is copied to copied to the directory **achilles-emmc-image**.  This file can be used to program the entire eMMC.  Go to the **Program eMMC** page to view the table detailing the full list of files generated and for instructions to program the eMMC flash.

For Achilles Yocto builds using the **meta-achilles** layer, starting with the **kirkstone** branch and newer, the FPGA FIT images and optional devicetree overlays (used by the Partial Reconfiguration GHRD example) are now automatically generated during the Yocto build process.

For Yocto builds using the **meta-achilles** layer **honister** branch or older, these items are **not** automatically generated.  Instead, they are fetched from the **achilles-hardware** github repository and added to the WIC image during the Yocto build process.  If bringing your own Quartus hardware design, the FIT images will need to be manually generated and copied to the eMMC partition 1 (FAT partition).  FIT image generation is explained below under **Option 2: Generate FIT Images**.

#### Achilles Yocto BSP Layer Description
The tree below describes the directory structure found in the **meta-achilles** Yocto BSP layer and the function of each recipe.  If you want to further examine **meta-achilles** or any other layer used in the Yocto build process, you can find them in the generated build directory within the **layers** sub-directory.

```bash
📁 meta-achilles
├── 📁 conf (contains Achilles machine configuration file that defines HW configuration options, including U-Boot and kernel versions to build, instructions for files to include on the FAT partition of the WIC image, and other options)
├── 📁 recipes-achilles (recipes specific to Achilles SOM to demonstrate various features)
│   ├── 📁 achilles-firmware (recipe to add FPGA configuration files to image)
│   ├── 📁 achilles-fpga-init (recipe to create a systemd service to apply devicetree overlay)
│   └── 📁 achilles-usb-gadget (recipe to create a systemd service to enable USB Gadget support)
├── 📁 recipes-bsp (recipe to patch and build U-Boot)
├── 📁 recipes-core (recipes for misc. system configuration)
├── 📁 recipes-images (recipes for complete images for Achilles SOM)
├── 📁 recipes-kernel (recipes to patch, configure, and build Linux kernel)
└── 📁 wic (contains WIC kick start file to configure the generated WIC image)
```

### Option 2: Build U-Boot and Linux Kernel Individually
One advantage to building components individually is that the build time can be faster.  A disadvantage is that you need to manually create the image for programming the eMMC device, or update partitions separately.  You also still need a root filesystem, which can be built with other tools like Buildroot, or using "ready-made" root filesystem archives (e.g. Linaro).

Download the [Arm GNU Toolchain](https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain) to build the individual software components:

```bash
mkdir -p ~/armgcc && cd ~/armgcc
wget https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf.tar.xz
tar xf gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf.tar.xz
```

#### Build U-Boot
1. If not already done previously, create a working directory: 

    ```bash
    mkdir -p ~/achilles && cd ~/achilles
    ```

1. Setup the Arm tools build environment:

    ```bash
    export ARCH=arm
    export CROSS_COMPILE=~/armgcc/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-
    ```

3. Clone the **u-boot-socfpga** source repository.  Create and switch to a new branch (achilles) for our build.  We are checking out a specific revision within the socfpga_v2021.01 branch:

    ```bash
    git clone https://github.com/altera-opensource/u-boot-socfpga
    cd u-boot-socfpga
    git checkout -b achilles 24e26ba4a0d8fe816e32e760537a3f356823ba7b
    ```

4. Download and apply the Achilles U-Boot patch:

    ```bash
    # For Achilles v2 only
    wget https://raw.githubusercontent.com/reflexces/meta-achilles/kirkstone-2023.07/recipes-bsp/u-boot/files/v2021.07/0001-Add-Achilles-V2-support-for-u-boot-socfpga.patch
    git apply 0001-Add-Achilles-V2-support-for-u-boot-socfpga.patch
    
    # For Achilles v5 only
    wget https://raw.githubusercontent.com/reflexces/meta-achilles/kirkstone-2023.07/recipes-bsp/u-boot/files/v2021.07/0001-Add-Achilles-V5-support-for-u-boot-socfpga.patch
    git apply 0001-Add-Achilles-V5-support-for-u-boot-socfpga.patch
    ```

    **NOTE:** If you are building U-Boot for Achilles v2 Turbo or Achilles v5 you need to apply a second patch:

    ```bash
    wget https://raw.githubusercontent.com/reflexces/meta-achilles/kirkstone-2023.07/recipes-bsp/u-boot/files/v2021.07/0002-remove-sdram-size-check.patch
    git apply 0002-remove-sdram-size-check.patch
    ```

5. If you are bringing in your own FPGA design, run the Quartus handoff filter script to convert your hps.xml file to U-Boot header file to be used by the Achilles U-Boot devicetree.

    **NOTE:** If you used the Achilles GHRD as a starting point for your design and did not make changes to the HPS, this step is not required.

    ```bash
    ./arch/arm/mach-socfpga/qts-filter-a10.sh <path/to/your/quartus/project>/hps_isw_handoff/hps.xml arch/arm/dts/socfpga_arria10_achilles_handoff.h
    ```

6. Configure and build U-Boot for your version of Achilles SOM:

    ```bash
    make socfpga_arria10_achilles_v2_indus_defconfig
    #OR
    make socfpga_arria10_achilles_v2_lite_defconfig
    #OR
    make socfpga_arria10_achilles_v2_turbo_defconfig
    #OR
    make socfpga_arria10_achilles_v5_indus_defconfig
    #OR
    make socfpga_arria10_achilles_v5_lite_defconfig
    
    make -j 64
    ```

<!--
Create the bootable SPL image containing four identical SPL binaries and header required by the boot ROM.  
Note: You must be in the Embedded Command Shell environment (first step above) to run this command:

```bash 
mkpimage -hv 1 -o spl/spl_w_dtb-mkpimage.bin spl/u-boot-spl-dtb.bin spl/u-boot-spl-dtb.bin spl/u-boot-spl-dtb.bin spl/u-boot-spl-dtb.bin
```
-->
#### Generate FIT Images

This step is required only if you are not using the scripted build flow.

Now we can generate the FIT images using the split .rbf FPGA programming files generated in the **Hardware** section.  These are used by the SPL and U-Boot to configure the FPGA.  The Achilles U-Boot patch has configured the U-Boot source code to have the SPL load only the peripheral FPGA image, and then U-Boot loads the core image.  This is significantly faster than having the SPL load both images. 

**NOTE:** this process of generating FIT images is currently not run automatically during the Yocto build.  Instead, pre-generated FIT files using the Achilles GHRD .rbf files are fetched and included in the generated WIC eMMC image.  You must complete these steps if using your own custom FPGA design.

First create symbolic links to point to the location of the .rbf files generated in the **Hardware** section.  References below are to the Achilles GHRD .rbf files.  Replace with your own file names if applicable, but do not rename the .its or .itb file references since these are defined in U-Boot source code.  The .its files define the locataion and names of the .rbf files to be used when creating the .itb files.

```bash
ln -s <path/to/rbf/files>/achilles_ghrd.periph.rbf
ln -s <path/to/rbf/files>/achilles_ghrd.core.rbf
tools/mkimage -E -f board/reflexces/achilles-v5-indus/fit_spl_fpga_periph_only.its fit_spl_fpga_periph_only.itb
tools/mkimage -E -f board/reflexces/achilles-v5-indus/fit_spl_fpga.its fit_spl_fpga.itb
```

Now we have the following files that can be copied to the eMMC:

| File                         | Description                                             | eMMC Partition       |
|------------------------------|---------------------------------------------------------|----------------------|
| spl/u-boot-splx4.sfp         | Multiple SPL binaries with devicetree and header info   | Partition 2 (A2 raw) |
| u-boot.img                   | U-Boot binary image                                     | Partition 1 (VFAT)   |
| achilles_ghrd.core.rbf       | core.rbf image for FPGA core image configuration	     | Partition 1 (VFAT)   |
| fit_spl_fpga_periph_only.itb | FIT image for FPGA peripheral image configuration only	 | Partition 1 (VFAT)   |
| fit_spl_fpga.itb             | FIT image for FPGA core image configuration             | Partition 1 (VFAT)   |

If you compiled your own FPGA design or made modifications to the GHRD, you must manually copy the generated files listed above to the appropriate eMMC partition.  Refer to the instructions on the **Program eMMC** page.

Note: Either the .rbf or .itb file can be used for FPGA core image configuration in U-Boot.  The .itb file is used by default U-Boot environment commands.  Both files are included for completeness of the example.
To load the .rbf file from U-Boot, enter the command at the U-Boot prompt:

```bash
load mmc 0:1 ${loadaddr} achilles_ghrd.core.rbf
fpga load 0 ${loadaddr} 0xE20000
```

#### Build Linux Kernel
1. If not already done previously, create a working directory:

    ```bash
    $ mkdir -p ~/achilles && cd ~/achilles
    ```

2. Clone the **linux-socfpga** kernel source repository.  Create and switch to a new branch (achilles) for our build, specifying the branch corresponding to the kernel version you want to build:

    ```bash
    git clone https://github.com/altera-opensource/linux-socfpga
    cd linux-socfpga
    git checkout -b achilles -t origin/socfpga-5.10.100-lts
    ```

3. Download and apply the Achilles Linux devicetree patch:

    ```bash
    wget https://raw.githubusercontent.com/reflexces/meta-achilles/kirkstone-2023.07/recipes-kernel/linux/config/socfpga-5.10-lts/patches/0001-add-achilles-devicetree.patch
    git apply 0001-add-achilles-devicetree.patch
    ```

4. If working in a different terminal session from the one used previously to build U-Boot, you will need to setup the Arm tools build environment again:

    ```bash
    export ARCH=arm
    export CROSS_COMPILE=~/armgcc/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-
    ```

    Configure and build the Linux kernel:

    ```bash
    make mrproper
    make socfpga_defconfig
    ```

5. If you want to include support for USB Gadget (as done in the Yocto build), then add that kernel configuration fragment.  You can add any additional kernel configuration options as required for your application at this time.

    ```bash
    wget https://raw.githubusercontent.com/reflexces/meta-achilles/kirkstone-2023.07/recipes-kernel/linux/config/socfpga-5.10-lts/cfg/usb-gadget.cfg
    ./scripts/kconfig/merge_config.sh .config usb-gadget.cfg 
    ```

6. Build the kernel image, Achilles devicetree, and kernel modules.

    ```bash
    make -j 64 zImage socfpga_arria10_achilles_v5_indus.dtb modules
    ```

7. Install the kernel modules:

    ```bash
    make modules_install INSTALL_MOD_PATH=modules_install 
    rm -rf modules_install/lib/modules/**/build 
    rm -rf modules_install/lib/modules/**/source
    mkdir -p linux-bin/a9
    ln -s arch/arm/boot/zImage linux-bin/a9/
    ln -s arch/arm/boot/dts/socfpga_arria10_achilles_v5_indus.dtb linux-bin/a9/
    ln -s modules_install/lib/modules linux-bin/a9/
    ```

8. Archive the modules for transfer to the eMMC.

    ```bash
    kernel_mod_dir=$(ls modules_install/lib/modules/)
    tar -czvf modules_install/lib/modules/modules.tar.gz modules_install/lib/modules/$kernel_mod_dir
    ```
<!--
where x.x.xx is the kernel version number you built (use Linux tab-completion to help complete the full path name).
-->

Now we have the following files that will be copied to the eMMC:

| File Name                                               | Description               | eMMC Partition                  |
|---------------------------------------------------------|---------------------------|---------------------------------|
| arch/arm/boot/zImage	                                  | Compressed kernel image   | Partition 1 (VFAT)              |
| arch/arm/boot/dts/socfpga_arria10_achilles_v5_indus.dtb | Achilles Linux devicetree | Partition 1 (VFAT)              |
| modules_install/lib/modules/modules.tar.gz              | Kernel modules archive    | Partition 3 (EXT4) /lib/modules |

### Devicetree Overlays
A devicetree overlay is used to dynamically add additional device nodes to the "live" devicetree currently loaded by the kernel.  An overlay can add peripherals that are implemented in FPGA logic (e.g. UART, soft Ethernet MAC, PIO, etc.) or external peripherals that connect to the hard interfaces in the HPS (e.g. I2C or SPI devices, USB, or Ethernet).  External peripherals would typically connect through the FMC connector to the baseboard that the Achilles SOM is plugged into, or through an FMC daughterboard plugged into the Achilles top FMC connectors.  Overlays can also be used to configure or reconfigure the FPGA.  Alternatively, any custom peripheral (in the FPGA or external) could be added to the base devicetree source file provided here in the GSRD, but reconfiguring PR regions through Linux can only be done with the use of an overlay.  Note that there are kernel configuration elements that are required to support this and they are included in the standard default **defconfig** file used to build the kernel for Arria 10 SoC devices.  More information is available in the kernel Documentation folder.

**Creating and Compiling an Overlay**

For Achilles Yocto builds using the **meta-achilles layer**, starting with the **kirkstone** branch and newer, the optional devicetree overlays (used by the Partial Reconfiguration GHRD example) are now automatically generated during the Yocto build process.

For Yocto builds using the **meta-achilles** layer **honister** branch or older, you will still need to manually compile your devicetree overlays.  Pre-compiled binaries (.dtbo files) specific to the GHRD PR example are fetched and added to the generated eMMC image during the Yocto build.  To compile your own overlays, you will need to follow the steps above for **Build Linux Kernel** under Option 2 to clone the **socfpga-linux** repository and compile the .dtso files.  Several example devicetree source overlay (.dtso) files are included in the **devicetree** directory of the GHRD to demonstrate adding peripherals to the base devicetree, as well as configuring the partial reconfiguration region defined in the GHRD.  If you want to recompile the source files, or need to modify them to fit your application, follow these steps:

Clone the **linux-socfpga** kernel source repository as instructed above.

Copy the .dtso files to the kernel source tree folder containing all of the mainlined devicetrees (**arch/arm/boot/dts**).

Compile the .dtso files using either of these 2 method:

- Use **make** as shown in the step above for building the Achilles kernel main devicetree.  If working in a different terminal session from the one used previously to build U-Boot, you will need to setup the Arm tools build environment again:
  ```bash
  export ARCH=arm
  export CROSS_COMPILE=~/armgcc/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-
  ```

  Then build the devicetree overlays:
  ```bash
  make -j 64 achilles_ghrd_base.dtb achilles_sysid.dtb blink_led_default.dtb blink_led_fast.dtb blink_led_slow.dtb
  ```

  Note that the **make** utility expects to see the .dts filename extension for devicetree input source files and will generate .dtb output files.  If you plan to use the test script provided in the **meta-achilles** layer to apply the overlays, you will need to manually rename the input .dtso to .dts, and the output .dtb to .dtbo.  There is no requirement in Linux to use these extensions; however, these are the extensions used in the GHRD example to differentiate them as devicetree overlays.
  
- Use the kernel source tree DTC tool.  **DO NOT** use the DTC tool from the Embedded Command Shell as instructed in AN 798 (link availabe on **Resources** page):
  ```bash
  dtc -@ -I dts -O dtb -o achilles_ghrd_base.dtbo achilles_ghrd_base.dtso
  dtc -@ -I dts -O dtb -o achilles_sysid.dtbo achilles_sysid.dtso
  dtc -@ -I dts -O dtb -o blink_led_default.dtbo blink_led_default.dtso
  dtc -@ -I dts -O dtb -o blink_led_fast.dtbo blink_led_fast.dtso
  dtc -@ -I dts -O dtb -o blink_led_slow.dtbo blink_led_slow.dtso		 
  ```

Copy the generated .dtbo files to the Achilles root filesystem **/lib/firmware** directory.  This is the default directory used by **configfs**, but other directories can be specified if desired.  Refer to the **Program eMMC** page for instructions on copying files to the various eMMC parititions.  In this case, you will be copying to partition 3 (the Linux EXT4 partition).

**Applying an Overlay**

A devicetree overlay is applied using the Linux **configfs**.  Create a **configfs** config_item and apply the overlay:
```bash
mkdir /sys/kernel/config/device-tree/overlays/my-overlay-dir-name
echo my-overlay-file.dtbo > /sys/kernel/config/device-tree/overlays/my-overlay-dir-name/path
```

where **my-overlay-dir-name** can be any arbitrary descriptive name, typically similar to the .dtbo file name.

You can check the status of the overlay:

```bash
cat /sys/kernel/config/device-tree/overlays/my-overlay-dir-name/status
applied
```

A script is provided as part of the GSRD and can be used to apply the various PR region overlays to change the LED blink rate, as demonstrated on the **Start Here** page.  The script is located on the Achilles root filesystem at **/home/root/pr_overlay.sh**.

<div class="nav-button-container">
<a href="index.html" class="nav-button">Home</a>
<a href="start-here.html" class="nav-button">Start Here</a>
<a href="hardware.html" class="nav-button">Hardware</a>
<span class="nav-button active">Software</span>
<a href="program-emmc.html" class="nav-button">Program eMMC</a>
<a href="resources.html" class="nav-button">Resources</a>
</div>
