# ===== SETTINGS =====
TOP = tb_top
SIM = sim.out
VCD = dump.vcd

RTL = rtl/*.sv
TB  = sim/*.sv

# ===== DEFAULT =====
all: run

# ===== BUILD =====
build:
	iverilog -g2012 -I ./rtl -o $(SIM) $(RTL) $(TB)

# ===== RUN SIM =====
run: build
	vvp $(SIM)

# ===== OPEN WAVEFORM =====
wave: run
	surfer $(VCD)

# ===== ONLY OPEN WAVEFORM (если уже есть vcd) =====
view:
	surfer $(VCD)

# ===== CLEAN =====
clean:
	rm -f $(SIM) $(VCD)

# ===== PROGRAMM GENERATING

hex: bin
	hexdump -v -e '1/4 "%08x\n"' ./sim/programm.bin > ./sim/programm.hex

bin: compile
	riscv64-unknown-elf-objcopy -O binary \
	./sim/programm.elf \
	./sim/programm.bin

compile:
	riscv64-unknown-elf-gcc \
	-march=rv32i \
	-mabi=ilp32 \
	-nostdlib \
	-nostartfiles \
	./sim/crt0.s \
	./sim/programm.c \
	-o ./sim/programm.elf