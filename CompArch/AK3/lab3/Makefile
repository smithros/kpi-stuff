SDK_PREFIX?=arm-none-eabi-
CC = $(SDK_PREFIX)gcc
LD = $(SDK_PREFIX)ld
SIZE = $(SDK_PREFIX)size
OBJCOPY = $(SDK_PREFIX)objcopy
QEMU = qemu-system-gnuarmeclipse
BOARD ?= STM32F4-Discovery
MCU=STM32F407VG
TARGET=firmware
CPU_CC=cortex-m4
TCP_ADDR=1234
#################
# CFLAGS
CFLAGS = -O0 -g3 -Wall
##################
# LDFLAGS
LDFLAGS = -Wall --specs=nosys.specs -nostdlib -lgcc  
##################
# PATH
APP_PATH=$(abspath ./)
##################
# add here GNU ASSEMBLY SOURCES .S
GASSRC += start.S
GASSRC += print.S
GASSRC += bootloader.S
##################
SOBJS = $(GASSRC:.S=.o)
COBJS = $(patsubst .c,%.o,$(APP_SRC))
.PHONY: all clean
# Path to directories containing application source 
vpath % $(APP_PATH)
all: $(TARGET).bin $(COBJS) $(SOBJS) $(TARGET).elf kernel.bin
%.o: %.S 
	$(CC) -x assembler-with-cpp  $(CFLAGS) -mcpu=$(CPU_CC) -c -o $@  $^

bootloader.S: kernel.bin
$(TARGET).elf: $(COBJS) $(SOBJS) 
	$(CC) -mcpu=$(CPU_CC) $(LDFLAGS) -T./lscript.ld -o $@ $^ $(INCFLAGS) 
$(TARGET).bin: $(TARGET).elf $(COBJS) $(SOBJS)
	$(OBJCOPY) -O binary   $(TARGET).elf  $(TARGET).bin
kernel.bin:
	$(CC) -x assembler-with-cpp  $(CFLAGS) -mcpu=$(CPU_CC) -c  kernel.S -o kernel.o
	$(CC) -x assembler-with-cpp  $(CFLAGS) -mcpu=$(CPU_CC) -c  print.S -o print.o
	$(CC) -mcpu=$(CPU_CC) $(LDFLAGS) -T./lscript_kernel.ld -o kernel.elf kernel.o print.o $(INCFLAGS)
	$(OBJCOPY) -O binary  kernel.elf  kernel.bin
qemu:
	$(QEMU)  --verbose --verbose --board $(BOARD) --mcu $(MCU) -d unimp,guest_errors --image $(TARGET).elf --semihosting-config enable=on,target=native -gdb tcp::$(TCP_ADDR)  -S
qemu_run:
	$(QEMU)  --verbose --verbose --board $(BOARD) --mcu $(MCU) -d unimp,guest_errors --image $(TARGET).elf --semihosting-config enable=on,target=native 

clean:
	-rm *.o
	-rm *.elf
	-rm *.bin

flash:
	st-flash write $(TARGET).bin 0x08000000
