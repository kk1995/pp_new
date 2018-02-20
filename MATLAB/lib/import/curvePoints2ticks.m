function [tickXY, repeatXY, endXY] = curvePoints2ticks(slider_struct,tick_rate)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% map.SliderTickRate for tick_rate
c_points = slider_struct.curve_points;
c_points = [slider_struct.x slider_struct.y; c_points];
type = slider_struct.slider_type;
tick_dist = slider_struct.pixel_length/slider_struct.duration*slider_struct.beat_duration/tick_rate; % distance for one tick
tick_num = floor((slider_struct.pixel_length-tick_dist/25)/tick_dist);
repeat_dist = slider_struct.pixel_length./(slider_struct.repeat+1);
% find red points and find sections
start_point = 1;
end_point = [];
for point = 1:size(c_points,1)
    if size(c_points,1) == point
        end_point = [end_point point];
    elseif c_points(point,1) == c_points(point+1,1) && c_points(point,2) == c_points(point+1,2)
        if point > 1 && c_points(point,1) == c_points(point-1,1) && c_points(point,2) == c_points(point-1,2)
        else
            end_point = [end_point point];
            start_point = [start_point point+1];
        end
    end
end

% find sections with only one dot and delete them
bad_sections = find(end_point - start_point < 1);
start_point(bad_sections) = [];
end_point(bad_sections) = [];

% based on type, do analysis
if contains(type,'B')
    slider_points = nan(1001,2,numel(start_point));
    dist = nan(numel(start_point),1);
    for section = 1:numel(start_point)
        [slider_points(:,:,section), dist(section)] = bezier(c_points(start_point(section):end_point(section),:));
    end
elseif contains(type,'L')
    [slider_points, dist] = bezier(c_points(start_point:end_point,:));
elseif contains(type,'P')
    [slider_points, dist] = circularArcApproximator(c_points(1,:),c_points(2,:),c_points(3,:));
else
    error('This slider type not possible yet. Needs to be coded in.');
end


% find each tick's location
tick_list = nan(tick_num,2);
dist2tick = 0;
for tick = 1:tick_num
    dist2tick = tick_dist*tick;
    dist_left = dist2tick;
    on_section = false;
    section = 1;
    
    while ~on_section
        if dist2tick >= 4*sqrt(2) % making sure that the whole length is more than pixel error range
            if dist_left < 4*sqrt(2) % if what is left is less than pixel error range
                section = section - 1;
                dist_left = dist(section);
                on_section = true;
            else
                if dist_left > dist(section)
                    dist_left = dist_left - dist(section);
                    section = section + 1;
                else
                    on_section = true;
                end
            end
        else
            on_section = true;
        end
    end
    
    slider_point_ind = round(dist_left/dist(section)*(size(slider_points,1)-1))+1;
    tick_list(tick,:) = slider_points(slider_point_ind,:,section); % somehow few pixels off. This probably
    % won't affect the difficulty value that much, but should eventually fix.
end
tickBeatT = 1/tick_rate*(1:size(tick_list,1));

% find end point location
dist2end = repeat_dist;
dist_left = dist2end;
on_section = false;
section = 1;
while ~on_section
    if dist2end >= 4*sqrt(2) % making sure that the whole length is more than pixel error range
        if dist_left < 4*sqrt(2) % if what is left is less than pixel error range
            section = section - 1;
            dist_left = dist(section);
            on_section = true;
        else
            if dist_left > dist(section)
                dist_left = dist_left - dist(section);
                section = section + 1;
            else
                on_section = true;
            end
        end
    else
        on_section = true;
    end
end


slider_point_ind = round(dist_left/dist(section)*(size(slider_points,1)-1))+1;
repeat_point = slider_points(slider_point_ind,:,section); % somehow few pixels off. This probably
% won't affect the difficulty value that much, but should eventually fix.
repeatBeatT = slider_struct.duration/slider_struct.beat_duration/(slider_struct.repeat+1);


% make array of ticks, repeats, and ends (nx3 each)
tickXY = [];
repeatXY = [];
endXY = [];
repeat_count = 0;
start_beat = 0;
while repeat_count <= slider_struct.repeat
    if mod(repeat_count,2) == 1
        if repeat_count == slider_struct.repeat
            tickXY = [tickXY; tick_list(size(tick_list,1):-1:1,:) tickBeatT(end:-1:1)];
            start_beat = start_beat + repeatBeatT;
            endXY = [slider_struct.x slider_struct.y start_beat];
        else
            tickXY = [tickXY; tick_list(size(tick_list,1):-1:1,:) tickBeatT(end:-1:1)];
            start_beat = start_beat + repeatBeatT;
            repeatXY = [repeatXY; slider_struct.x slider_struct.y start_beat];
        end
    else
        if repeat_count == slider_struct.repeat
            tickXY = [tickXY; tick_list tickBeatT];
            start_beat = start_beat + repeatBeatT;
            endXY = [repeat_point start_beat];
        else
            tickXY = [tickXY; tick_list tickBeatT];
            start_beat = start_beat + repeatBeatT;
            repeatXY = [repeatXY; repeat_point start_beat];
        end
    end
    repeat_count = repeat_count + 1;
end

end

