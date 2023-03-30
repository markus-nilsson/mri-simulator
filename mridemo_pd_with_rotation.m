
% Define timline
T_sim = 0.1;

my_timeline = timeline(T_sim);


% Define pulse sequence
rfs = {rf('y', 90,  20e-3, 10e-3)};

acqs = {...
    acq( 35e-3, 20e-3)};

grads = {};

my_pulse_seq = pulse_sequence(rfs, grads, acqs, my_timeline);


% Setup spin system and run the simulation!
t1_list = [inf inf] * 1e-3;
t2_list = [inf inf] * 1e-3;

m0_list = [0.99 0.5];

n_arrow = 1;

b0_fun = @(n) ones(n, 1);

% Setup plot functions
l_str = {'High PD', 'Low PD'};
my_plot_engine = mrisim_plot_engine(l_str,2);


for c = 1:2

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

    % Run simulation
    my_mri_sim.simulate(my_plot_engine);

end

