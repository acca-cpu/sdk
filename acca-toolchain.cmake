#
# Copyright (C) 2023 Ariel Abreu
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

set(CMAKE_SYSTEM_NAME BARE_METAL)
set(CMAKE_SYSTEM_PROCESSOR acca)

set(CMAKE_SYSROOT "@ACCA_SYSROOT_DIR@" CACHE PATH "Acca system root directory")
set(ACCA_COMPILER_DIR "@ACCA_COMPILER_DIR@" CACHE PATH "Acca compiler toolchain directory")

execute_process(
	COMMAND "${ACCA_COMPILER_DIR}/bin/llvm-config" --version
	OUTPUT_VARIABLE "ACCA_COMPILER_VER_RAW"
	OUTPUT_STRIP_TRAILING_WHITESPACE
)
string(REGEX MATCH "^[0-9]+" "ACCA_COMPILER_VER_FOUND" "${ACCA_COMPILER_VER_RAW}")
set(ACCA_COMPILER_VER "${ACCA_COMPILER_VER_FOUND}" CACHE STRING "Acca compiler toolchain version" FORCE)

set(CMAKE_C_COMPILER "${ACCA_COMPILER_DIR}/bin/clang" CACHE FILEPATH "Acca C compiler")
set(CMAKE_C_COMPILER_ID_RUN TRUE)

set(CMAKE_CXX_COMPILER "${ACCA_COMPILER_DIR}/bin/clang++" CACHE FILEPATH "Acca C++ compiler")
set(CMAKE_CXX_COMPILER_ID_RUN TRUE)

set(CMAKE_LINKER "${ACCA_COMPILER_DIR}/bin/ld.lld" CACHE FILEPATH "Acca static linker")
set(CMAKE_OBJCOPY "${ACCA_COMPILER_DIR}/bin/llvm-objcopy" CACHE FILEPATH "Acca objcopy")
set(CMAKE_AR "${ACCA_COMPILER_DIR}/bin/llvm-ar" CACHE FILEPATH "Acca archiver")

set(CMAKE_C_FLAGS_INIT "-target acca-none-elf -ffreestanding -nostdlib \"-I${ACCA_COMPILER_DIR}/lib/clang/${ACCA_COMPILER_VER}/include\" --sysroot \"${CMAKE_SYSROOT}\"")
set(CMAKE_C_FLAGS_DEBUG_INIT "-O0 -g")
set(CMAKE_C_FLAGS_RELEASE_INIT "-O2")

set(CMAKE_CXX_FLAGS_INIT "${CMAKE_C_FLAGS_INIT}")
set(CMAKE_CXX_FLAGS_DEBUG_INIT "${CMAKE_C_FLAGS_DEBUG_INIT}")
set(CMAKE_CXX_FLAGS_RELEASE_INIT "${CMAKE_C_FLAGS_RELEASE_INIT}")

set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,-T,${ACCA_COMPILER_DIR}/lib/default.ld \"-fuse-ld=${CMAKE_LINKER}\" --sysroot \"${CMAKE_SYSROOT}\"")

set(CMAKE_C_STANDARD_DEFAULT 11)
set(CMAKE_CXX_STANDARD_DEFAULT 17)

function(acca_apply_rules target)
	add_custom_command(
		TARGET "${target}"
		POST_BUILD
		COMMAND "${CMAKE_OBJCOPY}" -O binary "$<TARGET_FILE:${target}>" "$<TARGET_FILE:${target}>.bin"
	)
endfunction()
