classdef mrisim_draw_signal_trans_and_xy < mrisim_draw

    properties
    end

    methods

        function obj = mrisim_draw_signal_trans_and_xy(h)
            obj@mrisim_draw(h);
        end

        function update(obj, spin_sys, pulse_seq)

            update@mrisim_draw(obj, spin_sys, pulse_seq);

            ind = 1:pulse_seq.c_t;

            cla(obj.h);
            plot(pulse_seq.time_axis(ind), spin_sys.m_x(ind),'r'); hold on;
            plot(pulse_seq.time_axis(ind), spin_sys.m_y(ind),'b');
            plot(pulse_seq.time_axis(ind), spin_sys.m_abs(ind),'k');

            % Plot options
            xlim([0 max(pulse_seq.time_axis)]);
            ylim([-1.1 1.1]);
            set(gca, 'ytick', [-1 0 1]);

            title('Transverse magnetisation', 'fontsize', 15);

            set(gca,'FontSize', 14);
            set(gca,'xticklabel', {});
            set(gca, 'tickdir', 'out');

            box off;

        end
    end
end