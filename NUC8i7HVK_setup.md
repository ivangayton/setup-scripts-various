# Setting up a NUC8i7HVK with Ubuntu 18.04 with AMD VEGAM graphics

I love my NUCs, and when I gave my mine to my daughters to watch movies and play games on, I had a perfect excuse to purchase a shiny new Hades Canyon NUC (NUC8i7HVK) with an AMD Vega M graphics card. Little did I know GNU/Linux wasn't supported on it; I wrongly assumed that all NUCs were compatible with my preferred OS. I'm not gonna use Windows, so I was forced to put some time into setting up my NUC.

Thank goodness for the really smart people who actually figured out how to do it; I'm just documenting the steps I took trom their advice so that others can do the same (I've also linked to pretty much every page where I found good advice on this problem). The keystone advice came from user834610 on [this](https://askubuntu.com/questions/1040440/graphics-drivers-for-intel-nuc-hades-canyon-nuc8i7hvk-amd-radeon-rx-vega-gh/1057051#1057051) page and from a bunch of people [here](https://www.reddit.com/r/intelnuc/comments/8ub4cc/running_linux_on_the_nuc8i7hnk_hades_canyon/).

*Note: My Hades Canyon NUC is the one with the i78809G CPU (the more powerful of the two available options). From what I've read, at least one of the steps below may fail on the HC NUC with the other CPU. Fair warning!*

# Update firmware
- Download the BIOS file from [here](https://downloadcenter.intel.com/download/28073/BIOS-Update-HNKBLi70-86A-) (use the one for the F7 BIOS Update method)
- Update the BIOS using [these](https://www.intel.com/content/www/us/en/support/articles/000005850/mini-pcs.html) instructions.

# Install Ubuntu 18.04 from a USB stick
Make an Ubuntu startup media on a USB flash drive. I was about to link to the instructions for doing that, but if you don't know how to do this already, it is probably not a good idea for you to continue down this road; it gets a little hairy if you're a newbie to GNU/Linux! This NUC is not the place for your first Ubuntu rodeo.
- Plug in the USB startup media and fire up the NUC. It won't work. It'll show you the traditional choices (try Ubuntu, install Ubuntu), but no matter what you choose, you'll get a black screen.
  - That's because the Linux grahics card drivers on the live media can't deal with the hardware. You need to dumb everything down by telling the kernel "nomodeset," meaning it's not allowed to start video drivers until the system is running.
- After turning on the NUC, the moment you see the Grub screen (the try vs install options), press 'e'. That'll get you to a screen where you can configure the boot options.
  -Replace the words 'quiet splash' with 'nomodeset'. A bit like [this](https://askubuntu.com/questions/1037865/hades-canyon-nuc8i7hvk-can-install-but-cant-boot) but actually removing the 'quiet splash' (because instead of a pretty splash screen now you'll see what's actually going on - that's the not 'quiet' part).
  - Press Control-X to exit and boot. Now it should work.
- Go through the usual process of installing Ubuntu.
- When it finishes, it'll fail to boot again, since the newly installed Ubuntu doesn't have the nomodeset parameter and will try to activate the ungovernable video hardware.
  - Do the whole nomodeset dance again. [Here](https://askubuntu.com/questions/38780/how-do-i-set-nomodeset-after-ive-already-installed-ubuntu/38782#38782) is a pretty good explanation of how to make the nomodeset option persistent (edit the /etc/default/grub file to add the nomodeset and then run sudo update-grub2).
  - I actually just booted, hit Control-Alt-F3 to get to a tty terminal instead of going to the GUI environment, edited the /etc/default/grub file (changed the line ```GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"``` to ```GRUB_CMDLINE_LINUX_DEFAULT="nomodeset"```, then ran sudo update-grub2 and rebooted. That worked and maybe saved a minute or two.
- You should end up with a working installation, but you'll notice that you can't change the display parameters, the HDMI sound output may not work, and if you try GLmark2, GLXGears -info, or glxinfo, you'll see that there's no hardware accleration. In other words, you've just put all of your hopes and dreams into the NUC's graphics card in vain. You are where the person who asked [this](https://askubuntu.com/questions/1040440/graphics-drivers-for-intel-nuc-hades-canyon-nuc8i7hvk-amd-radeon-rx-vega-gh/1057051#1057051) question was!

Now comes the tricky part. In order to get the graphics drivers working, we need to:

- Upgrade the Linux kernel to 4.18 or higher
- Grab the vegam firmware blobs needed to talk to the hardware
- Update Mesa to at least 18.1

# Update the kernel

Ubuntu comes with a frozen kernel. Version 18.04 Bionic Beaver comes with Linux kernel 4.15, and that's what you get. The drivers for the AMD GPU come with Linux 4.17, and from what I understand serious support comes only with 4.18. In any case, you'll have to upgrade.

You can do that manually like this:

```
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.18-rc5/linux-headers-4.18.0-041800rc5_4.18.0-041800rc5.201807152130_all.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.18-rc5/linux-headers-4.18.0-041800rc5-generic_4.18.0-041800rc5.201807152130_amd64.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.18-rc5/linux-image-unsigned-4.18.0-041800rc5-generic_4.18.0-041800rc5.201807152130_amd64.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.18-rc5/linux-modules-4.18.0-041800rc5-generic_4.18.0-041800rc5.201807152130_amd64.deb
sudo dpkg -i linux-*.deb
```

But I cheated and just used UKUU.

```
sudo add-apt-repository ppa:teejee2008/ppa
sudo apt update
sudo apt install ukuu
```

Ran UKUU from the GUI, chose the Linux Kernel 4.18.3, rebooted.

Of course, it failed to boot.

Because I had to go into the BIOS setup of the NUC and disable Secure Boot.

- On startup, press F2 to enter the settings, and set
  - Advanced > Boot > Secure Boot > Secure Boot Config > Secure Boot = unchecked
  - like [this](https://communities.intel.com/servlet/JiveServlet/download/543962-185888/SecureBoot.jpg)

After disabling Secure Boot, Ubuntu came up just fine, and running ```uname -a``` showed that I was now running the 4.18 kernel.

# Upgrade Mesa

```
sudo add-apt-repository ppa:ubuntu-x-swat/updates
sudo apt dist-upgrade
```

# Grab the AMD Vega M Linux driver and put it in the appropriate directory

```
wget -m -np https://people.freedesktop.org/~agd5f/radeon_ucode/vegam/
sudo cp people.freedesktop.org/~agd5f/radeon_ucode/vegam/*.bin /lib/firmware/amdgpu
```

Then update your Initial Ramdisk to recognize/choose the right kernel:
```
sudo /usr/sbin/update-initramfs -u -k all
```

# Turn off the nomodeset option again

- Change the relevant line in /etc/default/grub to ```GRUB_CMDLINE_LINUX_DEFAULT=""```
- Run ```sudo update-grub2``` and reboot

# Download some video games or something.

I ran glxmark2 and got a score of 10777. As far as I know, that's pretty good.