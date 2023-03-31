# T1-weighted spoiled gradient echo

![T1-weighted spoiled gradient echo](../gif/mridemo_t1w_spoiled_gre.gif)

In pulse sequences with short repetition times, we produce a signal that is T1-weighted. However, the signal remaining from previous RF pulses
does not disappear just because we execute another RF pulse. If we want to get rid of the signal from the previous RF-pulses, we need to 
"spoil" this signal. This can be done either with gradients of by varying the phase of the RF pulses. In this illustration, the spoiling is done 
in a non-physical way by accelerating the T2-relaxation which "pushes" the magnetization vector back to the z-axis. Practical details can be found
in the references below.

[Code for the illustration can be found here](../code/mridemo_t1w_spoiled_gre.m)

## References

- Markl, Michael, and Jochen Leupold. "Gradient echo imaging." Journal of Magnetic Resonance Imaging 35.6 (2012): 1274-1289.
