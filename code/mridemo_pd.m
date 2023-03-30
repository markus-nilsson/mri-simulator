function demo_pd()

% Define timline
T_sim = 0.6;

my_timeline = timeline(T_sim);


% Define pulse sequence

rfs = {...
    rf('y', 90,  105e-3, 5e-3), ...
    rf('y', 90,  305e-3, 5e-3), ...
    rf('y', 90,  505e-3, 5e-3)};

grads = {};

acqs = {...
    acq( 111e-3, 5e-3), ...
    acq( 311e-3, 5e-3), ...
    acq( 511e-3, 5e-3), ...
    };

my_pulse_seq = pulse_sequence(rfs, grads, acqs, my_timeline);


% Setup spin system and run the simulation!
t1_list = [100 100] * 1e-3;
t2_list = [40 40] * 1e-3;

m0_list = [0.9 0.3];

n_arrow = 1;

b0_fun = @(n) zeros(n, 1);


% Setup plot functions
l_str = {'High PD', 'Low PD'};
my_plot_engine = mrisim_plot_engine(l_str);
my_plot_engine.plot_timeline.do_extend_rf_plot = 1;


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
