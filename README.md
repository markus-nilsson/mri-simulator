# MRI simulator of spin dynamcis
MRI simulator for educational purposes written in MATLAB

Run files names mridemo_*.m to visualize different MRI pulse sequences



![90-pulse on and off resonance](gif/mridemo_90pulse.gif "90 pulse on and off resonance")

Figure 1: Illustration of the effect of a 90&deg; pulse that is either on resonance or off resonance. In the on-resonance condition, the magnetic field making up the 90&deg; pulse (shown by a black arrow) rotates with the same frequency as the magnetization. In the off-resonance condition, the magnetization rotates faster than the 90&deg; pulse. This results in a slight tilt of the magnetization, but far from the 90&deg; flip in the on-resonance condition.

[The code for this figure can be found here](code/mridemo_90pulse.m)

## Illustrations of key principles
- [90&deg; pulse](md/90pulse.md)
- [Slice selection](md/slice_selection.md)

## Illustrations of basic contrast mechanisms
- [Proton density](md/pd.md)
- [T2* weighting](md/t2star.md)
- [T2-weighting](md/t2_spin_echo.md)
- [T1-weighting](md/t1w_principle.md)
- [Inversion recovery: FLAIR](md/flair.md)

## Illustration of advanced contrast mechanisms
- [Diffusion weighted imaging](md/dwi.md)
- [Fat and water](md/fat_and_water.md)

## Illustration of fast sequences
- [T1-weighted spoiled gradient echo](md/t1w_spoiled_gre.md)
- [Turbo spin echo](md/t2w_turbo_spin_echo.md)
- [Balanced steady-state free precession](md/bssfp.md)
