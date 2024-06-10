# DNA_ThermoProp_AutoFormatter 

## Description
This MATLAB script calculates the thermodynamic properties for a given set of DNA sequences using the `oligoprop` function. 
The script is divided into three parts and only contains Enthalpy, Entropy and Gibbs Free Energy calculation:
1. **Part 1**: Display thermodynamic properties by Sequence.
2. **Part 2**: Display thermodynamic properties by Reference.
3. **Part 3**: Display thermodynamic properties by Properties.

## How to Use
1. Open the script `DNA_ThermoProp_AutoFormatter.m` in MATLAB.
2. Modify the `sequences` array at the beginning of the script to include your desired DNA sequences.
3. Run the script.
4. The formatted output will be displayed in the MATLAB Command Window. You can copy and paste this output into Excel for easier calculation.

## Dependencies
- MATLAB (with the Bioinformatics Toolbox)

## Reference
- For more information on the `oligoprop` function, visit the MATLAB documentation: [oligoprop Documentation](https://www.mathworks.com/help/bioinfo/ref/oligoprop.html)

## Author
- Yi Zeng

## Date
- June 10, 2024

## Example
Here's an example of how to modify the sequences and run the script:

```matlab
% Define the sequences
sequences = {'TTTTTTTTT', 'AAAAAAAA', 'ACGGGGGGG', 'GATCCAAA', 'GTGTCAAA'};

% Run the script
DNA_ThermoProp_AutoFormatter
