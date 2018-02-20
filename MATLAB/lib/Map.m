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
            x1 = h_obj1.X; y1 = h_obj1.Y; x2 = h_obj2.X; y2 = h_obj2.Y;
            cs = obj.CircleSize;
            od = obj.OverallDifficulty;
            if nargin < 3
                ppv2 = 0;
            else
                ppv2 = varargin{1};
            end
        end
    end
end

