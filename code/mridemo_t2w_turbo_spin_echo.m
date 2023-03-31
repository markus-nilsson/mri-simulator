function mridemo_t2w_turbo_spin_echo(do_export_gif)

if (nargin < 1), do_export_gif = 0; end

% Define timline
T_sim = 0.4;

my_timeline = timeline(T_sim);


% Define pulse sequence

rfs = {...
    rf('y', 90,  15e-3, 5e-3), ...
    rf('x', 180, 110e-3 - 2.5e-3, 5e-3), ...
    rf('x', 180, 220e-3 - 2.5e-3, 5e-3), ...
    rf('x', 180, 260e-3 - 2.5e-3, 5e-3), ...
    rf('x', 180, 300e-3 - 2.5e-3, 5e-3), ...
    rf('x', 180, 340e-3 - 2.5e-3, 5e-3), ...
    };

o = -2.5e-3; % need this to counter assymetry, why?

acqs = { ...
    acq( o + (200) * 1e-3 - 5e-3 , 10e-3), ...
    acq( o + (240) * 1e-3 - 5e-3 , 10e-3), ...
    acq( o + (280) * 1e-3 - 5e-3 , 10e-3), ...
    acq( o + (320) * 1e-3 - 5e-3 , 10e-3), ...
    acq( o + (360) * 1e-3 - 5e-3 , 10e-3), ...
    };

grads = {};

my_pulse_seq = pulse_sequence(rfs, grads, acqs, my_timeline);


% Setup spin system 
t1_list = [inf inf];
t2_list = [0.5 0.2];

m0_list = [1 1];

n_arrow = 7;

b0_fun = @(n) linspace(-1, 1, n)' * 0.9;


% Setup plot functions
l_str = {'Long T2', 'Short T2'};
my_plot_engine = mrisim_plot_engine(l_str);
my_plot_engine.n_mod = 20;
my_plot_engine.do_export_gif = do_export_gif;


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

    my_mri_sim.do_stop_b0_rotation_during_rf = 1;

    % Run simulation
    my_mri_sim.simulate(my_plot_engine);

end













        