classdef acq < handle

    properties
        t_start {mustBeNumeric}
        t_dur {mustBeNumeric}
        t_end {mustBeNumeric}

        timeline = [];
        
    end

    methods

        function obj = acq(start, dur)
            
            obj.t_start = start;
            obj.t_dur = dur;

            obj.t_end = obj.t_start + dur;

        end

        function ind = open_ind(obj, t)
            if (nargin < 2), t = obj.timeline.t_list; end
            ind = (t >= obj.t_start) & (t <= obj.t_end);
        end

        function b = is_active(obj)
            b = (obj.timeline.t >= obj.t_start) & (obj.timeline.t <= obj.t_end);
        end


        function obj = init(obj)

            if (isempty(obj.timeline))
                error('timeline must be set before init');
            end

        end

    end

end
