# Inversion recovery: FLAIR

![Inversion recovery](../gif/mridemo_flair.gif)

The pulse sequence starts with a 180&deg; pulse and is followed by an silent period with a given inversion time. After this time the imaging experiment
is started - in this case a [turbo spin echo](t2w_turbo_spin_echo.md). By adjusting the inversion time, we can null the signal from tissues with 
a specific T1-relaxation time. This is often used to null the signal from fat or water. The latter is referred to as a 
fluid attenuated inversion recovery (FLAIR) sequence.


[Code for this illustration can be found here](../code/mridemo_flair.m)
