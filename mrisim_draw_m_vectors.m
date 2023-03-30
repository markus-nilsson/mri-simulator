classdef mrisim_draw_m_vectors < mrisim_draw

    properties

        do_draw_coordinate_system = 1;
        do_draw_circle = 1;
        do_draw_rf_pulse = 0; 
        do_draw_transversal_projection = 0;
        sc = 1.09; 

        vector_style = 'arrow';

        campos = [];

    end

    methods

        function obj = mrisim_draw_m_vectors(h)
            obj@mrisim_draw(h);

            obj.campos = [-8 -12.4 5];
        end

        function init(obj, mr_sim)

            init@mrisim_draw(obj, mr_sim);

            % set the focus
            obj.set_focus();

            plot3([0 eps],[0 eps],[0 eps],'.');
            hold on;
            
            % Adjust the plot settings 
            axis equal;

            xlim([-1 1] * obj.sc);
            ylim([-1 1] * obj.sc);
            zlim([-1.05 1.05] );

            set(gca, 'xtick', [], 'ytick', [], 'ztick', []);

            axis vis3d;
            axis off;

            set(gca,'fontsize', 15);

            colormap hot;
            clim([0 numel(mr_sim.spin_sys.vis_ind)+1]);

            title('Magnetisation vectors');

            camtarget([0 0 0.5]);
            campos(obj.campos);

            
        end

        function update(obj, mr_sim)

            % Initialize
            update@mrisim_draw(obj, mr_sim);
            
            % Clear current content
            h_tmp = get(gca,'Children');
            delete(h_tmp);

            % Get short handles
            s = mr_sim.spin_sys;
            p = mr_sim.pulse_seq;


            % Coordinate system
            if (obj.do_draw_coordinate_system)
                plot3( [-1 1] * obj.sc, [0 0], [ 0 0 ], 'k'); hold on;
                plot3([0 0], [-1 1] * obj.sc,  [ 0 0 ], 'k');
                plot3([ 0 0 ], [0 0], [ 0 1 ] * obj.sc, 'k');
            end

            % Circle in the transversal plane
            if (obj.do_draw_circle)
                theta = linspace(0, 2*pi, 100);
                plot3( sin(theta), cos(theta), zeros(size(theta)), ...
                    'k', 'color', [0 0 0] + 0.3) ;
            end


            % Color map logic
            if (numel(s.vis_ind) == 1)
                tmp = 3;
            else
                tmp = round(numel(s.vis_ind) * 1.5);
            end

            cmap = [0 0 0; hot(tmp)];
            colormap(cmap);
            

            % Vector plot function
            switch (obj.vector_style)
                case 'line'

                    
                    draw_vector = @(r, m, c) plot3(...
                            r(1) + [0 m(1)], ...
                            r(2) + [0 m(2)], ...
                            r(3) + [0 m(3)], ...
                            'color', cmap(c, :));
                case 'arrow'

%                     draw_vector = @(r, m, c) arrow3D(...
%                         [0 0 0] + r, m, 'interp', 0.82, c);

                    draw_vector = @(r, m, c) my_arrow3d(...
                        [0 0 0] + r, m, c);
                    
                otherwise

                    error('unknown vector style');
            end

            % Draw the magnetization vectors           
            for c = 1:numel(s.vis_ind)
                k = s.vis_ind(c);
                draw_vector(s.r(k,:), s.m(k,:), c+1);
            end

            % Draw the RF pulse
            if (obj.do_draw_rf_pulse)

                for c_rf = 1:numel(p.rf)

                    if (p.rf{c_rf}.is_active())
                    
                        theta = p.rf{c_rf}.theta();
                        m_rf = -[cos(theta) sin(theta) 0];
                        
                        z = zeros(size(m_rf));

                        draw_vector(z, m_rf, 1); 
                    
                    end

                end

            end

            % Draw the transversal projection of the total magnetization
            if (obj.do_draw_transversal_projection)

                plot3(...
                    s.mt(1:c_t,1), ...
                    s.mt(1:c_t,2), ...
                    s.mt(1:c_t,3) * 0, ...
                    'k-', 'color', [0 0 0] + 0.7);

            end


            lighting phong;
            camlight left;
            shading interp;

            caxis([1 numel(s.vis_ind)+3]);

        end


        function obj = set.sc(obj, sc)

            obj.sc = sc;

            obj.campos = obj.campos * sc;

        end

    end



end




