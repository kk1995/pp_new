function [map, h_obj_list] = osu2mat(osufile_id)
%osu2mat Converts .osu file to a matrix for MATLAB
%   Input: file ID for .osu file. You can get this by using fopen('osu file
%   directory')
%   Output: array of hit objects

end_check = 0;
meta_data_area = 0;
hit_obj_area = 0;
time_point_area = 0;
map = Map();
h_obj_list = [];
meta_str = strings(1);
red_dur = 0;
while ~end_check
    tline = fgetl(osufile_id);
    
    
    % only nonempty lines
    if ~isempty(tline) && ~isa(tline, 'double')
        
        % area management
        if contains(tline,'[General]')
            meta_data_area = 1; % starting next line
            continue;
        elseif contains(tline,'[Events]')
            meta_data_area = 0; % starting next line
            map.importMapData(meta_str); % add meta data to map obj
            continue;
        end
        
        % check that [TimingPoints] has passed
        if contains(tline,'[TimingPoints]')
            time_point_area = 1;
            continue;
        end
        
        % check that [Colours] has passed
        if contains(tline,'[Colours]')
            time_point_area = 0;
            continue;
        end
        
        % check that [HitObjects] has passed
        if contains(tline,'[HitObjects]')
            time_point_area = 0;
            hit_obj_area = 1;
            continue;
        end
        
        
        
        % getting info
        if meta_data_area
            if meta_str == ''
                meta_str(1) = tline;
            else
                meta_str = [meta_str; tline];
            end
        end
        
        if time_point_area
            t_point_values = line2tpoint(tline,red_dur);
            if t_point_values.red == 1
                red_dur = t_point_values.beat_duration;
            end
            map.Offset = [map.Offset t_point_values.offset];
            map.BeatDuration = [map.BeatDuration t_point_values.beat_duration];
            map.SliderMultiplier = [map.SliderMultiplier t_point_values.slider_multiplier];
            map.Meter = [map.Meter t_point_values.meter];
        end
        
        if hit_obj_area
            disp(tline);
            h_obj = line2hitobj(tline,map);
            h_obj_list = [h_obj_list h_obj];
        end
        
        
        
    end
    % end line check
    if tline == -1
        end_check = 1;
    end
end
fclose(osufile_id);

end

