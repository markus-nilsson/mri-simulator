classdef mrisim_draw < handle

    properties

        h = []; % handle to axes

        is_initialized = 0;

        pos = [];

    end

    methods

        function obj = mrisim_draw(pos)

            if (nargin < 1), return; end

            obj.pos = pos;
        end

        function obj = init(obj, ~)
            
            if (~obj.is_initialized)

                if (isempty(obj.h)) && (~isempty(obj.pos))
                    obj.h = axes('position', obj.pos);
                end

                if (isempty(obj.h))
                    return;
                end

                cla(obj.h);
                obj.is_initialized = 1;
            end
        
        end

        function obj = update(obj, ~)

            if (isempty(obj.h)), return; end

            set_focus(obj);

        end

        function obj = set_focus(obj)
            set(gcf, 'currentaxes', obj.h);
        end

    end

end
