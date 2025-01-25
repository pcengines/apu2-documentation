#!/bin/sh
###
# APU firmware updater for OPNsense.
#
# Requires:
# - flashrom (pkg install -y flashrom)
#
# Installation:
# - Login via SSH to the firewall
# - Create the script where you want it
# - Make it executable (chmod +x apu_fw_updater_opnsense.sh)
###

# Params

# Type of APU (apu1, apu2, apu3, apu4, apu5, apu6)
TYPE="apu2"

# Version of firmware
VERSION="4.17.0.3"

# Do not edit after this line
SRC="https://dl.3mdeb.com/open-source-firmware/pcengines/${TYPE}/"
PREFIX="${TYPE}_v${VERSION}"
FILE="${PREFIX}.rom"
CHECKSUM="${PREFIX}.SHA256"
NUMBER="$(echo ${TYPE} | tr -dc '0-9')"

echo
echo "+-----------------------------------+"
echo "| APU firmware updater for OPNsense |"
echo "+-----------------------------------+"

cd "/tmp" || exit

log () {
  echo
  echo "$(date +"%Y-%m-%d %T") | ${1}"
}

log_sub () {
  echo "                    | ${1}"
}

params () {
  log "Params"
  log_sub "Type: ${TYPE}"
  log_sub "Version: ${VERSION}"
}

verify () {
  if [ $? != 0 ]; then
    log_sub "... failed."

    echo
    exit 1
  fi
}

download () {
  log "Downloading files ..."

  log_sub "- ${FILE}"
  curl -sS "${SRC}${FILE}" -o "${FILE}"

  log_sub "- ${CHECKSUM}"
  curl -sS "${SRC}${CHECKSUM}" -o "${CHECKSUM}"

  verify

  log_sub "... done."
}

checksum () {
  log "Verify checksum ..."

  shasum -c "${CHECKSUM}"

  verify

  log_sub "... done."
}

flash () {
  log "Flash firmware ..."

  if [ "${NUMBER}" -gt 1 ]; then
    # APU2/3/4/5/6
    flashrom -w "${FILE}" -p internal
  else
    # APU1
    flashrom -w "${FILE}" -p internal -c "MX25L1605A/MX25L1606E/MX25L1608E"
  fi

  log_sub "... done."
}

cleanup () {
  log "Cleanup ..."

  log_sub "- ${FILE}"
  rm "${FILE}"

  log_sub "- ${CHECKSUM}"
  rm "${CHECKSUM}"

  log_sub "... done."
}

do_reboot () {
  log "Rebooting in 5s ..."

  sleep 5

  reboot
}

params

download

checksum

flash

cleanup

do_reboot

echo
exit 0
