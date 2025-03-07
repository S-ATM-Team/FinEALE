function self = reset (self, context)
% "Reset" view parameters for drawing.
%
% function retobj = reset (self, context)
%
% context= structure with optional fields:
% axes = Matlab axes handle: The axes are associated with 
%      the graphic viewer and all drawing will go into these axes 
%      until they are changed with another reset().
% limits = array of the extents of the drawing
% snap_points = points in 3-D space to which the camera may be targeted. 
% (See the rotate() method of the graphic_viewer class.)
% 
% If  the graphic viewer was not associated with any axes  when this method
% was called, default axes are created  and associated  with the viewer.
% The method makes the associated axes the current axes  and 
% brings them into focus. The clear()  method is called.
% Then  the  limits  of the graphics are reset in the axes:  
% If the context  does not specify limits, '?LimMode','auto' is  used;
% otherwise the mode is  set to manual  and the limits are set.
% Finally, the renderer is set to OpenGL.
    if ~exist('context','var')
        context.ignore= [];
    end
    if isfield(context,'snap_points')
        self.snap_points= context.snap_points;
    end
    if isfield(context,'axes')
        self.axes= context.axes;
    end
    if (isempty(self.axes))||(self.axes==0)
        %         Create default axes
        self.axes=get(gcf,'CurrentAxes');
        if (isempty(self.axes))
            axes;
            self.axes=gca;
        end
        set(self.axes,'Units','normalized')
        set(self.axes,'position',[0.05  0.1  0.8  0.8]);
        set(self.axes,...
            'Color', 'white', ...
            'FontUnits', 'points', ...
            'FontSize', 14, ...
            'FontAngle', 'Normal', ...
            'FontName', 'Times', ...
            'GridLineStyle', ':', ...
            'Xcolor', [0, 0, 0], ...
            'Ycolor', [0, 0, 0], ...
            'Zcolor', [0, 0, 0]);
        l=get(self.axes,'xlabel');
        set (l,'FontSize',16,...
            'FontAngle', 'Normal', ...
            'FontName', 'Times');
        l=get(self.axes,'ylabel');
        set (l,'FontSize',16,...
            'FontAngle', 'Normal', ...
            'FontName', 'Times');
        l=get(self.axes,'zlabel');
        set (l,'FontSize',16,...
            'FontAngle', 'Normal', ...
            'FontName', 'Times');
        l=get(self.axes,'title');
        set (l,'FontSize',18,...
            'FontAngle', 'Normal', ...
            'FontName', 'Times');
    end
%  Make the associated axes the current axes  and bring them into focus
    try
        %         If the axes and the containing figure are visible, set the current axes
        if (strcmp(get(get(self.axes,'parent'),'visible'),'on'))
            axes(self.axes); % set the current axes
        end
    catch
        figure(gcf);
        axes;
        self.axes=gca;
    end
%     Clear the axes
    self =clear(self, context);
    if isfield(context,'peek')
        if context.peek
            peekb  = uicontrol('Parent',gcf,'Style','pushbutton',...
                'Units','Normalized','Position',[.9 .0 .1 .05],...
                'String','Peek','Value',0,...
                'TooltipString','Invoke command line in order to peek at data',...
                'Callback',@peek_button_pressed);
        end
    end
%     The limits  are reset
    if ~isfield(context,'limits')
            view(3); axis equal vis3d;
        %         axis on;
        %         axis off; 
        set(self.axes,'XLimMode','auto');
        set(self.axes,'YLimMode','auto');
        set(self.axes,'ZLimMode','auto');
    else
        if length (context.limits) > 4
            view(3); axis equal vis3d;
            %             axis on;
            %             axis off; 
            l=sort(context.limits(1:2)); if (diff(l)==0), l=l+[-eps,+eps];        end
            set(self.axes,'XLim',l);
            l=sort(context.limits(3:4)); if (diff(l)==0), l=l+[-eps,+eps];        end
            set(self.axes,'YLim',l);
            l=sort(context.limits(5:6)); if (diff(l)==0), l=l+[-eps,+eps];        end
            set(self.axes,'ZLim',l);
        else
            view(2); pos=get(self.axes,'position');
            l=sort(context.limits(1:2)); if (diff(l)==0), l=l+[-eps,+eps];        end
            set(self.axes,'XLim',l);
            if (length(context.limits)>=4)
                l=sort(context.limits(3:4)); if (diff(l)==0), l=l+[-eps,+eps];        end
                set(self.axes,'YLim',l);
            end
            set(self.axes,'position',pos);
            set(self.axes,'cameraviewanglemode','auto');
        end
        set(self.axes,'DataAspectRatioMode','manual');
        set(self.axes,'DataAspectRatio',[1,1,1]);
    end
%     Finally  set the renderer
    set(gcf,'Renderer','OpenGL');
    opengl software
    %     if (ispc) &&  (~strcmp(version('-release'),'13'))
    %         opengl hardware
    %     end
    % set(gcf,'DoubleBuffer','on');
    % set(gcf,'Renderer','zbuffer');
    % camlight left;
    % camlight right;
    % camlight headlight;
    % lighting flat;
    %     xlabel('X');
    %     ylabel('Y');
    %     zlabel('Z'); 
    if (self.pk_defaults)
        gv_set_axes_defaults_(self.axes);
    end
end
    
function peek_button_pressed(h,varargin)
    keyboard;
end


function gv_set_axes_defaults_(ax)
    set(ax, 'Color', 'White');
    set(ax,...
        'Color', 'white', ...
        'FontUnits', 'points', ...
        'FontSize', 14, ...
        'FontAngle', 'Normal', ...
        'FontName', 'Times', ...
        'GridLineStyle', ':', ...
        'Xcolor', [0, 0, 0], ...
        'Ycolor', [0, 0, 0], ...
        'Zcolor', [0, 0, 0]);
    l=get(ax,'xlabel');
    set (l,'FontSize',16,...
        'FontAngle', 'Normal', ...
        'FontName', 'Times');
    l=get(ax,'ylabel');
    set (l,'FontSize',16,...
        'FontAngle', 'Normal', ...
        'FontName', 'Times');
    l=get(ax,'zlabel');
    set (l,'FontSize',16,...
        'FontAngle', 'Normal', ...
        'FontName', 'Times');
    l=get(ax,'title');
    set (l,'FontSize',18,...
        'FontAngle', 'Normal', ...
        'FontName', 'Times');
    %             set(child, 'position', position+[0,0.02,0,-0.03]);
end
%
%     set (l,'FontSize',16);
%     l=get(gca,'ylabel');
%     set (l,'FontSize',16);

% set(0, 'DefaultFigureColor', 'White', ...
%        'DefaultFigurePaperType', 'a4letter', ...
%        'DefaultFigurePaperType', 'a4letter', ...
%        'DefaultUIControlbackgroundcolor', [1, 1, 1], ...
%        'DefaultUIControlFontUnits', 'points', ...
%        'DefaultUIControlFontSize', 12, ...
%        'DefaultUIControlFontAngle', 'normal', ...
%        'DefaultUIControlFontName', 'Helvetica', ...       
%        'DefaultUIControlForeGroundColor', 'black', ...
%        'DefaultAxesColor', 'white', ...
%        'DefaultAxesDrawmode', 'fast', ...
%        'DefaultAxesFontUnits', 'points', ...
%        'DefaultAxesFontSize', 14, ...
%        'DefaultAxesFontAngle', 'Normal', ...
%        'DefaultAxesFontName', 'Times', ...       
%        'DefaultAxesGridLineStyle', ':', ...
%        'DefaultAxesInterruptible', 'on', ...
%        'DefaultAxesLayer', 'Bottom', ...
%        'DefaultAxesNextPlot', 'replace', ...
%        'DefaultAxesUnits', 'normalized', ...
%        'DefaultAxesXcolor', [0, 0, 0], ...
%        'DefaultAxesYcolor', [0, 0, 0], ...
%        'DefaultAxesZcolor', [0, 0, 0], ...
%        'DefaultAxesXTickMode','Auto',...
%        'DefaultAxesYTickMode','Auto',...
%        'DefaultAxesZTickMode','Auto',...
%        'DefaultAxesVisible', 'on', ...
%        'DefaultLineColor', 'Red', ...
%        'DefaultLineLineStyle', '-', ...
%        'DefaultLineLineWidth', 2, ...
%        'DefaultLineMarker', 'none', ...
%        'DefaultLineMarkerSize', 12, ...
%        'DefaultTextColor', [0, 0, 0], ...
%        'DefaultTextFontUnits', 'Points', ...
%        'DefaultTextFontSize', 14, ...
%        'DefaultTextFontName', 'Times', ...
%        'DefaultTextVerticalAlignment', 'middle', ...
%        'DefaultTextHorizontalAlignment', 'left');
% warning off;       
% % set(0, 'DefaultFigureMenubar', 'none', ...
% %        'DefaultFigureNextPlot', 'add', ...
% %        'DefaultFigureColor', 'black', ...
% %        'DefaultFigureNumberTitle', 'off', ...
% %        'DefaultFigureShareColors', 'on', ...
% %        'DefaultFigurePaperType', 'a4letter', ...
% %        'DefaultUIControlbackgroundcolor', [0.702 0.702 .702], ...
% %        'DefaultUIControlFontUnits', 'points', ...
% %        'DefaultUIControlFontSize', QDefaultUIFontSize, ...
% %        'DefaultUIControlFontAngle', 'normal', ...
% %        'DefaultUIControlFontName', 'Helvetica', ...       
% %        'DefaultUIControlInterruptible', 'off', ...
% %        'DefaultUIControlForeGroundColor', 'black', ...
% %        'DefaultUIControlHorizontalAlignment', 'center', ...
% %        'DefaultUIControlSelectionHighLight', 'on', ...
% %        'DefaultUIMenuSelectionHighLight', 'on', ...
% %        'DefaultAxesColor', 'none', ...
% %        'DefaultAxesDrawmode', 'fast', ...
% %        'DefaultAxesFontUnits', 'points', ...
% %        'DefaultAxesFontSize', 12, ...
% %        'DefaultAxesFontAngle', 'normal', ...
% %        'DefaultAxesFontName', 'Helvetica', ...       
% %        'DefaultAxesGridLineStyle', ':', ...
% %        'DefaultAxesInterruptible', 'on', ...
% %        'DefaultAxesLayer', 'Bottom', ...
% %        'DefaultAxesNextPlot', 'replace', ...
% %        'DefaultAxesUnits', 'normalized', ...
% %        'DefaultAxesXcolor', [1 1 1], ...
% %        'DefaultAxesYcolor', [1 1 1], ...
% %        'DefaultAxesZcolor', [1 1 1], ...
% %        'DefaultAxesVisible', 'on', ...
% %        'DefaultLineColor', 'yellow', ...
% %        'DefaultLineLineStyle', '-', ...
% %        'DefaultLineLineWidth', 0.5, ...
% %        'DefaultLineMarker', 'none', ...
% %        'DefaultLineMarkerSize', 6, ...
% %        'DefaultLineHittest', 'off', ...
% %        'DefaultPatchHittest', 'off', ...
% %        'DefaultSurfaceHittest', 'off', ...
% %        'DefaultTextHittest', 'off', ...
% %        'DefaultTextColor', [1 1 1], ...
% %        'DefaultTextFontUnits', 'Points', ...
% %        'DefaultTextFontSize', 12, ...
% %        'DefaultTextFontName', 'Helvetica', ...
% %        'DefaultTextVerticalAlignment', 'middle', ...
% %        'DefaultTextHorizontalAlignment', 'left');
