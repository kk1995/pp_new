function h_obj = line2hitobj(linestr,map)
%line2hitobj Converts a line from .osu file to a hit object
%   Detailed explanation goes here
h_obj = [];
comma_loc = strfind(linestr,',');
% get x,y,t
x = str2double(linestr(1:comma_loc(1)-1));
y = str2double(linestr(comma_loc(1)+1:comma_loc(2)-1));
t0 = str2double(linestr(comma_loc(2)+1:comma_loc(3)-1));

% determine whether circle line or slider line or spinner line
obj_type = str2double(linestr(comma_loc(3)+1:comma_loc(4)-1));
obj_type = dec2bin(obj_type); % type value follows binary, where each digit has info
if str2double(obj_type(end)) == 1 % circle
    circle = 1;
elseif str2double(obj_type(end-1)) == 1 % slider
    circle = 2;
else
    circle = 3;
end

% if slider, get the relevant info
if circle == 2
    bar_loc = strfind(linestr,'|');
    % slider type
    slider_struct.slider_type = linestr(comma_loc(5)+1:bar_loc(1)-1);
    
    % curve points
    curve_points_num = numel(bar_loc(bar_loc < comma_loc(6)));
    curve_points = nan(curve_points_num,2);
    for point = 1:curve_points_num
        curve_point_start = bar_loc(point)+1;
        if point == curve_points_num
            curve_point_end = comma_loc(6)-1;
        else
            curve_point_end = bar_loc(point+1)-1;
        end
        colon_loc = strfind(linestr(curve_point_start:curve_point_end),':') + curve_point_start - 1;
        curve_point_x = str2double(linestr(curve_point_start:colon_loc-1));
        curve_point_y = str2double(linestr(colon_loc+1:curve_point_end));
        curve_points(point,:) = [curve_point_x curve_point_y];
    end
    slider_struct.curve_points = curve_points;
    
    % repeat
    slider_struct.repeat = str2double(linestr(comma_loc(6)+1:comma_loc(7)-1)) - 1; % how many times is the slider repeating
    
    % pixel length and duration
    if numel(comma_loc) >=8
        slider_struct.pixel_length = str2double(linestr(comma_loc(7)+1:comma_loc(8)-1)); % length of slider
    else
        slider_struct.pixel_length = str2double(linestr(comma_loc(7)+1:end)); % length of slider
    end
    beat_duration = map.BeatDuration(find(map.Offset>t0,1)-1);
    slider_multiplier = map.BaseSliderMultiplier*map.SliderMultiplier(find(map.Offset>t0,1)-1);
    slider_struct.duration = slider_struct.pixel_length / (100.0 * slider_multiplier) * beat_duration;
    slider_struct.beat_duration = beat_duration;
    slider_struct.slider_multiplier = slider_multiplier;
    slider_struct.t = t0;
    slider_struct.x = x;
    slider_struct.y = y;
    [slider_struct.ticks,slider_struct.end_point] = curvePoints2ticks(slider_struct,map.SliderTickRate);
end

h_obj = HitObject(x,y,t0,circle);
if circle == 1
    h_obj.Slider = 0;
    h_obj.Spinner = 0;
    h_obj.Tick = 0;
elseif circle == 2
    h_obj.Slider = 1;
    h_obj.Spinner = 0;
    h_obj.Tick = 0;
    for object = 1:size(slider_struct.ticks,1)+1
        if object < size(slider_struct.ticks,1)+1
            x = slider_struct.ticks(object,1);
            y = slider_struct.ticks(object,2);
            t = beat_duration/map.SliderTickRate*object + t0;
        else
            x = slider_struct.end_point(1);
            y = slider_struct.end_point(2);
            t = slider_struct.duration/map.SliderTickRate + t0;
        end
        h_obj_temp = HitObject(x,y,t,circle);
        h_obj_temp.Slider = 1;
        h_obj_temp.Spinner = 0;
        h_obj_temp.Tick = 1;
        h_obj = [h_obj h_obj_temp];
    end
    
end

end

