function mridemo_t2star_weighted(do_export_gif)

if (nargin < 1), do_export_gif = 0; end

% Define timline
T_sim = 0.09;

my_timeline = timeline(T_sim);


% Define pulse sequence

rfs = {rf('y', 90,  2e-3, 10e-3)};
acqs = {acq(45e-3, 10e-3)};
grads = {};


my_pulse_seq = pulse_sequence(rfs, grads, acqs, my_timeline);


% Setup spin system and run the simulation!
t1_list = inf;
t2_list = inf;

m0_list = 0.99;

n_arrow = 11;

b0_spread_list = [0.65 1.0];
b0_fun = @(c)(@(n) (linspace(-1,1,n)' * b0_spread_list(c)));

b0_fun = @(c)(@(n) (norminv(linspace(0.1, 0.9, n)', 0, b0_spread_list(c))));


% Setup plot functions
l_str = {'Long T2*', 'Short T2*'};
my_plot_engine = mrisim_plot_engine(l_str);
my_plot_engine.plot_timeline.do_extend_rf_plot = 1;
my_plot_engine.do_export_gif = do_export_gif; 

for c = 1:2

    % Set up and init spin system
    my_spin_system = spin_system(...
        m0_list, ...
        t1_list, ...
        t2_list, ...
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






