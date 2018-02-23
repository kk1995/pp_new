classdef Map < handle
    %Map Class for osu! standard map object
    %   This includes information about the map that applies to the whole
    %   map, or sections of the map.
    
    properties
        StackLeniency
        Mode
        HPDrainRate
        CircleSize
        OverallDifficulty
        ApproachRate
        SliderTickRate
        BaseSliderMultiplier % slider multiplier for whole map
        Offset % time point offset
        BeatDuration % duration for each new time point
        SliderMultiplier % multiplier on top of base slider multiplier
        Meter % 1/4 or 1/6 or 1/3 per time point. 1/4 = 4 here
        
    end
    
    methods
        function obj = Map()
        end
        
        function importMapData(obj,str_list)
            for row = 1:numel(str_list)
                line_str = str_list{row};
                
                % set of if statements trying to find out if the line has
                % relevant info
                if contains(line_str,'StackLeniency')
                    obj.StackLeniency = str2double(line_str(strfind(line_str,':')+2:end));
                elseif contains(line_str,'Mode')
                    obj.Mode = str2double(line_str(strfind(line_str,':')+2:end));
                elseif contains(line_str,'HPDrainRate')
                    obj.HPDrainRate = str2double(line_str(strfind(line_str,':')+1:end));
                elseif contains(line_str,'CircleSize')
                    obj.CircleSize = str2double(line_str(strfind(line_str,':')+1:end));
                elseif contains(line_str,'OverallDifficulty')
                    obj.OverallDifficulty = str2double(line_str(strfind(line_str,':')+1:end));
                elseif contains(line_str,'ApproachRate')
                    obj.ApproachRate = str2double(line_str(strfind(line_str,':')+1:end));
                elseif contains(line_str,'SliderMultiplier')
                    obj.BaseSliderMultiplier = str2double(line_str(strfind(line_str,':')+1:end));
                elseif contains(line_str,'SliderTickRate')
                    obj.SliderTickRate = str2double(line_str(strfind(line_str,':')+1:end));
                else
                end
            end
        end
        
        function dist = timeDist(obj,h_obj1, h_obj2, varargin)
            %   calculates time relative distance between two objects
            %   taking into account hit window in both space and time
            %   inputs:
            %       hit object 1
            %       hit object 2
            %       other inputs (ppv2?)
            
            if h_obj1.Spinner == 1 || h_obj2.Spinner == 1 % if one of the objects is a spinner
                dist = 0;
            else
                
                x1 = h_obj1.X; y1 = h_obj1.Y; x2 = h_obj2.X; y2 = h_obj2.Y;
                t1 = h_obj1.T; t2 = h_obj2.T;
                cs = obj.CircleSize;
                od = obj.OverallDifficulty;
                if nargin < 4
                    ppv2 = 0;
                else
                    ppv2 = varargin{1};
                end
                
                space_dist_no_cs = sqrt((x2-x1)^2 + (y2-y1)^2);
                time_diff = obj.timeDiff(h_obj1, h_obj2, ppv2);
                
                dist = space_dist_no_cs/time_diff;
            end
        end
        
        function time_diff = timeDiff(obj,h_obj1, h_obj2, varargin)
            %   calculates time difference between two objects
            %   inputs:
            %       hit object 1
            %       hit object 2
            %       other inputs (ppv2?)
            
            if h_obj1.Spinner == 1 || h_obj2.Spinner == 1 % if one of the objects is a spinner
                time_diff = nan;
            else
                
                x1 = h_obj1.X; y1 = h_obj1.Y; x2 = h_obj2.X; y2 = h_obj2.Y;
                t1 = h_obj1.T; t2 = h_obj2.T;
                od = obj.OverallDifficulty;
                if nargin < 4
                    ppv2 = 0;
                else
                    ppv2 = varargin{1};
                end
                [three_hundred, ~, ~] = obj.od2window(h_obj1);
                [three_hundred2, ~, ~] = obj.od2window(h_obj2);
                time_diff = abs((t2 + three_hundred2(1)) - (t1 + three_hundred(2)));
            end
        end
        
        
        function radius = cs2radius(obj,h_obj)
            cs = obj.CircleSize;
            if h_obj.Slider == 1
                if h_obj.tick == 0 && h_obj.repeat == 0 && h_obj.end == 0 % start of slider
                    radius = 109 - 9 * cs;
                else
                end
            elseif h_obj.spinner == 1
                radius = 512; % max size? I mean it is a spinner...
            else % circle
                radius = 109 - 9 * cs;
            end
        end
        
        function [three_hundred, hundred, fifty] = od2window(obj,h_obj,varargin)
            if nargin < 3
                ppv2 = 0;
            else
                ppv2 = varargin{1};
            end
            hundred = [nan nan];
            fifty = [nan nan];
            od = obj.OverallDifficulty;
            if h_obj.Slider == 1
                if h_obj.Tick == 0 && h_obj.Repeat == 0 && h_obj.End == 0 % start of slider
                    if ppv2
                        three_hundred = 79.5 - 6*od;
                        hundred = 139.5 - 8*od;
                        fifty = 199.5 - 10*od;
                        three_hundred = [-three_hundred three_hundred];
                        hundred = [-hundred hundred];
                        fifty = [-fifty fifty];
                    else
                        three_hundred = 79.5 - 6*od;
                        three_hundred = [-three_hundred three_hundred];
                    end
                elseif h_obj.Tick == 1 % tick point
                    if ppv2 % DOUBLE CHECK THIS IS THE CASE FOR PPV2
                        three_hundred = 79.5 - 6*od;
                        hundred = 139.5 - 8*od;
                        fifty = 199.5 - 10*od;
                        three_hundred = [-three_hundred three_hundred];
                        hundred = [-hundred hundred];
                        fifty = [-fifty fifty];
                    else % DOUBLE CHECK THIS IS THE CASE
                        three_hundred = 79.5 - 6*od;
                        three_hundred = [-three_hundred three_hundred];
                    end
                elseif h_obj.Repeat == 1 % repeat point
                    three_hundred = 79.5 - 6*od;
                    three_hundred = [-three_hundred 0];
                elseif h_obj.End == 1 % end point
                    if ppv2
                        three_hundred = 79.5 - 6*od;
                        hundred = 139.5 - 8*od;
                        fifty = 199.5 - 10*od;
                        three_hundred = [-three_hundred three_hundred];
                        hundred = [-hundred hundred];
                        fifty = [-fifty fifty];
                    else
                        three_hundred = 79.5 - 6*od;
                        three_hundred = [-three_hundred three_hundred];
                    end
                end
            elseif h_obj.Spinner == 1
                three_hundred = nan;
                three_hundred = [-three_hundred three_hundred];
            else % circle
                three_hundred = 79.5 - 6*od;
                hundred = 139.5 - 8*od;
                fifty = 199.5 - 10*od;
                three_hundred = [-three_hundred three_hundred];
                hundred = [-hundred hundred];
                fifty = [-fifty fifty];
            end
        end
        
        
        function angle = angle(obj,h_obj1, h_obj2, varargin)
            %   calculates time relative distance between two objects
            %   taking into account hit window in both space and time
            %   inputs:
            %       hit object 1
            %       hit object 2
            %       other inputs (ppv2?)
            
            if h_obj1.Spinner == 1 || h_obj2.Spinner == 1 % if one of the objects is a spinner
                angle = nan;
            else
                
                x1 = h_obj1.X; y1 = h_obj1.Y; x2 = h_obj2.X; y2 = h_obj2.Y;
                t1 = h_obj1.T; t2 = h_obj2.T;
                cs = obj.CircleSize;
                od = obj.OverallDifficulty;
                if nargin < 4
                    ppv2 = 0;
                else
                    ppv2 = varargin{1};
                end
                
                space_dist_no_cs = sqrt((x2-x1)^2 + (y2-y1)^2);
                time_dist_no_od = abs(t2 - t1);
                
                dist = space_dist_no_cs/time_dist_no_od;
            end
        end
        
    end
end

