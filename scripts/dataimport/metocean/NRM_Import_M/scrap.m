% Function to get NRMAWS data
siteName = 'Narrung'; % Use NRMAWSStationNames() to see available sites
theyear = '2021';
startDate = [theyear '-01-01'];
endDate = [theyear '-12-31'];

data = NRMAWSData(siteName, startDate, endDate);
writetable(data, [siteName '_' theyear '.csv'], 'Delimiter', ',');

% Plotting with MATLAB requires additional code, as MATLAB has its own plotting syntax.
% Here's an example of how you can plot the 'Wind Speed_average_km/h' column using MATLAB's plot function:
plot(data.time, data.Wind_Speed_average_km_h);
xlabel('Time');
ylabel('Wind Speed (km/h)');
title('Wind Speed Data');


function data = NRMAWSData(siteName, startDate, endDate)
    email = 'Matt.Gibbs@sa.gov.au';
    pw = '3ijOGslFtK';

    % Authentication
    authUrl = 'https://api.awsnetwork.com.au/v3/auth/login';
    authData = struct('email', email, 'password', pw);
    options = weboptions('MediaType', 'application/json');
    response = webwrite(authUrl, authData, options);
    token = response.token;

    % Get sensor groups
    sensorGroupsUrl = 'https://api.awsnetwork.com.au/v3/sensor-groups';
    options = weboptions('HeaderFields', {'Authorization', ['Bearer ' token]});
    response = webread(sensorGroupsUrl, options);
    sensorGroups = response.data;
    station = find(strcmp({sensorGroups.stationName}, siteName) & strcmp({sensorGroups.name}, '15 minute data'));
    id = sensorGroups(station).id;
    % Get sensors
    sensorsUrl = ['https://api.awsnetwork.com.au/v3/sensor-groups/' num2str(id) '/sensors'];
    
    
    response = webread(sensorsUrl, options);
    sensors = response.data;

    % Get actual data
    data = [];
    for i = 1:length(sensors)
        sensorId = sensors(i).id;
        url = ['https://api.awsnetwork.com.au/v3/sensors/' num2str(sensorId) '/readings?start=' startDate '&end=' endDate '&perPage=1000000&page=1'];
        
        url
        
        response = webread(url, options);
        response
        data = [data response.data];
        
    end

    % Format data
    data = struct2table(data);
    data = removevars(data, {'sensorTypeId', 'timezone'});
    data.name = strcat(data.name, '_', data.type, '_', data.unit);
    data.time = datetime(data.time, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSS', 'TimeZone', 'UTC');
    data.value = str2double(data.value);
    data = unstack(data, 'value', 'name');
end

% Function to get NRMAWS station names
function stationNames = NRMAWSStationNames()
    email = 'Matt.Gibbs@sa.gov.au';
    pw = '3ijOGslFtK';

    % Authentication
    authUrl = 'https://api.awsnetwork.com.au/v3/auth/login';
    authData = struct('email', email, 'password', pw);
    options = weboptions('MediaType', 'application/json');
    response = webwrite(authUrl, authData, options);
    token = response.x.token;

    % Get sensor groups
    sensorGroupsUrl = 'https://api.awsnetwork.com.au/v3/sensor-groups';
    options = weboptions('HeaderFields', {'Authorization', ['Bearer ' token]});
    response = webread(sensorGroupsUrl, options);
    sensorGroups = response.data;

    stationNames = {sensorGroups([sensorGroups.name] == "15 minute data").stationName};
end


