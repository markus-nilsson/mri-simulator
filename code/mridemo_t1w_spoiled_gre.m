function mridemo_t1w_spoiled_gre(do_spoiling, do_export_gif)

% General settings
if (nargin < 1), do_spoiling = 1; end
if (nargin < 2), do_export_gif = 0; end

% Define timline
T_sim = 0.46;
dt = 1e-5;

my_timeline = timeline(T_sim, dt);


% Define pulse sequence
alpha = 40;

rfs = {};
acqs = {};
tr = 19e-3;

for c = 1:24

    switch (do_spoiling) % select spoiling method

        case 0 % none
    
            rfs{end+1} = rf('y', alpha,  tr * (c-1), 5e-3);

            c_start = 4;

        case 1 % emulated gradient spoiling, although implemented in a
            % non physical way

            rfs{end+1} = rf('y', alpha,  tr * (c-1), 5e-3);
            rfs{end+1} = rf('spoil', 0,  12e-3 + tr * (c-1), 5e-3);

            c_start = 4;

        case 2 % rf spoiling

            this_rf = rf('y', alpha,  tr * (c-1), 5e-3);
            this_rf.phase = (c-1) * 117 / 180 * pi;

            rfs{end+1} = this_rf;

            c_start = 12;

        otherwise

            error('spoiling method not impleemnted')

    end

    if (c > c_start)
        acqs{end+1} = acq( 5e-3 + tr * (c-1), 5e-3);
    end
end

grads = {};


my_pulse_seq = pulse_sequence(rfs, grads, acqs, my_timeline);


% Setup spin system and run the simulation!
t1_list = [500 50] * 1e-3;
t2_list = [130 40] * 1e-3;

m0_list = [1 1];

n_arrow = 1;

b0_fun = @(n) zeros(n, 1);


% Setup plot functions
l_str = {'Long T1 and long T2', 'Short T1 and short T2'};

my_plot_engine = mrisim_plot_engine(l_str);

my_plot_engine.plot_timeline.do_extend_rf_plot = 1;
my_plot_engine.plot_timeline.do_plot_acq = 0;

my_plot_engine.n_mod = 400; % fewer observations
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

    % Run simulation
    my_mri_sim.simulate(my_plot_engine);

end



