all: CPU.out

clean:
	rm -f CPU.out CPU.vcd output.txt

CPU.out: *.v
	iverilog -Wall *.v -o CPU.out
