
% Define timline
T_sim = 0.038;

my_timeline = timeline(T_sim);


% Define pulse sequence

rfs = {rf('y', 90,  2e-3, 5e-3)};

acqs = {...
    acq(16.6e-3 - 1.2e-3, 4e-3) ...
    acq(27.1e-3 - 1.2e-3, 4e-3) ...
    };

grads = {};

my_pulse_seq = pulse_sequence(rfs, grads, acqs, my_timeline);


% Setup spin system and run the simulation!
t1_list = inf;
t2_list = inf;

m0_list = 0.75;

n_arrow = 2;

b0_fun = @(n) [0 10]';


% Setup plot functions
l_str = {'Fat and water'};
my_plot_engine = mrisim_plot_engine(l_str, 2);
my_plot_engine.n_mod = 5;

for c = 1:1

    % Set up and init spin system
    my_spin_system = spin_system(...
        m0_list(c), ...
        t1_list(c), ...
        t2_list(c), ...
        b0_fun, ...
        n_arrow);

    % Set the identity of the system to control plotting
    my_spin_system.c_system = c;

    % Setup the simulator
    my_mri_sim = mrisim(...
        my_pulse_seq, ...
        my_spin_system);

    my_mri_sim.do_stop_b0_rotation_during_rf = 1;

    % Run simulation
    my_mri_sim.simulate(my_plot_engine);

end

