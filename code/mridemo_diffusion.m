function mridemo_diffusion(do_export_gif)

if (nargin < 1), do_export_gif = 0; end

% Define timline
T_sim = 0.2;

my_timeline = timeline(T_sim);


% Define pulse sequence

rfs = {...
    rf('y', 90,  10e-3 - 2.5e-3, 5e-3), ...
    rf('x', 180, 100e-3 - 2.5e-3, 5e-3)};

gmax = 0.2 * 6;

grads = {...
    grad('y', 025e-3, 55e-3, gmax ), ...
    grad('y', 115e-3, 55e-3, gmax )  };

acqs = {acq( 190e-3 - 10e-3, 15e-3) };

my_pulse_seq = pulse_sequence(rfs, grads, acqs, my_timeline);


% Setup spin system and run the simulation!
t1 = inf;
t2 = inf;

m0 = 0.99;

n = 1e5;

b0_fun = @(n) zeros(n, 1);


demean = @(r) r - mean(r,1);

r_init = @(n) demean(cat(2, ...
    zeros(n, 1), ...
    norminv(linspace(0.0001, 0.9999, n)', 0, 1.1), ...
    zeros(n,1)));

dr = @(dt) cat(2, ...
    zeros(n,1), ...
    randn(n,1) * dt * 60, ...
    zeros(n,1));

dr_list = {@(dt) 0, dr};

% Setup plot functions
l_str = {'No diffusion', 'Diffusion'};
my_plot_engine = mrisim_plot_engine(l_str);
my_plot_engine.plot_vectors.do_draw_circle = 0;
my_plot_engine.plot_vectors.sc = 1.9;
my_plot_engine.plot_vectors.campos = [-8 -12.4 6];
my_plot_engine.plot_signal.l_loc = 'SouthEast';
my_plot_engine.do_export_gif = do_export_gif;

for c = 1:2

    % Set up and init spin system
    my_spin_system = spin_system(...
        m0, ...
        t1, ...
        t2, ...
        b0_fun, ...
        n);

    my_spin_system.r_init = r_init;
    my_spin_system.dr = dr_list{c};
    my_spin_system.vis_ind = round(linspace(0.2*n, 0.8*n, 21));

    % Set the identity of the system to control plotting
    my_spin_system.c_system = c;

    % Setup the simulator
    my_mri_sim = mrisim(...
        my_pulse_seq, ...
        my_spin_system);

    % Run simulation
    my_mri_sim.simulate(my_plot_engine);

end



