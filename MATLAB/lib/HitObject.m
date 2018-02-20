classdef HitObject
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        T % time when hit object's time starts
        X % x coordinate of start of hit object
        Y % y coordinate of start of hit object
        Slider
        Spinner
        Tick
    end
    
    methods
        function obj = HitObject(x,y,t,varargin)
            % constructor
            % varargin contains a struct containing the other info about
            % the hit object.
            
            obj.X = x;
            obj.Y = y;
            obj.T = t;
            obj.Slider = 0;
            obj.Spinner = 0;
            obj.Tick = 0;
        end
        
        function tdistance = tdist(obj,h_obj)
            % Calculates time relative distance between two objects
            x1 = obj.X;
            y1 = obj.Y;
            x2 = h_obj.X;
            y2 = h_obj.Y;
            t1 = obj.T;
            t2 = h_obj.T;
            tdistance = sqrt((x1-x2)^2 + (y1-y2)^2)./abs(t1-t2);
        end
        
        function distance = dist(obj,h_obj)
            % Calculates distance between two objects
            x1 = obj.X;
            y1 = obj.Y;
            x2 = h_obj.X;
            y2 = h_obj.Y;
            distance = sqrt((x1-x2)^2 + (y1-y2)^2);
        end
    end
end

