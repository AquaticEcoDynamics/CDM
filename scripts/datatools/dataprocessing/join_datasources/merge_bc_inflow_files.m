% Define input files and their variable names
input_files = {
    '../../../../data/store/hydro/dew_WaterDataSA_hourly.mat', 'dew';
    '../../../../data/store/ecology/wq_hchb_1998_2019.mat', 'wqDataSAhist';
    '../../../../data/store/ecology/wq_hchb_2024.mat', 'wqDataSA';
    '../../../../data/store/hydro/dew_barrage_2024.mat', 'barrages'
};

% Initialize output structure and merge log
cllmm = struct();
merge_log = {};
all_data = cell(size(input_files, 1), 1);  % Store all loaded data

% Function to get coordinates and agency from a structure
function [X, Y, Agency] = getCoordinatesAndAgency(data_struct, site_name)
    vars = fieldnames(data_struct.(site_name));
    % Get X and Y from first variable
    X = double(data_struct.(site_name).(vars{1}).X);
    Y = double(data_struct.(site_name).(vars{1}).Y);
    
    if isfield(data_struct.(site_name).(vars{1}), 'Agency')
        Agency = data_struct.(site_name).(vars{1}).Agency;
    else
        Agency = '';  % Default empty string if Agency not found
    end
end

% First, load all data files and store them
for file_idx = 1:size(input_files, 1)
    data = load(input_files{file_idx, 1});
    var_name = input_files{file_idx, 2};
    
    % Debug: Print available variables
    fprintf('File %s contains variables:\n', input_files{file_idx, 1});
    disp(fieldnames(data));
    
    if ~isfield(data, var_name)
        warning('Variable %s not found in file %s', var_name, input_files{file_idx, 1});
        continue;
    end
    
    all_data{file_idx} = data.(var_name);
end

% Process each dataset
for file_idx = 1:size(input_files, 1)
    if isempty(all_data{file_idx})
        continue;
    end
    
    current_data = all_data{file_idx};
    sites = fieldnames(current_data);
    
    % Process each site
    for i = 1:length(sites)
        current_site = sites{i};
        [site_X, site_Y, site_Agency] = getCoordinatesAndAgency(current_data, current_site);
        
        % For first file (DEW data), directly copy all sites
        if file_idx == 1
            cllmm.(current_site) = current_data.(current_site);
            % Convert Depth to double
            vars = fieldnames(cllmm.(current_site));
            for v = 1:length(vars)
                if isfield(cllmm.(current_site).(vars{v}), 'Depth')
                    cllmm.(current_site).(vars{v}).Depth = double(cllmm.(current_site).(vars{v}).Depth);
                end
                % Add conversion for X and Y
                if isfield(cllmm.(current_site).(vars{v}), 'X')
                    cllmm.(current_site).(vars{v}).X = double(cllmm.(current_site).(vars{v}).X);
                end
                if isfield(cllmm.(current_site).(vars{v}), 'Y')
                    cllmm.(current_site).(vars{v}).Y = double(cllmm.(current_site).(vars{v}).Y);
                end
            end
            merge_log{end+1} = sprintf('Copied DEW site: %s', current_site);
            continue;
        end
        
        % For subsequent files, try to match coordinates with DEW and wqDataSAhist
        site_matched = false;
        reference_sites = fieldnames(cllmm);  % Reference the combined DEW and wqDataSAhist data
        
        for j = 1:length(reference_sites)
            ref_site = reference_sites{j};
            [ref_X, ref_Y, ref_Agency] = getCoordinatesAndAgency(cllmm, ref_site);
            
            % Define pairs that should not be merged
            should_not_merge = (...
                (contains(current_site, 'Seagull_Island') && contains(ref_site, 'South_Policeman_Point')) || ...
                (contains(current_site, 'South_Policeman_Point') && contains(ref_site, 'Seagull_Island')) ...
            );
            
            % Check coordinate match, Agency match, and ensure sites aren't in the exclusion list
            if abs(site_X - ref_X) < 1e-10 && abs(site_Y - ref_Y) < 1e-10 && ...
               strcmp(site_Agency, ref_Agency) && ~should_not_merge
                % Merge fields into existing site
                site_fields = fieldnames(current_data.(current_site));
                for k = 1:length(site_fields)
                    if ~isfield(cllmm.(ref_site), site_fields{k})
                        % If field doesn't exist, add it
                        cllmm.(ref_site).(site_fields{k}) = ...
                            current_data.(current_site).(site_fields{k});
                        % Ensure X and Y are double
                        cllmm.(ref_site).(site_fields{k}).X = double(cllmm.(ref_site).(site_fields{k}).X);
                        cllmm.(ref_site).(site_fields{k}).Y = double(cllmm.(ref_site).(site_fields{k}).Y);
                        % Convert Depth to double if it exists
                        if isfield(cllmm.(ref_site).(site_fields{k}), 'Depth')
                            cllmm.(ref_site).(site_fields{k}).Depth = double(cllmm.(ref_site).(site_fields{k}).Depth);
                        end
                    else
                        % If field exists, concatenate the data
                        % Get the fieldnames of the nested structure
                        nested_fields = fieldnames(current_data.(current_site).(site_fields{k}));
                        for n = 1:length(nested_fields)
                            if strcmp(nested_fields{n}, 'Data') || strcmp(nested_fields{n}, 'Date') || strcmp(nested_fields{n}, 'Depth')
                                % Concatenate Data, Date, and Depth fields
                                existing_data = cllmm.(ref_site).(site_fields{k}).(nested_fields{n});
                                new_data = current_data.(current_site).(site_fields{k}).(nested_fields{n});
                                if strcmp(nested_fields{n}, 'Depth')
                                    new_data = double(new_data);
                                end
                                combined_data = [existing_data; new_data];
                                cllmm.(ref_site).(site_fields{k}).(nested_fields{n}) = combined_data;
                            end
                        end
                        % Ensure X and Y are double
                        cllmm.(ref_site).(site_fields{k}).X = double(cllmm.(ref_site).(site_fields{k}).X);
                        cllmm.(ref_site).(site_fields{k}).Y = double(cllmm.(ref_site).(site_fields{k}).Y);
                    end
                end
                
                merge_log{end+1} = sprintf('Merged %s site %s into reference site %s', ...
                    input_files{file_idx, 2}, current_site, ref_site);
                site_matched = true;
                break;
            end
        end
        
        % Add as new site if no match found
        if ~site_matched
            cllmm.(current_site) = current_data.(current_site);
            % Convert Depth to double
            vars = fieldnames(cllmm.(current_site));
            for v = 1:length(vars)
                if isfield(cllmm.(current_site).(vars{v}), 'Depth')
                    cllmm.(current_site).(vars{v}).Depth = double(cllmm.(current_site).(vars{v}).Depth);
                end
                % Add conversion for X and Y
                if isfield(cllmm.(current_site).(vars{v}), 'X')
                    cllmm.(current_site).(vars{v}).X = double(cllmm.(current_site).(vars{v}).X);
                end
                if isfield(cllmm.(current_site).(vars{v}), 'Y')
                    cllmm.(current_site).(vars{v}).Y = double(cllmm.(current_site).(vars{v}).Y);
                end
            end
            merge_log{end+1} = sprintf('Added new %s site: %s', input_files{file_idx, 2}, current_site);
        end
    end
end

% Print merge log
fprintf('\nMerge Summary:\n');
fprintf('==============\n');
fprintf('%s\n', merge_log{:});

% Save merged structure
save('../../../../data/store/merged/cllmm_BC.mat', 'cllmm', '-v7.3');
