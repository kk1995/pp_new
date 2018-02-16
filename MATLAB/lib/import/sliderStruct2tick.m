function ticks = sliderStruct2tick(slider_struct,map)
%sliderStruct2tick takes in struct containing info about the slider and
%outputs 3x1 value (x,y,t)
%   struct has:
%   x,y,t,beat_duration,slider_multiplier,slider_type,curve_points,repeat

x_start = slider_struct.x;
y_start = slider_struct.y;
t_start = slider_struct.t;
type = slider_struct.slider_type;
curve_points = [x_start y_start; slider_struct.curve_points];
total_multiplier = map.BaseSliderMultiplier*slider_struct.slider_multiplier;
beat_dist = total_multiplier*100;
% find sections
sections = [];
section_start = 1;
for point = 2:size(curve_points,1)
    if curve_points(point-1,1) == curve_points(point,1) && curve_points(point-1,2) == curve_points(point,2)
        section_end = point-1;
        sections = [sections;section_start section_end];
        section_start = point;
    end
end
if isempty(sections)
    sections = [1 size(curve_points,1)];
end

% calculate path by type
if type == 'B' % bezier
    for section = 1:size(sections,1)
        section_curve_points = curve_points(sections(section,1):sections(section,2),:);
        if size(section_curve_points,1) == 3
            a = section_curve_points(1,:); b = section_curve_points(2,:); c = section_curve_points(3,:);
            slider_points = bezier(a,b,c);
            slider_dist = sum(sqrt(diff(slider_points(:,1)).^2 + diff(slider_points(:,2)).^2));
            
        end
    end
elseif type == 'P' % perfect (3 points)
    a = curve_points(1,:); b = curve_points(2,:); c = curve_points(3,:);
    slider_points = bezier(a,b,c);
    slider_dist = sum(sqrt(diff(slider_points(:,1)).^2 + diff(slider_points(:,2)).^2));
elseif type == 'L' % linear (2 points)
else % catmull
end

time_dist = slider_dist/beat_dist;
meter = map.Meter(find(map.Offset>t_start,1)-1);
frac = (time_dist-mod(time_dist,1/meter))./time_dist;
slider_points = slider_points(1:round(frac*size(slider_points,1)));
slider_dist = frac*slider_dist;
time_dist = frac*time_dist;
end

