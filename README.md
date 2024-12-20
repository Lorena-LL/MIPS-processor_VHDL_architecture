# MIPS-processor_VHDL_architecture

This project implements a MIPS single-cycle processor in VHDL. It helped me understand complex concepts like RISC(Reduced Instruction Set Computer), ISA (Instruction Set Architecture), and the overall architecture of a processor.<br>

## How It Works

The processor performs the following key steps during execution:

- **Fetch**: The instruction is fetched from the instruction memory.
- **Decode**: The instruction is decoded to determine the operation to be performed.
- **Execute**: The operation is executed on the data in the registers and memory.
- **Memory Access**: If required, data is read from or written to the memory.
- **Write Back**: The result of the operation is written back to the registers or memory.

## Files

- **Code folder**: Contains the VHDL source files implementing the MIPS processor and the program that counts the negative numbers.
- **.xdc constraints file**: Specifies the constraints for the Vivado project, ensuring proper mapping of signals to the hardware pins on the Nexys A7 board.
- **instructions.txt**: Explains the code for the program loaded in the instruction memory.
- **.bit bitstream file**: File to be loaded on the board.

## How to Use

1. **Install Vivado**: Ensure you have Vivado installed on your computer. You can download it from the Xilinx website: [Vivado Design Suite](https://www.xilinx.com/support/download.html).
   
2. **Create a Vivado Project**:
   - Open Vivado and create a new project.
   - Copy all the `.vhd` source files from the `Code` folder into your Vivado project directory.
   - Add the `.xdc` constraints file to your Vivado project.

3. **Generate the Bitstream**:
   - In Vivado, run synthesis and implementation.
   - You can generate your own `.bit` file using Vivado, or you can use the precompiled `.bit` file that I provided.

4. **Program the Nexys A7 Board**:
   - Connect your Nexys A7 board to your computer.
   - Use Vivado's "Program and Configure" option to load the `.bit` file onto the board.

5. **Running the Program**:
   To see that the MIPS processor is working correctly it already has a program loaded in the instruction memory, and necessary data in the memory data. The program loaded does the following:<br>
<div align=center><i>It counts how many negative numbers are in a list of `N` elements. The list of numbers is stored in the data memory starting at address `8`, and the total count of negative numbers is written to the data memory at address `0`. When done, the count number can be found in the data memory at the address `0`.</i></div>
   
## Acknowledgments
I completed the project under the guidance of the teachers at the Technical University of Cluj-Napoca.

