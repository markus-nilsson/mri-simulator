classdef timeline < handle

    properties (SetAccess = protected)

        c_t = 1;
        t_max = 1; % seconds
        dt = 1e-4;

        t_list = [];

    end

    properties (Dependent)
        t
        n_t;
    end

    methods

        function obj = timeline(t_max, dt)

            if (nargin >= 1), obj.t_max = t_max; end
            if (nargin >= 2), obj.dt = dt; end

            obj.c_t = 1;

            obj.t_list = ((1:obj.n_t)-1) * obj.dt;
            
        end

        function obj = init(obj)
            obj.c_t = 1;
        end

        function obj = update(obj)

            obj.c_t = obj.c_t + 1;

            if (obj.t > (obj.t_max + obj.dt))
                error('time is running out');
            end

        end

        function b = is_finished(obj)
            b = obj.t >= obj.t_max; 
        end


        function t = get.t(obj)
            t = obj.c_t * obj.dt;
        end

        function n_t = get.n_t(obj)
            n_t = ceil(obj.t_max / obj.dt);
        end

    end
end
