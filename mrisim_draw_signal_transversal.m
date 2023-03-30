classdef mrisim_draw_signal_transversal < mrisim_draw

    properties
        h_plot = [];
        h_acq = [];

        n_list = []; 
        c_list = []; 

        plot_col = [];
        l_str = {};
        l_loc = 'NorthEast';
    end

    methods

        function obj = mrisim_draw_signal_transversal(h, l_str, l_loc)
            
            obj@mrisim_draw(h);
            obj.n_list = numel(l_str);
            obj.l_str = l_str;
            
            if (nargin > 2)
                obj.l_loc = l_loc;
            end

            obj.plot_col = gray(obj.n_list + 1);

        end


        function obj = init(obj, mr_sim)
        
            init@mrisim_draw(obj, mr_sim);
            
            obj.c_list = mr_sim.spin_sys.c_system;

            % Focus on the current plot
            set(gcf, 'currentaxes', obj.h);

            % Shows 
            if (isempty(obj.h_plot))

                for c_tmp = 1:obj.n_list
                    
                    obj.h_plot(c_tmp) = plot(-1, 0, 'k', ...
                        'color', obj.plot_col(c_tmp,:)); hold on;
                end
            
            end

            % Shows time of acquisition
            obj.h_acq = plot(-1, 0, 'r.', 'linewidth', 2, 'MarkerSize', 12);

            if (~isempty(obj.l_str)) && (~isempty(obj.l_str{1}))
                h_leg = legend(obj.l_str(1:obj.c_list), 'Location', obj.l_loc);
                h_leg.EdgeColor = [1 1 1];
                h_leg.Color = [1 1 1 1];
                h_leg.Box = 'off';
                
            end

            % Options
            xlim(obj.h, [0 max(mr_sim.pulse_seq.timeline.t_max)]);
            ylim(obj.h, [0 1]);

            set(obj.h, 'ytick', [0 0.5 1]);


            set(obj.h,'FontSize', 15);
            set(obj.h,'xticklabel', {});
            set(obj.h, 'tickdir', 'out');

            box off;

            title(obj.h, {'Transverse magnetisation', ''});
            
            

        end

        function update(obj, mr_sim)

            update@mrisim_draw(obj, mr_sim);

            % Make objects easily accessible
            p = mr_sim.pulse_seq;
            t = p.timeline.t_list;
            

            % Set time frame 
            ind = 1:mr_sim.pulse_seq.timeline.c_t;
            
            % Update plot
            set(obj.h_plot(obj.c_list), ...
                'XData', t(ind), ...
                'YData', mr_sim.m_abs(ind));

            % Indicate time of acquisition
            acq_ind = t > inf;
            for c_acq = 1:numel(p.acq)
                acq_ind = acq_ind + p.acq{c_acq}.open_ind();
            end
            acq_ind = acq_ind & (t <= p.timeline.t);

            set(obj.h_acq, 'XData', t(acq_ind), 'YData', mr_sim.m_abs(acq_ind));


        end
    end
end







