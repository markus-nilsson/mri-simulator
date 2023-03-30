classdef spin_system < handle

    properties

        c_system = 1; % identity of this spin system

        m0 = 1;
        t1 = inf;
        t2 = inf;
       
        b0;
        omega;
        m;
        r;

        r_init = @(n) zeros(n, 3);

        dr = @(dt) 0; % diffusion step

        b0_gen_fun = @(n) zeros(n, 1);

        do_stop_b0_rotation = 0;

        n = 1;

        is_initialized = 0;

        vis_ind = 1;

    end

    methods

        function obj = spin_system(m0, t1, t2, b0_gen_fun, n)

            obj.m0 = m0;
            obj.t1 = t1;
            obj.t2 = t2;
            obj.b0_gen_fun = b0_gen_fun;

            obj.n = n;

            obj.vis_ind = 1:n;

        end

        function obj = init(obj)

            n = obj.n;

            obj.m0 = [0 0 obj.m0];
            obj.m = repmat(obj.m0, n, 1); % all point in z direction
            obj.b0 = obj.b0_gen_fun(n);     

            obj.r = obj.r_init(n);

            obj.omega = obj.b0 * mrisim_gamma();

            % Make random events deterministic
            rng(2);
            
            obj.is_initialized = 1;

        end

        function z = z(obj) % return a correctly sizes set of zeros
            z = zeros(size(obj.omega)); 
        end


        function obj = bloch_evolution(obj, omega, dt, t1, t2)

            if (nargin < 4), t1 = obj.t1; end
            if (nargin < 5), t2 = obj.t2; end

            % Relaxation
            dm = zeros(size(obj.m));
            dm(:,1) = -dt./t2 .* obj.m(:,1);
            dm(:,2) = -dt./t2 .* obj.m(:,2);
            dm(:,3) = -dt./t1 .* (obj.m(:,3) - obj.m0(:,3));

            % Rotation around b0
            do = dt * omega;

            dm2 = dm;
            dm2(:,1) = (cos(do)-1) .* obj.m(:,1) - sin(do) .* obj.m(:,2);
            dm2(:,2) = (cos(do)-1) .* obj.m(:,2) + sin(do) .* obj.m(:,1);

            % Increment
            obj.m = obj.m + dm + dm2;

        end

        function obj = update(obj, dt)

            assert(obj.is_initialized, 'Run init(n) first');

            % bloch simulator
            if (obj.do_stop_b0_rotation)
                tmp = obj.z();
            else
                tmp = obj.omega;
            end

            % Relaxation and evolution around b0
            bloch_evolution(obj, tmp, dt);

            % Do diffusion
            this_dr = obj.dr(dt);

            obj.r = obj.r + this_dr;

        end

    end

end
