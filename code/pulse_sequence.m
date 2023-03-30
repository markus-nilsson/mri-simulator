classdef pulse_sequence < handle

    properties

        rf = {};
        grad = {};
        acq = {};

        timeline = [];

        t_max = [];

    end

    methods

        function obj = pulse_sequence(rfs, grads, acqs, timeline)

            obj.rf = rfs;
            obj.grad = grads;
            obj.acq = acqs;

            obj.timeline = timeline;

            % make sure all included components have access to the same
            % timeline - it is derived from handle so updates are universal
            function set_all(x)
                for c = 1:numel(x)
                    x{c}.timeline = timeline;
                end
            end
            set_all(obj.rf);
            set_all(obj.grad);
            set_all(obj.acq);

        end


        function obj = init(obj)
            
            % initialize/reset rf objects
            function init_all(x)
                for c = 1:numel(x)
                    x{c}.init();
                end
            end

            init_all(obj.rf);
            init_all(obj.grad);
            init_all(obj.acq);
    
            obj.timeline.init();
            
        end

        function obj = update(obj, spin_sys)  

            function update_all(x)
                for c = 1:numel(x)
                    x{c}.update(spin_sys);
                end
            end
            
            update_all(obj.grad);
            update_all(obj.rf);

        end

        function b = is_rf_active(obj)


            b = 0;
            for c = 1:numel(obj.rf)
                b = b | obj.rf{c}.is_active();
            end

        end

    end

end
