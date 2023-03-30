
% Define timline
T_sim = 0.6;

my_timeline = timeline(T_sim);

% Define pulse sequence

rfs = {...
    rf('y', 180,  20e-3, 4e-3), ...
    rf('spoil', 0, 26e-3, 2e-3), ...
    rf('y', -90,  200e-3, 10e-3), ...
    rf('x', 180, 300e-3 , 5e-3), ...
    rf('x', 180, 420e-3 - 2.5e-3, 5e-3), ...
    rf('x', 180, 460e-3 - 2.5e-3, 5e-3), ...
    rf('x', 180, 500e-3 - 2.5e-3, 5e-3), ...
    rf('x', 180, 540e-3 - 2.5e-3, 5e-3), ...
    };

acqs = { ...
    acq( (400) * 1e-3 - 6e-3, 10e-3), ...
    acq( (440) * 1e-3 - 6e-3, 10e-3), ...
    acq( (480) * 1e-3 - 6e-3, 10e-3), ...
    acq( (520) * 1e-3 - 6e-3, 10e-3), ...
    acq( (560) * 1e-3 - 6e-3, 10e-3), ...
    };

grads = {};

my_pulse_seq = pulse_sequence(rfs, grads, acqs, my_timeline);


% Setup spin system 
t1_list = [2 0.6];
t2_list = [0.5 0.25];

m0_list = [0.9 0.9];

n_arrow = 7;

b0_fun = @(n) linspace(-1, 1, n_arrow)' * 0.6;


% Setup plot functions
l_str = {'Long T1', 'Short T1'};
my_plot_engine = mrisim_plot_engine(l_str);
my_plot_engine.plot_timeline.do_extend_rf_plot = 1;
my_plot_engine.n_mod = 30;


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






