data_dir = '../../osu_sample';
% osu_file_name = 'Konohana-tei Nakai no Kai - Haru Urara, Kimi to Sakihokoru (cococolaco) [Insane].osu';
% osu_file_name = 'Camellia - LET''S JUMP (RikiH_) [Year 2316].osu';
% osu_file_name = 'DJ Fresh (feat. Ellie Goulding) - Flashlight (Radio Edit) (Frey) [Insane].osu';
% osu_file_name = 'Giga - -BWW SCREAM- (Lavender) [yf''s sb Extreme].osu';
osu_file_name = 'antiPLUR - Speed of Link (ktgster) [299 792 458ms].osu';
osu_file_dir = fullfile(data_dir,osu_file_name);
file_id = fopen(osu_file_dir);
[map, h_obj_list] = osu2mat(file_id);
fclose(file_id);

dist = nan(numel(h_obj_list)-1,1);
for obj = 2:numel(h_obj_list)
    dist(obj-1) = map.timeDist(h_obj_list(obj-1),h_obj_list(obj));
end

window = 20;
window_dist = nan(numel(dist) - window + 1,1);
for i = 1:numel(dist) - window + 1
    window_dist(i) = nanmean(dist(i:i+window-1));
end

scaled_window_dist = (window_dist).^(0.75); % 0.75 based on how DT multiplies rating by 1.35
decay = 0.05;
weighted_values = weightHighPref(scaled_window_dist,decay);
difficulty = sum(weighted_values)/750