# Diffusion-weighted imaging

![DWI](../gif/mridemo_diffusion.gif)

To create a diffusion-weighted sequence, a pair of gradients are inserted into a spin-echo sequence. The first of these gradients cause a phase dispersion,
which is completely reversed by the second gradient if the spins are not moving. However, if they move between the application of the first and second gradient,
the phase accrued by the first and second gradient will depend on how far they moved along the gradient. If the displacements are random - as is the case
for particles undergoing diffusion - this will result in a phase dispersion and hence an attenuation of the signal.

[The code for the figure can be found here](../code/mridemo_diffusion.m)
