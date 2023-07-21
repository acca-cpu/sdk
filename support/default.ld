SECTIONS {
	. = 0x00;
	.data.econfig : AT(ADDR(.data.econfig)) {
		*(.data.econfig)
		. = 0x400;
	}
	.text.start : AT(ADDR(.text.start)) { *(.text.start) }
	.text.exc : AT(ADDR(.text.exc)) { *(.text.exc) }
	.text ALIGN(0x100) : AT(ADDR(.text)) { *(.text) *(.text.*) }
	.data ALIGN(0x100) : AT(ADDR(.data)) { *(.data) *(.data.*) }
	.rodata ALIGN(0x100) : AT(ADDR(.rodata)) { *(.rodata) *(.rodata.*) }
	.bss ALIGN(0x100) : AT(ADDR(.bss)) { *(.bss) *(COMMON) }
}
