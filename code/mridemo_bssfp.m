function mridemo_bssfp(do_export_gif)

if (nargin < 1), do_export_gif = 0; end

% Define timline
T_sim = 0.9;

my_timeline = timeline(T_sim, 0.5e-4);


% Define pulse sequence

alpha = 80;

acqs = {};
rfs = {};
tr = 10e-3;
for c = 1:80
    s = mod(c,2)*2-1;

    if (c == 1)
        rfs{end+1} = rf('x', alpha/2,  tr * (c-1), 3e-3);
    else
        rfs{end+1} = rf('x', s * alpha,  tr * (c-1), 3e-3);
    end

    if (c > 5)
        acqs{end+1} = acq( 5e-3 + tr * (c-1), 4e-3);
    end
end

grads = {};

my_pulse_seq = pulse_sequence(rfs, grads, acqs, my_timeline);


% Setup spin system and run the simulation!
t1_list = 1000 * 1e-3;
t2_list = 50 * 1e-3;

m0_list = 1;

n_arrow = 21 * 11 + 1;

b0_fun = @(n) linspace(-1, 1, n)' * 22;


% Setup plot functions
my_plot_engine = mrisim_plot_engine({},3);
my_plot_engine.n_mod = 16;

my_plot_engine.plot_vectors.do_draw_circle = 0;
my_plot_engine.plot_vectors.sc = 2.2;

my_plot_engine.do_export_gif = do_export_gif;



for c = 1:1

    % Set up and init spin system
    my_spin_system = spin_system(...
        m0_list(c), ...
        t1_list(c), ...
        t2_list(c), ...
        b0_fun, ...
        n_arrow);

    my_spin_system.r_init = @(n) cat(2, ...
        zeros(n, 1), linspace(-1.5, 1.5, n)', zeros(n, 1));

    my_spin_system.vis_ind = 1:11:n_arrow;

    my_spin_system.do_normalize = 1; % cheating for better visualization
      
    % Setup the simulator
    my_mri_sim = mrisim(...
        my_pulse_seq, ...
        my_spin_system);

    my_mri_sim.do_stop_b0_rotation_during_rf = 1;

    % Run simulation
    my_mri_sim.simulate(my_plot_engine);

end






