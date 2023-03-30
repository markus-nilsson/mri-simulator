classdef mrisim_plot_engine < handle

    properties

        plot_vectors = mrisim_draw([]);
        plot_signal  = mrisim_draw([]);
        plot_timeline = mrisim_draw([]);

        n_mod = 10;

        is_initalized = 0;
        
    end

    methods

        function obj = mrisim_plot_engine(l_str, c_plot_mode)

            if (nargin < 1), l_str = {}; end
            if (nargin < 2), c_plot_mode = 1; end

            switch (c_plot_mode)
                
                case 1 % all three plots

                    p = [...
                        +0.49 0.00 0.48 1.00; 
                        +0.08 0.60 0.35 0.30;
                        +0.08 0.15 0.35 0.30];

                    obj.plot_vectors  = mrisim_draw_m_vectors(p(1,:));
                    obj.plot_signal   = mrisim_draw_signal_transversal(p(2,:), l_str);
                    obj.plot_timeline = mrisim_draw_timeline(p(3,:));
                
                case 2 % vectors and signal only

                    p = [...
                        -0.05 0.00 0.75 1.00;
                        +0.60 0.25 0.35 0.50];
                    
                    obj.plot_vectors  = mrisim_draw_m_vectors(p(1,:));
                    obj.plot_signal   = mrisim_draw_signal_transversal(p(2,:), l_str);
                
                
                case 3 % bssfp plot

                    p = [...
                        -0.05 0.00 0.75 1.0;
                        +0.60 0.25 0.35 0.45
                        ];

                    obj.plot_vectors  = mrisim_draw_m_vectors(p(1,:));
                    obj.plot_signal   = mrisim_draw_signal_bssfp(p(2,:));

                case 4 % vectors and timeline only

                    p = [...
                        -0.05 0.00 0.75 1.00;
                        +0.60 0.25 0.35 0.50];
                    
                    obj.plot_vectors  = mrisim_draw_m_vectors(p(1,:));
                    obj.plot_signal   = mrisim_draw_timeline(p(2,:));
               
            end

        end

        function obj = init(obj, mr_sim)

            % this is where the axes will be created
            if (~obj.is_initalized)
                clf;

                set(gcf, ...
                    'color','white', ...
                    'defaultlinelinewidth', 2, ...
                    'defaultaxeslinewidth', 2, ...
                    'defaultaxesfontweight', 'bold', ...
                    'defaultaxestickdir', 'out', ...
                    'defaultaxesbox', 'off');

                obj.is_initalized = 1;
            end

            obj.plot_vectors.init(mr_sim);
            obj.plot_signal.init(mr_sim);
            obj.plot_timeline.init(mr_sim);

        end

        
        function obj = update(obj, mr_sim)

            if (mod(mr_sim.pulse_seq.timeline.c_t - 1, obj.n_mod) == 0)

                obj.plot_vectors.update(mr_sim);
                obj.plot_signal.update(mr_sim);
                obj.plot_timeline.update(mr_sim);

                pause(0.01); % draw
            end

        end

    end
end