classdef rf < handle
    
    properties
        alpha {mustBeNumeric}
        alpha_internal {mustBeNumeric}
        alpha_left {mustBeNumeric}
        t_start {mustBeNumeric}
        t_end {mustBeNumeric}
        t_dur {mustBeNumeric}
        waveform
        Mf     
        foff;
        timeline = [];
        phase = 0;
        full_waveform = [];
    end

    methods

        function obj = rf(orient, alpha, t_start, t_dur, waveform, foff, varargin)

            if (nargin < 5), waveform = []; end
            if (nargin < 6), foff = 0; end
            
            obj.Mf = @(alpha) my_rotx(alpha);

            switch (orient)
                case 'x'
                    1; % standard pulse

                case 'y'
                    obj.phase = pi/2;
                    obj.foff = 0;

                case 'spoil'
                    alpha = 1;
                    f = @(x) exp(-x * 4 * 180 / pi);
                    obj.Mf = @(alpha) [f(alpha) 0 0; 0 f(alpha) 0; 0 0 1];

                case 'offresonance'
                    1; % regulated by foff

            end

            obj.alpha = alpha;
            obj.foff = foff;

            obj.t_start = t_start;
            obj.t_dur   = t_dur;
            obj.t_end   = t_start + t_dur;

            obj.waveform = waveform;

        end

        function update(obj, spin_system)

            current_alpha = obj.full_waveform( obj.timeline.c_t );

            if (current_alpha ~= 0)

                % rotate about z
                Mzp = my_rotz(+obj.theta());
                Mzm = my_rotz(-obj.theta());

                spin_system.m = spin_system.m * ...
                    Mzp * obj.Mf(current_alpha / 180 * pi) * Mzm;
            end

        end

        function obj = init(obj)

            if (isempty(obj.timeline)), error('timeline must be set'); end

            if (isempty(obj.waveform)) % build a hard rf pulse
                
                tmp = ...
                    (obj.timeline.t_list >= obj.t_start) & ...
                    (obj.timeline.t_list <= obj.t_end);

            else % use a custom waveform

                c_start = floor(obj.t_start / obj.timeline.dt);

                tmp = zeros(size(obj.timeline.t_list));

                tmp( (1:numel(obj.waveform)) + c_start ) = obj.waveform;

            end

            tmp = tmp / sum(tmp) * obj.alpha;

            obj.full_waveform = tmp;

        end

        function state = is_active(obj)
            state = ...
                (obj.timeline.t >= obj.t_start) && ...
                (obj.timeline.t <= obj.t_end);
        end

        function th = theta(obj)
            th = obj.phase + obj.timeline.t * obj.foff; 
        end
        
    end

end
