classdef mrisim_draw_timeline < mrisim_draw

    properties

        h_time_marker = [];
        do_extend_rf_plot = 0;
        do_plot_acq = 1;

    end

    methods

        function obj = mrisim_draw_timeline(h)
            obj@mrisim_draw(h);
        end

        function obj = init(obj, mr_sim)

            if (obj.is_initialized), return; end

            init@mrisim_draw(obj, mr_sim);

            % Focus on the current plot
            set(gcf, 'currentaxes', obj.h);

            % Get shortnames
            t = mr_sim.pulse_seq.timeline.t_list;

            t_min = min(t);
            t_max = max(t);
            

            % Set the hold on
            plot([0 0], [0 0], 'k-'); hold on;

            ext_factor = max(1, max(t) / 0.6 * 3);


            % get maximal gradient amplitude
            gmax = -1;
            for c = 1:numel(mr_sim.pulse_seq.grad)
                gmax = max(gmax, abs(mr_sim.pulse_seq.grad{c}.gamp));
            end

            for c = 1:numel(mr_sim.pulse_seq.grad)

                o = mr_sim.pulse_seq.grad{c};

                tmp = linspace(0, o.t_dur, 100);

                y = [linspace(0,1,3) ones(1,94) linspace(1,0,3)] * o.gamp / gmax * 112;
                x = tmp + o.t_start;

                area( x, y, 'FaceColor', [0.4 0.4 0.4] + 0.4 );

            end

            % plot acquisitions
            if (obj.do_plot_acq)
                for c = 1:numel(mr_sim.pulse_seq.acq)

                    o = mr_sim.pulse_seq.acq{c};

                    tmp = linspace(0, o.t_dur, 100);

                    x = tmp + o.t_start;
                    y = 40 + zeros(size(x));

                    area(x, y, 'FaceColor', [0.8 0 0]);
                    area(x, -y, 'FaceColor', [0.8 0 0]);

                end
            end

            % plot rf waveform
            for c = 1:numel(mr_sim.pulse_seq.rf)

                o = mr_sim.pulse_seq.rf{c};

                if isempty(o.waveform)
                    tmp = linspace(0, o.t_dur, 100);
                    sinc = @(x) sin(x) ./ (x + eps);
                    y = sinc( (tmp / o.t_dur - 1/2) * pi * 6) * abs(o.alpha);
                else

                    tmp = linspace(0, o.t_dur, numel(o.waveform));
                    y = o.waveform;
                    y = y / max(y) * abs(o.alpha);
                end

                if (obj.do_extend_rf_plot)
                    tmp = linspace(-(ext_factor-1)*o.t_dur, ext_factor*o.t_dur, numel(tmp));
                    plot(tmp + o.t_start, y, 'k');
                else
                    plot(tmp + o.t_start, y, 'k')
                end

                t_min = min(t_min, min(tmp + o.t_start));
                t_max = max(t_max, max(tmp + o.t_start));

            end


            % x-axis
            plot([t_min t_max], [0 0], 'k-'); hold on;


            xlim([t_min t_max*1.01]);
            ylim([-15 189]);

            set(gca, ...
                'ytick', [-180:90:180], ...
                'tickdir', 'out', ...
                'xtick', [], ...
                'fontsize', 15, ...
                'xtick', round( 100 * [0 0.5 1] * max(t)) / 100, ...
                'ygrid', 'on');

            
            t_str = '';
           
            if (numel(mr_sim.pulse_seq.rf) > 0) && ...
                    (numel(mr_sim.pulse_seq.grad) > 0)
                t_str = 'RF pulses and gradients';
            elseif (numel(mr_sim.pulse_seq.rf) > 0)
                t_str = 'RF pulses';
            elseif (numel(mr_sim.pulse_seq.grad) > 0)
                t_str = 'Gradients';
            end

            title({t_str, ''});

            xlabel('Time [s]');

            box off;
            axis;


            obj.h_time_marker = plot(0, 0, 'ro');

        end

        function update(obj, mr_sim)

            update@mrisim_draw(obj, mr_sim);

            set(obj.h_time_marker, 'XData', mr_sim.pulse_seq.timeline.t, 'YData', 0);

        end
    end
end
