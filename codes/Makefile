all: CPU.out output.txt

clean:
	rm -f CPU.out CPU.vcd output.txt

CPU.out: *.v
	iverilog -Wall *.v -o CPU.out

output.txt: CPU.out
	./CPU.out
