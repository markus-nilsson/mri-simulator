function mridemo_slice_selection(do_export_gif)

if (nargin < 1), do_export_gif = 0; end

% Define timline
T_sim = 0.2;

my_timeline = timeline(T_sim, 0.5e-4);


% Define pulse sequence

t = 0:my_timeline.dt:90e-3;
t = t - mean(t);
w = exp(-abs(t) / 1e-3);
my_sinc = @(t) ...
    (1 - t.^2 / 6) .* w + ...
    (sin(t) ./ (eps + sign(t).*max(abs(t), 1e-5))) .* (1-w);

rf_waveform = my_sinc(6 * pi * t / max(t));
rf_waveform(end) = 0;

gm = 3.6;

grads = {...
    grad('y', 10e-3, 90e-3, gm), ...
    grad('y', 110e-3, 45e-3, -gm )  };

rfs = { rf('y', 91,  10e-3, 90e-3, rf_waveform) };

acqs = {};


my_pulse_seq = pulse_sequence(rfs, grads, acqs, my_timeline);


% Setup spin system and run the simulation!
t1_list = inf * 1e-3;
t2_list = inf * 1e-3;

m0_list = [0.9 0.3];

n_arrow = 21;

b0_fun = @(n) zeros(n, 1);


% Setup plot functions
my_plot_engine = mrisim_plot_engine({},4);
my_plot_engine.n_mod = 20;

my_plot_engine.plot_vectors.do_draw_circle = 0;
my_plot_engine.plot_vectors.sc = 2.7;

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
        zeros(n, 1), linspace(-2.5, 2.5, n)', zeros(n, 1));
    
    
    % Set the identity of the system to control plotting
    my_spin_system.c_system = c;

    % Setup the simulator
    my_mri_sim = mrisim(...
        my_pulse_seq, ...
        my_spin_system);

    % Run simulation
    my_mri_sim.simulate(my_plot_engine);

end




