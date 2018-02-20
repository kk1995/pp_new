data_dir = '../../osu_sample';
% osu_file_name = 'Konohana-tei Nakai no Kai - Haru Urara, Kimi to Sakihokoru (cococolaco) [Insane].osu';
osu_file_name = 'Camellia - LET''S JUMP (RikiH_) [Year 2316].osu';
osu_file_dir = fullfile(data_dir,osu_file_name);
file_id = fopen(osu_file_dir);
[map, h_obj_list] = osu2mat(file_id);
fclose(file_id);