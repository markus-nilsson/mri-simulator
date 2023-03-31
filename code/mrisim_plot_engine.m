classdef mrisim_plot_engine < handle

    properties

        plot_vectors = mrisim_draw([]);
        plot_signal  = mrisim_draw([]);
        plot_timeline = mrisim_draw([]);

        n_mod = 10;

        is_initalized = 0;

        do_export_gif = 0;
        gif_first_frame = 1;
        gif_fn = [];
        caller_fn = [];
        
        c_plot_mode = 1;
        

    end

    methods

        function obj = mrisim_plot_engine(l_str, c_plot_mode)

            if (nargin < 1), l_str = {}; end
            if (nargin < 2), c_plot_mode = 1; end

            switch (c_plot_mode)
                
                case 1 % all three plots

                    p = [...
                        +0.49 0.10 0.48  0.90; 
                        +0.08 0.60 0.35 0.30;
                        +0.08 0.15 0.35 0.30];

                    obj.plot_vectors  = mrisim_draw_m_vectors(p(1,:));
                    obj.plot_signal   = mrisim_draw_signal_transversal(p(2,:), l_str);
                    obj.plot_timeline = mrisim_draw_timeline(p(3,:));
                
                case 2 % vectors and signal only

                    p = [...
                        -0.05 0.00 0.75 1.00;
                        +0.60 0.25 0.35 0.50];
                    
                    obj.plot_vectors  = mrisim_draw_m_vectors(p(1,:));
                    obj.plot_signal   = mrisim_draw_signal_transversal(p(2,:), l_str);


                case 3 % bssfp plot

                    p = [...
                        -0.05 0.00 0.75 1.0;
                        +0.60 0.25 0.35 0.45
                        ];

                    obj.plot_vectors  = mrisim_draw_m_vectors(p(1,:));
                    obj.plot_signal   = mrisim_draw_signal_bssfp(p(2,:));

                case 4 % vectors and timeline only

                    p = [...
                        -0.05 0.00 0.75 1.00;
                        +0.60 0.25 0.35 0.50];
                    
                    obj.plot_vectors  = mrisim_draw_m_vectors(p(1,:));
                    obj.plot_signal   = mrisim_draw_timeline(p(2,:));
               
            end

            tmp = dbstack;
            obj.caller_fn = tmp(2).name;

            obj.c_plot_mode = c_plot_mode;

        end

        function obj = init(obj, mr_sim)

            % this is where the axes will be created
            if (~obj.is_initalized)
                clf;

                set(gcf, ...
                    'color','white', ...
                    'defaultlinelinewidth', 2, ...
                    'defaultaxeslinewidth', 2, ...
                    'defaultaxesfontweight', 'bold', ...
                    'defaultaxestickdir', 'out', ...
                    'defaultaxesbox', 'off');

                if (obj.do_export_gif)

                    if (isempty(obj.gif_fn))
                        % Automatically set an output filename, if the function
                        % that instantiated this object was one of the
                        % mridemo files

                        if (strcmp(obj.caller_fn(1:min(end,7)), 'mridemo'))

                            obj.gif_fn = fullfile(fileparts(mfilename('fullpath')), ...
                                '..', 'gif', sprintf('%s.gif', obj.caller_fn));

                        end
                    end

                    if (isempty(obj.gif_fn))
                        error('gif filename must be set');
                    end

                    % Assume framerate was approx 24 in the on-screen
                    % renderings
                    obj.n_mod = round(obj.n_mod / 2);

                    % Delete previous file
                    if (exist(obj.gif_fn, 'file'))
                        delete(obj.gif_fn);
                    end
                end

                obj.is_initalized = 1;
            end

            obj.plot_vectors.init(mr_sim);
            obj.plot_signal.init(mr_sim);
            obj.plot_timeline.init(mr_sim);


            function delete_title(h)
                if (~isempty(h))
                    h.Title.String = '';
                end
            end


            % Try for better alignment of titles
            if (1)

                % Add a text box using the annotation function
                f = @(pos, text) annotation(gcf, ...
                    'textbox', pos, ...
                    'String', text, ...
                    'EdgeColor', 'none', ...
                    'HorizontalAlignment', ...
                    'center', ...
                    'VerticalAlignment', 'middle', ...
                    'FontSize', 16, ...
                    'FontWeight', 'bold');
                

                switch (obj.c_plot_mode)
                    case 1
                        f([0.5 0.90 0.45 0.1], 'Magnetization vectors');
                        f([0.0 0.90 0.5 0.1], 'Transverse magnetization');
                        f([0.0 0.43 0.5 0.1], obj.plot_timeline.h.Title.String);
                        delete_title(obj.plot_timeline.h);
                        delete_title(obj.plot_vectors.h);
                        delete_title(obj.plot_signal.h);

                        annotation(gcf, ...
                            'textbox', [0.5 0.02 0.45 0.1], ...
                            'String', 'https://github.com/markus-nilsson/mri-simulator', ...
                            'EdgeColor', 'none', ...
                            'HorizontalAlignment', ...
                            'center', ...
                            'VerticalAlignment', 'middle', ...
                            'FontSize', 14, ...
                            'Color', [0 0 0] + 0.7);
                        
                    case {2,3}
                        f([0.1 0.80 0.4 0.1], 'Magnetization vectors');
                        f([0.5 0.80 0.5 0.1], 'Transverse magnetization');
                        delete_title(obj.plot_vectors.h);
                        delete_title(obj.plot_signal.h);

                        annotation(gcf, ...
                            'textbox', [0.1 0.05 0.8 0.1], ...
                            'String', 'https://github.com/markus-nilsson/mri-simulator', ...
                            'EdgeColor', 'none', ...
                            'HorizontalAlignment', ...
                            'center', ...
                            'VerticalAlignment', 'middle', ...
                            'FontSize', 16, ...
                            'Color', [0 0 0] + 0.7);

                end


            end


        end

        
        function obj = update(obj, mr_sim)

            if (mod(mr_sim.pulse_seq.timeline.c_t - 1, obj.n_mod) == 0)

                obj.plot_vectors.update(mr_sim);
                obj.plot_signal.update(mr_sim);
                obj.plot_timeline.update(mr_sim);

                drawnow;
                pause(0.01); % draw

                if (obj.do_export_gif)

                    f = getframe(gcf);
                    im = frame2im(f);

                    % Add a synthetic depth of field
                    if (0) 
                        rng(2);
                        cp = obj.plot_vectors.campos;
                        n_views = 50;
                        for c = 1:n_views
                            set(obj.plot_vectors.h, 'cameraposition', cp + randn(size(cp)) * 0.05);
                            im = double(im) + double(frame2im(getframe(gcf)));
                        end
                        im = uint8(im / (n_views));
                    end

                    [A,map] = rgb2ind(im,256);

                    delay_time = 1/50;
                    
                    if (obj.gif_first_frame)
                        imwrite(A,map,obj.gif_fn,'gif','LoopCount',Inf,'DelayTime',delay_time);                            
                        obj.gif_first_frame = 0;
                    else
                        imwrite(A,map,obj.gif_fn,'gif','WriteMode','append','DelayTime',delay_time);
                    end
                end

            end

        end

    end
end