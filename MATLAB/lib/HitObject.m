classdef HitObject
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        T_start % time when hit object's time starts
        T_end % time when hit object's time ends
        X_start % x coordinate of start of hit object
        Y_start % y coordinate of start of hit object
        X_end % x coordinate of end of hit object
        Y_end % y coordinate of end of hit object
        Circle % circle = 1, slider = 2, spinner = 3
    end
    
    methods
        function obj = HitObject(x,y,t,circle,varargin)
            % constructor
            % varargin contains a struct containing the other info about
            % the hit object.
            
            obj.X_start = x;
            obj.Y_start = y;
            obj.T_start = t;
            obj.Circle = circle;
            
            if obj.Circle == 1 % if circle
                obj.X_end = obj.X_start;
                obj.Y_end = obj.Y_start;
                obj.T_end = obj.T_start;
            else % if slider
            end
        end
        
        function tdistance = tdist(obj,h_obj)
            % Calculates time relative distance between two objects
            x1 = obj.X_start;
            y1 = obj.Y_start;
            x2 = h_obj.X_end;
            y2 = h_obj.Y_end;
            t1 = obj.T_start;
            t2 = h_obj.T_end;
            tdistance = sqrt((x1-x2)^2 + (y1-y2)^2)./abs(t1-t2);
        end
        
        function distance = dist(obj,h_obj)
            % Calculates distance between two objects
            x1 = obj.X_start;
            y1 = obj.Y_start;
            x2 = h_obj.X_end;
            y2 = h_obj.Y_end;
            distance = sqrt((x1-x2)^2 + (y1-y2)^2);
        end
    end
end

