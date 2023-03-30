classdef grad < handle

    properties
        gamp {mustBeNumeric}
        t_start {mustBeNumeric}
        t_end {mustBeNumeric}
        t_dur {mustBeNumeric}
        impulse_left {mustBeNumeric}
        sign
        orient
        gamp_internal
        timeline = [];
        waveform;
        is_initialized = 0;
    end

    methods

        function obj = grad(orient, t_start, t_dur, gamp)
            
            obj.orient = orient;
            obj.t_start = t_start;
            obj.t_dur = t_dur;
            obj.t_end = t_start + t_dur;
            obj.gamp = gamp;

        end

        function obj = update(obj, spin_sys)

            if (obj.is_active())

                switch (obj.orient)
                    case 'x'
                        r = spin_sys.r(:,1);
                    case 'y'
                        r = spin_sys.r(:,2);
                    case 'z'
                        r = spin_sys.r(:,3);
                    otherwise 
                        error('not impemented');
                end

                omega = -1e2 * r * obj.waveform(obj.timeline.c_t);

                spin_sys.bloch_evolution(omega, obj.timeline.dt, inf, inf);

            end

        end

        function obj = init(obj)
            if isempty(obj.timeline), error('timeline must be set'); end

            obj.is_initialized = 1;

            tmp = ...
                (obj.timeline.t_list >= obj.t_start) & ...
                (obj.timeline.t_list < obj.t_end);

            tmp = tmp * obj.gamp;

            obj.waveform = tmp;

        end

        function state = is_active(obj)
            state = ...
                (obj.timeline.t >= obj.t_start) && ...
                (obj.timeline.t < obj.t_end);
        end
        
    end

end
