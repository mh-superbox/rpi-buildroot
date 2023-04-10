# Default environments
setenv console "serial"
setenv verbosity "6"

test -n "${BOOT_ORDER}" || setenv BOOT_ORDER "A B"
test -n "${BOOT_A_LEFT}" || setenv BOOT_A_LEFT 3
test -n "${BOOT_B_LEFT}" || setenv BOOT_B_LEFT 3

# Set console arguments
test "${console}" = "display" && setenv consoleargs "console=tty1"
test "${console}" = "serial" && setenv consoleargs "console=tty1 console=ttyS0,115200"

# Preserve origin bootargs
setenv bootargs_rpi
setenv fdt_org ${fdt_addr}
fdt addr ${fdt_org}
fdt get value bootargs_rpi /chosen bootargs

# Default bootargs
setenv bootargs_default "rootfstype=ext4 rootwait ro loglevel=${verbosity} fsck.repair=yes 8250.nr_uarts=1 cgroup_enable=memory ${consoleargs} ${bootargs_rpi}"

raucargs=unset

for BOOT_SLOT in "${BOOT_ORDER}"; do
  if test "x${raucargs}" != "xunset"; then
    # skip remaining slots
  elif test "x${BOOT_SLOT}" = "xA"; then
    if test ${BOOT_A_LEFT} -gt 0; then
      echo "Trying to boot slot A, ${BOOT_A_LEFT} attempts remaining. Loading kernel ..."
      setexpr BOOT_A_LEFT ${BOOT_A_LEFT} - 1
      setenv load_kernel mmc 0:5 ${kernel_addr_r} /boot/Image
      raucargs="root=/dev/mmcblk0p5 rauc.slot=A"
    fi
  elif test "x${BOOT_SLOT}" = "xB"; then
    if test ${BOOT_B_LEFT} -gt 0; then
      echo "Trying to boot slot B, ${BOOT_B_LEFT} attempts remaining. Loading kernel ..."
      setexpr BOOT_B_LEFT ${BOOT_B_LEFT} - 1
      setenv load_kernel mmc 0:6 ${kernel_addr_r} /boot/Image
      raucargs="root=/dev/mmcblk0p6 rauc.slot=B"
    fi
  fi
done

if test "x${raucargs}" = "xunset"; then
  echo "No valid slot found, resetting tries to 3"
  setenv BOOT_A_LEFT 3
  setenv BOOT_B_LEFT 3
  saveenv
  reset
fi

setenv bootargs "${raucargs} ${bootargs_default}"

# Store updated boot state...
saveenv

echo "Loading kernel"
run load_kernel

echo "Starting kernel"
booti ${kernel_addr_r} - ${fdt_addr}

echo "Boot failed, resetting..."
reset

# Recompile with:
# mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/efi/boot.scr
