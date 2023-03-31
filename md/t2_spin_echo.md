# T2-weighted spin echo

![T2-weighted spin echo](../gif/mridemo_t2w_spin_echo.gif)

The magnetization vectors start to dephase following the initial RF pulse due to local inhomogeneities in the magnetic field. A 180&deg; pulse is used to 
reverse the phase distribution, which produces an echo at a later time point. This cancels the effects of the local field inhomogeneities, however,
T2 relaxation still occurs. The echo signal is hence T2-weighted, but not T2*-weighted. 

[Code for the illustration can be found here](../code/mridemo_t2w_spin_echo.m)
