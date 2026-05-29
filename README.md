# SPI Master Controller

## Overview

This project implements an 8-bit SPI Master Controller using Verilog and the Tiny Tapeout framework.

The design accepts 8-bit parallel input data and transmits it serially through the MOSI line using a Finite State Machine (FSM), shift register, bit counter, and SPI clock generation logic.

## Features

- 8-bit SPI transmission
- FSM-based control
- Shift register architecture
- SPI clock generation
- Chip Select (CS) control
- Busy status indication
- Tiny Tapeout compatible

## Inputs

| Signal | Description |
|----------|-------------|
| ui_in[7:0] | 8-bit data input |
| uio_in[0] | Start transmission |

## Outputs

| Signal | Description |
|----------|-------------|
| uo_out[0] | MOSI |
| uo_out[1] | SCLK |
| uo_out[2] | CS |
| uo_out[3] | BUSY |

## FSM States

IDLE → LOAD → TRANSFER → DONE

## Example

Input:

10110011

Output (MOSI):

1 → 0 → 1 → 1 → 0 → 0 → 1 → 1
