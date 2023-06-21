GCCPARAMS = -std=gnu99 -ffreestanding -g -c

start.o: start.s
		i686-elf-gcc -std=gnu99 -ffreestanding -g -c start.s -o start.o

kernel.o: start.s
	i686-elf-gcc $(GCCPARAMS) kernel.c -o kernel.o

mykernel.elf:
	i686-elf-gcc -ffreestanding -nostdlib -g -T linker.ld start.o kernel.o -o mykernel.elf -lgcc

qemu:
	qemu-system-i386 -kernel mykernel.elf

clean:
	rm -rf *.o

mykernel.iso:
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	cp mykernel.elf iso/boot
	echo '' >> iso/boot/grub/grub.cfg
	echo 'menuentry "My Kernel" {' >> iso/boot/grub/grub.cfg
	echo '	multiboot /boot/mykernel.elf' >> iso/boot/grub/grub.cfg
	echo '	boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg
	grub-mkrescue iso -o mykernel.iso
	rm -rf iso

run:
	(vboxmanage controlvm "kOS" poweroff && sleep 1) || true
	vboxmanage startvm "kOS" &
