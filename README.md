**Introduction** </br>
An asynchronous FIFO (First-In-First-Out) is a type of data buffer that handles data transfers between two systems operating at different clock frequencies. This project implements an asynchronous FIFO using Verilog.


![general approach of FIFO design](https://github.com/user-attachments/assets/49b3c760-1daf-47ce-b09d-4fd87ec0bb48)


**Features** </br>
Asynchronous read and write operations </br>
Configurable FIFO depth and data width </br>
Overflow and underflow protection </br>
Full and empty status flags </br>
Indivual testbenches for each Submodule </br>

**Implementation** </br>
Implementation of a circular Asynchronous FIFO Buffer has been made according to the block diagram given above</br>
Wrap around condition is checked using an additional bit </br>
Clock Domains have been synchronised using Two Flop Synchronisers </br>
Conversions from Binary Code to Gray Code and vice versa have been implemented wherever necessary</br>

**Requirements:** </br>
Icarus Verilog </br>
GTKWave </br>

**Contributing** </br>
Contributions are welcome! Please fork the repository and create a pull request with your changes. For major changes, please open an issue first to discuss what you would like to change.


