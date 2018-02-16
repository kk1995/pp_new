classdef Map < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
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
    end
end

