function nc3to4(nc3File,nc4File, varargin)
%NC3TO4 Create a NetCDF4 classic Model file from an existing NetCDF 3 (classic) file.
%
%   NC3TONC4(NC3FILE, NC4FILE) creates a new NetCDF4 classic model file,
%   NC4FILE, from an existing NetCDF 3 (classic) file, NC3FILE.
%
%   NC3TONC4(NC3FILE, NC4FILE, DEFLATELEVEL) creates a new NetCDF4 classic
%   model file, NC4FILE, from an existing NetCDF 3 (classic) file,
%   NC3FILE. DEFLATELEVEL is a numeric value specifying the compression
%   setting for the deflate filter.  LEVEL should be between 0 (least) and
%   9 (most).
%   Note: The chunk size is selected automatically by the NetCDF library.
%
%   Example:
%       % Create a sample NetCDF 3 (classic) file, with very simple data
%       nccreate('nc3.nc','Ones',...
%                                 'Dimensions',{'r' 200 'c' 200},...
%                                 'Format','classic');
%       ncwrite('nc3.nc','Ones',ones(200));
%       finfo3 = dir('nc3.nc');
%       disp(['NetCDF 3 (Classic) size: ' num2str(finfo3.bytes)]);
%       % Conver to NetCDF4 Classic format.
%       nc3to4('nc3.nc','nc4.nc',9);
%       finfo4 = dir('nc4.nc');
%       disp(['NetCDF 4 (Classic model) size: ' num2str(finfo4.bytes)]);
%
%   See also ncdisp, ncread, ncwrite, ncwriteschema and netcdf

%   Copyright 2011 The MathWorks, Inc.

% Validate inputs
switch(length(varargin))
    case 0
        deflateLevel=[];
        
    case 1
        deflateLevel=varargin{1};
        
    otherwise
        error('nc3tonc4:invalidArgin',...
            'Incorrect number of input arguments.');
end

% Obtain the schema from the NetCDF 3 file.
ncFileSchema        = ncinfo(nc3File);
% Convert to a NetCDF 4 schema.
ncFileSchema.Format = 'netcdf4_classic';

% Set deflate filter, if specified.
if(deflateLevel)
    [ncFileSchema.Variables.DeflateLevel] = deal(deflateLevel);
end

% Creat the template for the NetCDF 4 file. This call will create the file,
% copy all attributes and *define* all the variables under the root group.
ncwriteschema(nc4File, ncFileSchema);

% Copy over the variable data.
for varInd = 1:length(ncFileSchema.Variables)
    varInfo = ncFileSchema.Variables(varInd);
    copyVariable(nc3File, nc4File, varInfo);
end

end

%--------------------------------------------------------------------------
function copyVariable(nc3File, nc4File, varInfo)
%copyVariable Copy a variable from source file to destination file
%
%    COPYVARIABLE(NC3FILE, NC4FILE, VARNAME) copy the data from the
%    variable VARNAME in NC3FILE to the variable in NC4FILE. The variable
%    should already be defined in NC4FILE.

% TODO - Use variable subsetting in case varData is too large to fit in
% local memory.

varName = varInfo.Name;

varData = ncread(nc3File, varName);
ncwrite(nc4File, varName, varData);

end