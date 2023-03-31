
% Loop through all cases and make the demos
for c_demo = 1:13
    switch (c_demo)
        case 1
            mridemo_90pulse(1);
        case 2
            mridemo_bssfp(1);
        case 3
            mridemo_t1w_principle(1);
        case 4
            mridemo_t2w_spin_echo(1);
        case 5 
            mridemo_t2w_turbo_spin_echo(1);
        case 6
            mridemo_t2star_weighted(1);
        case 7
            mridemo_fat_and_water(1);
        case 8
            mridemo_flair(1);
        case 9
            mridemo_diffusion(1);
        case 10
            mridemo_t1w_spoiled_gre(1, 1);
        case 11
            mridemo_pd(1);
        case 12
            mridemo_pd_with_rotation(1);
        case 13
            mridemo_slice_selection(1);


    end
end