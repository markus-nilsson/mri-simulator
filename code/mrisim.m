classdef mrisim < handle

    properties

        % observables
        m_abs = [];
        m_x;
        m_y;
        m_z;
        m_t;

        do_observe_during_rf = 1;
        do_stop_b0_rotation_during_rf = 0;

        pulse_seq;
        spin_sys;

    end   

    methods

        function obj = mrisim(pulse_seq, spin_sys)

            % Link
            obj.pulse_seq = pulse_seq;
            obj.spin_sys = spin_sys;

            % Init observation parameters
            n_t = obj.pulse_seq.timeline.n_t;

            obj.m_abs = zeros(n_t, 1) + NaN;
            obj.m_x   = zeros(n_t, 1) + NaN;
            obj.m_y   = zeros(n_t, 1) + NaN;
            obj.m_z   = zeros(n_t, 1) + NaN;
            obj.m_t   = zeros(n_t, 3) + NaN;

            % Init spin system
            obj.spin_sys.init();

            % Init pulse sequence
            obj.pulse_seq.init();

        end

        function obj = update(obj)
            
            % The pulse sequence keeps track of the time
            c_t = obj.pulse_seq.timeline.c_t; 
            
            % -- compute mx my mz et c
            if (obj.do_observe_during_rf) || (~obj.pulse_seq.is_rf_active())

                obj.m_abs(c_t) = sqrt(sum(mean(obj.spin_sys.m(:, 1:2),1).^2));
                obj.m_x(c_t) = mean(obj.spin_sys.m(:,1));
                obj.m_y(c_t) = mean(obj.spin_sys.m(:,2));
                obj.m_z(c_t) = mean(obj.spin_sys.m(:,3));

            elseif (c_t >= 2)

                % use to avoid some annoying plotting during rf pulses
                obj.m_abs(c_t)  = obj.m_abs(c_t-1);
                obj.m_x(c_t)    = obj.m_x(c_t-1);
                obj.m_y(c_t)    = obj.m_y(c_t-1);
                obj.m_z(c_t)    = obj.m_z(c_t-1);

            else

                obj.m_abs(c_t)  = 0;
                obj.m_x(c_t)    = 0;
                obj.m_y(c_t)    = 0;
                obj.m_z(c_t)    = 0;

            end

            obj.m_t(c_t,:) = mean(obj.spin_sys.m(:,:),1);

        end

        function simulate(obj, plot_engine)

            % Init plots
            plot_engine.init(obj); 
            
            while (~obj.pulse_seq.timeline.is_finished())

                % Effect of pulse sequence
                obj.pulse_seq.update(obj.spin_sys);

                % Update spin system, including effects of pulse sequence
                obj.spin_sys.do_stop_b0_rotation = ...
                    obj.pulse_seq.is_rf_active() && ...
                    obj.do_stop_b0_rotation_during_rf;

                obj.spin_sys.update(obj.pulse_seq.timeline.dt);

                % Update observables
                obj = update(obj);

                % Update plots
                plot_engine.update(obj);

                % Update the time of the pulse sequence
                obj.pulse_seq.timeline.update();

            end

        end

    end

end