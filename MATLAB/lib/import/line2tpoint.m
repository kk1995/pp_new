function t_point_values = line2tpoint(linestr,red_dur)
%line2tpoint Finds the relevant info about time point from a line from .osu
%file
%   red_dur is the last red time point's duration (opposite of frequency)
%   in milliseconds

comma_loc = strfind(linestr,',');
offset = str2double(linestr(1:comma_loc(1)-1));
multiplier = str2double(linestr(comma_loc(1)+1:comma_loc(2)-1));
if multiplier < 0 % green line
    beat_duration = red_dur;
    slider_duration = red_dur*-multiplier/100;
    red = 0;
else % red line
    beat_duration = multiplier;
    slider_duration = beat_duration;
    red = 1;
end
meter = str2double(linestr(comma_loc(2)+1:comma_loc(3)-1));

t_point_values.offset = offset;
t_point_values.beat_duration = beat_duration;
t_point_values.slider_multiplier = beat_duration./slider_duration;
t_point_values.meter = meter;
t_point_values.red = red;
end

