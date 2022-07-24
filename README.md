# Sequence-detection-and-selection-sort-using-Bluespec-System-Verilog-BSV-
The purpose is to implement a sequence detector algorithm and a selection sort algorithm using BSV.

### Sequence Detector Algorithm: 
Here we are taking a 32 bit input stream. We are going to search through it, in order to find the
desired pattern.
The input bitstream taken is:
            detect.iData.put(32'b10101000111100001111010010110000);
Let's say, are looking for the pattern “1010”. This pattern can be overlapping. If we look closely we see that the pattern occurs three times in our sequence.


The terminal view is:

![seq_detect](https://github.com/Sarkar22/Sequence-detection-and-selection-sort-using-Bluespec-System-Verilog-BSV-/blob/main/seq_detect.PNG)
So, we can deduce that the code is working as intended.

### Selection Sort Algorithm:

Selection sort means if we take some number of inputs, then we need to first find the minimum number there, and we need to place it at the beginning of the sequence, considering we are doing it in ascending order. For the next iteration, we start from the second position, then repeat the procedure, but this time we find the minimum number among the remaining numbers and place it at the second position. So essentially we have to sort through a little less number of inputs.
For this task we have taken the input as:
                                    int x_arr[8] = {1,104,33,431,401, 301,200,50}
Since we are doing it in ascending order, the output should be: 1, 33, 50, 104, 200, 301, 401, 431

Here is the terminal view of the selection sort code:

![selection_sort](https://github.com/Sarkar22/Sequence-detection-and-selection-sort-using-Bluespec-System-Verilog-BSV-/blob/main/selection_sort.PNG)
