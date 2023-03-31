# Turbo spin echo

![Turbo spin echo](../gif/mridemo_t2w_turbo_spin_echo.gif)

The spin-echo sequence is used to produce a T2-weighted contrast. However, it is a slow sequence as it demands long repetition times. The turbo-spin-echo sequence
can be used to accelerate the imaging process, by acquiring many echoes instead of just one. This is achieved by the executing of many 180&deg; pulses. 
Very high acceleration factors can be achieved by this approach. 
The downside is that this is a SAR-intensive sequence, and that the contrast is not identical to that obtained by a regular spin-echo sequence.

[Code for the illustration can be found here](../code/mridemo_t2w_turbo_spin_echo.m)
