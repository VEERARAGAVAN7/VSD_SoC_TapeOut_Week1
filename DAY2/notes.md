# DAY-2  Timing libs,hierarchical vs flat synthsis and efficient flop coding styles

## VLSI Library Overview

## 1. What is a library in VLSI?

A library is a collection of pre-designed, pre-characterized cells (like gates, flip-flops, multiplexers, etc.) that you can use to build larger circuits.
Think of it as a toolbox for digital designers.Each cell in the library comes with functional description, timing info, and electrical characteristics.

---

## 2. Types of library files

In VLSI, library files are usually of different types, serving different purposes in the design flow:

### a) Behavioral / RTL libraries
- Used during synthesis.
- Describe function of cells (like AND, OR, D Flip-Flop).
- Example: **liberty (.lib) file** — describes timing, power, and area.

### b) Layout / LEF files
- Used in place-and-route tools.
- **LEF = Library Exchange Format.**
- Contains physical dimensions, pin locations, metal layers.

### c) Gate-level / SPICE libraries
- Used in simulation and characterization.
- SPICE netlists describe transistor-level implementation for accuracy.

### d) Timing & power libraries
- **.lib (Synopsys Liberty format)** is the most common.
- Contains:
  - Timing models → delay, setup, hold.
  - Power models → dynamic, leakage.
  - Noise characteristics → signal integrity info.

---

## 3. Why library files are important

- **Saves time** → You don’t design every gate from scratch.
- **Accuracy** → Pre-characterized delays and power give realistic results.
- **Portability** → Tools like Synopsys, Cadence, or Mentor can use standard libraries.
- **Consistency** → All designers use the same definitions of cells.

---

## 4. Example flow using library files

1. **RTL Design** → You write Verilog/VHDL.
2. **Synthesis tool** → Uses .lib file to map RTL to gates.
3. **Place-and-route** → Uses LEF/DEF + cell library for physical design.
4. **Post-layout simulation** → Uses SPICE netlist of library cells for accurate timing.

![Library_file](Screenshots/library.png)

## 1. Library Declaration

```
library ("sky130_fd_sc_hd__tt_025C_1v80") {
```
- This names the library: sky130_fd_sc_hd__tt_025C_1v80.
- Likely for the SkyWater 130nm process.
- fd_sc_hd → full design, standard cells, high density.
- tt_025C_1v80 → typical process, 25°C, 1.8V supply.


## 2. Defines and Options

```
define(def_sim_opt, library, string);
define(driver_model, library, string);
...
```
- These are generic definitions for the library behavior, simulation, and power models.
- They provide default options for timing, leakage, switching, etc.

## 4. Default Parameters
```
default_cell_leakage_power : 0.0000000000;
default_max_transition : 1.5000000000;
```
- These are fallback values for cell characteristics if specific data is missing.
- Includes capacitances, max rise/fall time, leakage power, etc.

## 5. Operating Conditions

```
operating_conditions ("tt_025C_1v80") {
    voltage : 1.8;
    process : 1.0;
    temperature : 25.0;
    tree_type : "balanced_tree";
}
```

## Specifies the conditions under which timing and power are characterized:
- Voltage: 1.8V
- Temperature: 25°C
- Process corner: typical-typical (tt)

## 6. Power/Timing Templates

```
power_lut_template ("power_inputs_1") {
    variable_1 : "input_transition_time";
    variable_2 : "total_output_net_capacitance";
}
```
- Defines how power is calculated based on input transition time and load capacitance.
- These tables are later used by synthesis and static timing analysis tools.



## 1. What is Hierarchical Synthesis?

Hierarchical synthesis means that the synthesis tool understands the module hierarchy in your design. Instead of flattening everything into gates immediately, it:

- Recognizes submodules.
- Keeps the hierarchy in memory.
- Maps each module into standard cells or primitives.
- Combines submodules into higher-level modules.

Example:

fulladder
 ├─ halfadder (HA1)
 └─ halfadder (HA2)

Here, fulladder is the top module, and it contains two instances of halfadder. This is a two-level hierarchy.


## 2.Why hierarchy matters

- Reusability: You can reuse halfadder in other designs.
- Clarity: Makes large designs manageable.
- Optimizations: Synthesis tools can optimize modules individually or flatten only if needed.
- Debugging: Easier to simulate and verify smaller modules separately.

![Heirarchy_Synthesis](Screenshots/heirarchySynth.png)


## Flatten Synthesis

### 1. What is Flatten Synthesis?
Flatten synthesis is the process of removing the design hierarchy and converting the entire design into a single-level netlist of logic gates. In this process, submodules are eliminated, and their logic is merged into the top module.

---

### 2. Why it is Used?
- To allow the synthesis tool to view the entire design as one block.  
- Helps in performing aggressive global optimizations.  
- Can improve timing, area, and power efficiency of the design.  
- Useful for final implementation in ASIC/FPGA flows.

---

### 3. Importance of Flatten Synthesis
- Provides better optimization opportunities since module boundaries are removed.  
- Ensures maximum performance for critical designs.  
- Commonly applied before place-and-route to achieve efficient mapping.  
- However, it reduces readability and makes debugging harder, so it is usually applied only at later stages of the design flow.

![Flatten_Synthesis](Screenshots/flattenSynth.png)


# Flip-Flop Coding Styles

## Asynchronous Reset
In asynchronous reset, the reset signal forces the flip-flop output to `0` immediately, regardless of the clock.  
The reset has higher priority and is checked along with the clock edge.

### Code:
```verilog
module Asyn_reset(input clk, Asyn_rst, D, output reg Q);
always @(posedge clk, posedge Asyn_rst) begin
    if (Asyn_rst)
        Q <= 1'b0;
    else
        Q <= D;
end
endmodule
```
![Asynchronous_Reset](Screenshots/Asyn_rst.png)

## Asynchronous Set
In asynchronous set, the set signal forces the flip-flop output to 1 immediately, regardless of the clock.
The set has higher priority and is checked along with the clock edge.

### Code :
```
module Asyn_reset(input clk, Asyn_set, D, output reg Q);
always @(posedge clk, posedge Asyn_set) begin
    if (Asyn_set)
        Q <= 1'b1;
    else
        Q <= D;
end
endmodule

```
![Asynchronous_Set](Screenshots/Asyn_set.png)


## Synchronous Reset
In synchronous reset, the reset signal is checked only at the active clock edge.
Unlike asynchronous reset, it won’t affect the output until a clock edge occurs.

### code :
```
module Syn_reset(input clk, Syn_rst, D, output reg Q);
always @(posedge clk) begin
    if (Syn_rst)
        Q <= 1'b0;
    else
        Q <= D;
end
endmodule

```
![Synchronous_Reset](Screenshots/Syn_rst.png)

## Synthesis with Yosys

### Start Yosys:
```
yosys
```
### Read Liberty library:
```
read_liberty -lib /home/veeraragavan/VSD_Soc_TapeOut_Program/VSD/sky130RTLDesignAndSynthesisWorkshop/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```
### Read Verilog code:
```
read_verilog Asyn_rst.v
```
### Synthesize:
```
synth -top dff_asyncres
```
### Map flip-flops:
```
dfflibmap -liberty /home/veeraragavan/VSD_Soc_TapeOut_Program/VSD/sky130RTLDesignAndSynthesisWorkshop/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```
### Technology mapping:
```
abc -liberty /home/veeraragavan/VSD_Soc_TapeOut_Program/VSD/sky130RTLDesignAndSynthesisWorkshop/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```

### Visualize the gate-level netlist:
```
show
```

![Dff_Netlist](Screenshots/dff_net.png)


## Summary
This overview provides you with practical insights into timing libraries, synthesis strategies, and reliable coding practices for flip-flops. Continue experimenting with these concepts to deepen your understanding of RTL design and synthesis.


