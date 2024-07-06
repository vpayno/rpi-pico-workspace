module hellopicow

go 1.22

require github.com/soypat/cyw43439 v0.0.0-20240627234239-a62ee4027d66

require (
	device/arm v0.0.0-00010101000000-000000000000 // indirect
	device/avr v0.0.0-00010101000000-000000000000 // indirect
	device/gba v0.0.0-00010101000000-000000000000 // indirect
	device/nxp v0.0.0-00010101000000-000000000000 // indirect
	device/riscv v0.0.0-00010101000000-000000000000 // indirect
	device/sam v0.0.0-00010101000000-000000000000 // indirect
	github.com/soypat/seqs v0.0.0-20240527012110-1201bab640ef // indirect
	github.com/tinygo-org/pio v0.0.0-20231216154340-cd888eb58899 // indirect
	golang.org/x/exp v0.0.0-20230728194245-b0cb94b80691 // indirect
	machine v0.0.0-00010101000000-000000000000 // indirect
	runtime/interrupt v0.0.0-00010101000000-000000000000 // indirect
	runtime/volatile v0.0.0-00010101000000-000000000000 // indirect
)

replace (
	cyw43439 => ../lib/cyw43439
	device/arm => ../lib/tinygo/src/device/arm
	device/arm64 => ../lib/tinygo/src/device/arm64
	device/asm.go => ../lib/tinygo/src/device/asm.go
	device/avr => ../lib/tinygo/src/device/avr
	device/gba => ../lib/tinygo/src/device/gba
	device/nxp => ../lib/tinygo/src/device/nxp
	device/riscv => ../lib/tinygo/src/device/riscv
	device/sam => ../lib/tinygo/src/device/sam
	drivers => ../lib/drivers
	internal/bytealg => ../lib/tinygo/src/internal/bytealg
	internal/fuzz => ../lib/tinygo/src/internal/fuzz
	internal/reflectlite => ../lib/tinygo/src/internal/reflectlite
	internal/task => ../lib/tinygo/src/internal/task
	machine => ../lib/tinygo/src/machine/
	os => ../lib/tinygo/src/os/
	reflect => ../lib/tinygo/src/reflect/
	runtime => ../lib/tinygo/src/runtime/
	runtime/interrupt => ../lib/tinygo/src/runtime/interrupt/
	runtime/metrics => ../lib/tinygo/src/runtime/metrics/
	runtime/trace => ../lib/tinygo/src/runtime/trace/
	runtime/volatile => ../lib/tinygo/src/runtime/volatile/
	sync => ../lib/tinygo/src/sync/
	testing => ../lib/tinygo/src/testing/
)
