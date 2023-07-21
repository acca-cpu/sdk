#!/usr/bin/env bash

if [ "x${DESTDIR}" == "x" ]; then
	DESTDIR="/opt/acca-sdk"
fi

SRC_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

SYSROOT="${DESTDIR}/sysroot"
COMPILER_DIR="${DESTDIR}/toolchain"

mkdir -p "${SYSROOT}"
mkdir -p "${COMPILER_DIR}"

mkdir -p "${COMPILER_DIR}/cmake"
sed "s:@ACCA_SYSROOT_DIR@:${SYSROOT}:;s:@ACCA_COMPILER_DIR@:${COMPILER_DIR}:" "${SRC_DIR}/acca-toolchain.cmake" > "${COMPILER_DIR}/lib/cmake/acca-toolchain.cmake"

mkdir -p "${COMPILER_DIR}/lib"
cp "${SRC_DIR}/support/default.ld" "${COMPILER_DIR}/lib/default.ld"

(cd "${SRC_DIR}" && find include -type f -exec install -Dm 644 "{}" "${SYSROOT}/{}" \;)
