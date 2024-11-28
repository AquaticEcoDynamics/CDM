% Load input files
load('../../../../data/store/hydro/dew_WaterDataSA_hourly.mat');
load('../../../../data/store/ecology/wq_hchb_2024.mat');

% Initialize output structure
bc_inflow = struct();

% First, copy all dew sites to bc_inflow
dew_sites = fieldnames(dew);
for i = 1:length(dew_sites)
    bc_inflow.(dew_sites{i}) = dew.(dew_sites{i});
end

% Now process WQ sites
wq_sites = fieldnames(wqDataSA);

% Loop through each WQ site
for i = 1:length(wq_sites)
    current_wq_site = wq_sites{i};
    
    % Get first variable name to access X and Y
    wq_variables = fieldnames(wqDataSA.(current_wq_site));
    wq_X = wqDataSA.(current_wq_site).(wq_variables{1}).X;
    wq_Y = wqDataSA.(current_wq_site).(wq_variables{1}).Y;
    
    % Flag to track if site was matched
    site_matched = false;
    
    % Look for matching coordinates in dew structure
    for j = 1:length(dew_sites)
        current_dew_site = dew_sites{j};
        
        % Get first variable name to access X and Y
        dew_variables = fieldnames(dew.(current_dew_site));
        dew_X = dew.(current_dew_site).(dew_variables{1}).X;
        dew_Y = dew.(current_dew_site).(dew_variables{1}).Y;
        
        % Check if coordinates match
        if abs(wq_X - dew_X) < 1e-10 && abs(wq_Y - dew_Y) < 1e-10
            % Coordinates match - add WQ fields to existing site
            wq_fields = fieldnames(wqDataSA.(current_wq_site));
            
            % Add all fields from wq structure
            for k = 1:length(wq_fields)
                if ~isfield(bc_inflow.(current_dew_site), wq_fields{k})
                    bc_inflow.(current_dew_site).(wq_fields{k}) = ...
                        wqDataSA.(current_wq_site).(wq_fields{k});
                end
            end
            
            site_matched = true;
            break;
        end
    end
    
    % If no match found, create new site entry with WQ data
    if ~site_matched
        bc_inflow.(current_wq_site) = wqDataSA.(current_wq_site);
    end
end

% Save merged structure
save('../../../../data/store/merged/bc_inflow.mat', 'bc_inflow');
