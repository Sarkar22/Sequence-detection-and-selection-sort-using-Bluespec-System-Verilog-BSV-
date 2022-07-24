# Sequence-detection-and-selection-sort-using-Bluespec-System-Verilog-BSV-
The purpose is to implement a sequence detector algorithm and a selection sort algorithm using BSV.

Here we are taking a 32 bit input stream. We are going to search through it, in order to find the
desired pattern.
The input bitstream we have taken is:
            detect.iData.put(32'b10101000111100001111010010110000);
We are looking for the pattern “1010”. This pattern can be overlapping. If we look closely we see that the pattern occurs three times in our sequence.


The terminal view is:
![seq_detect](https://github.com/Sarkar22/Sequence-detection-and-selection-sort-using-Bluespec-System-Verilog-BSV-/blob/main/seq_detect.PNG)
