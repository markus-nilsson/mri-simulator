function mridemo_90pulse(do_export_gif)

if (nargin < 1), do_export_gif = 0; end

% Define timline
T_sim = 0.1;

my_timeline = timeline(T_sim);


% Define pulse sequence

rfs = {...
    rf('offresonance', 90,  5e-3, 50e-3, [], 5 * mrisim_gamma())};

acqs = {};
grads = {};

my_pulse_seq = pulse_sequence(rfs, grads, acqs, my_timeline);


% Setup spin system and run the simulation!
t1_list = [inf inf] * 1e-3;
t2_list = [inf inf] * 1e-3;

m0_list = [0.99 0.99];

n_arrow = 1;

b0_offset_list = [5 50];

b0_fun = @(c) (@(n) b0_offset_list(c) * ones(n, 1));


% Setup plot functions
l_str = {'On resonance', 'Off resonance'};
my_plot_engine = mrisim_plot_engine(l_str, 2);
my_plot_engine.n_mod = 6;
my_plot_engine.plot_vectors.do_draw_rf_pulse = 1;
my_plot_engine.do_export_gif = do_export_gif;


for c = 1:2

    % Set up and init spin system
    my_spin_system = spin_system(...
        m0_list(c), ...
        t1_list(c), ...
        t2_list(c), ...
        b0_fun(c), ...
        n_arrow);

    % Set the identity of the system to control plotting
    my_spin_system.c_system = c;

    % Setup the simulator
    my_mri_sim = mrisim(...
        my_pulse_seq, ...
        my_spin_system);

    % Run simulation
    my_mri_sim.simulate(my_plot_engine);

end


