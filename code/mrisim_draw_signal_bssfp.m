classdef mrisim_draw_signal_bssfp < mrisim_draw

    properties
        h_plot = [];

        mtr_cache = [];
    end

    methods

        function obj = mrisim_draw_signal_bssfp(h)
            obj@mrisim_draw(h);
        end
        

        function init(obj, mr_sim)
            init@mrisim_draw(obj, mr_sim);

            x = mr_sim.spin_sys.omega;
            y = zeros(size(x));
            obj.h_plot = plot(x, y, 'k');


            set(gca,'ytick', [], 'xtick', []);
            xlabel('Offresonance frequency [Hz]');
            ylabel('Signal');
            title({'Transverse magntization', '', ''});

            set(gca,'FontSize', 14);
            set(gca,'xticklabel', {});
            set(gca, 'tickdir', 'out');

            box off;

        end

        function update(obj, mr_sim)

            update@mrisim_draw(obj, mr_sim);

            s = mr_sim.spin_sys;

            % compute transversal magnetizations
            mtr = sqrt(sum(s.m(:, 1:2).^2,2));

            % this is just to smooth the visualization
            if (isempty(obj.mtr_cache))
                obj.mtr_cache = mtr;
            else
                obj.mtr_cache = obj.mtr_cache / 2 + mtr / 2;
            end

            set(obj.h_plot, 'XData', s.omega, 'YData', obj.mtr_cache);

            ylim(obj.h, [0 1]);

        end
    end
end



