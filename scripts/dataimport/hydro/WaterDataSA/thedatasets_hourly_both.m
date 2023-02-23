%header = 'https://water.data.sa.gov.au/Export/BulkExport?DateRange=EntirePeriodOfRecord&TimeZone=9.5&Calendar=CALENDARYEAR&Interval=Hourly&Step=1&ExportFormat=csv&TimeAligned=True&RoundData=False&IncludeGradeCodes=False&IncludeApprovalLevels=False&IncludeInterpolationTypes=False&Datasets[0].DatasetName=';

header = 'https://water.data.sa.gov.au/Export/BulkExport?DateRange=Days7&TimeZone=9.5&Calendar=CALENDARYEAR&Interval=Hourly&Step=1&ExportFormat=csv&TimeAligned=True&RoundData=False&IncludeGradeCodes=False&IncludeApprovalLevels=False&IncludeInterpolationTypes=False&Datasets[0].DatasetName=';

%Days7
% Master list of the strings required.

i = 1;

dataset(i).Name = {'AIRTEMP','Air%20Temp.Best%20Available--Continuous%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=169'}; i = i+1;




%Air Temp__________________________
dataset(i).Name = {'AIRTEMP','Air%20Temp.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169'}; i = i+1;
dataset(i).Name = {'AIRPRESSURE','Atmos%20Pres.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=145'}; i = i+1;
dataset(i).Name = {'RELHUM','Rel%20Humidity.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=152'}; i = i+1;
dataset(i).Name = {'SOLRAD','Solar%20Rad%20Intensity.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=139'}; i = i+1;




%Temp______________________________________________________
dataset(i).Name = {'TEMP_BOTTOM','Water%20Temp.Best%20Available--Sensor%20near%20bed%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169&_=1628810983605'}; i = i+1;
dataset(i).Name = {'TEMP_SURFACE','Water%20Temp.Best%20Available--Sensor%20near%20surface%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169&_=1628810897780'}; i = i+1;


%dataset(i).Name = {'TEMP_Bottom','Water%20Temp.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169&_=1628812025608'};i = i+1;
dataset(i).Name = {'TEMP','Water%20Temp.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169'}; i = i+1;
dataset(i).Name = {'TEMP_Master','Water%20Temp.Master%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169'}; i = i+1;
%dataset(i).Name = {'TEMP','Water%20Temp.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169'}; i = i+1;

%EC______________________________________________________
dataset(i).Name = {'COND_SURFACE','EC%20Corr.Master--Sensor%20near%20bed%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=45&_=1628811029492'}; i = i+1;					
dataset(i).Name = {'COND_BOTTOM','EC%20Corr.Master--Sensor%20near%20surface%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=45'}; i = i+1;
dataset(i).Name = {'COND','EC%20Corr.Best%20Available%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=45'}; i = i+1;



%Velocity
dataset(i).Name = {'Velocity','Water%20Velocity.Telem--Mean%20X%20Section%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=185'}; i = i+1;

%Level______________________________________________________

%dataset(i).Name = {'LEVEL','Water%20Level.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=82&_=1628817128812'};i = i+1;
dataset(i).Name = {'LEVEL','Lake%20Level.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=82'}; i = i+1;
dataset(i).Name = {'LEVEL','Water%20Level.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=82'}; i = i+1;

dataset(i).Name = {'LEVEL','Tide%20Height.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=82'}; i = i+1;
dataset(i).Name = {'LEVEL','Water%20Level.Master--Daily%20Read%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=82'}; i = i+1;

%pH_____________________________________________________
dataset(i).Name = {'WQ_CAR_PH','pH.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=133'}; i = i+1;
%dataset(i).Name = {'pH','pH.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=133'}; i = i+1;

%Flow______________________________________________________
dataset(i).Name = {'FLOW','Discharge.Best%20Available%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=239'};i = i+1;
dataset(i).Name = {'FLOW','Discharge.Telem--ML%2Fday%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=241'};i = i+1;
dataset(i).Name = {'FLOW','Discharge.Master--Daily%20Read--ML%2Fday%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=239'};i = i+1;
dataset(i).Name = {'FLOW','Discharge.Best%20Available%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=239'};i = i+1;





dataset(i).Name = {'WQ_DIAG_TOT_TDS',  'TDS%20from%20EC.Calculated%20from%20Corrected%20EC%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=35'}; i = i+1;

%Turbidity
dataset(i).Name = {'WQ_DIAG_TOT_TURBIDITY_SONDE','Turbidity%20Corr.Best%20Available--Corrected%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=13'}; i = i+1;
dataset(i).Name = {'WQ_DIAG_TOT_TURBIDITY_SONDE','Turbidity%20Corr.Best%20Available--Sonde%20sensor%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=13'}; i = i+1;
dataset(i).Name = {'WQ_DIAG_TOT_TURBIDITY_SONDE','Turbidity%20Corr.Telem--Sonde%20Sensor%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=13'}; i = i+1;
dataset(i).Name = {'WQ_DIAG_TOT_TURBIDITY_SONDE','Turbidity%20Corr.Best%20Available--Corrected%40','Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=13'}; i = i+1;

%SONDE______________________________________________________
dataset(i).Name = {'WQ_PHY_BGA_SONDE','BGA_PE.Best%20Available--Sonde%20sensor%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=43'}; i = i+1;
dataset(i).Name = {'WQ_DIAG_TOT_TCHLA_SONDE','Chlorophyll%20A.Best%20Available--Sonde%20sensor%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=43'}; i = i+1;

dataset(i).Name = {'WQ_OXY_OXY_SAT_SONDE','Dis%20Oxygen%20Sat.Best%20Available--Sonde%20sensor%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=152'}; i = i+1;
dataset(i).Name = {'WQ_OXY_OXY_SAT_SONDE','Dis%20Oxygen%20Sat.Telem--Sonde%20Sensor%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=152'}; i = i+1;

dataset(i).Name = {'WQ_OXY_OXY_SONDE','O2%20(Dis).Best%20Available--Sonde%20sensor%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=41'}; i = i+1;
dataset(i).Name = {'WQ_OXY_OXY_SONDE','O2%20(Dis).Telem--Sonde%20Sensor%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=35'}; i = i+1;

dataset(i).Name = {'WQ_CAR_PH_SONDE','pH.Best%20Available--Sonde%20sensor%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=133'}; i = i+1;
dataset(i).Name = {'WQ_CAR_PH','pH.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=133'}; i = i+1;
dataset(i).Name = {'WQ_CAR_PH_SONDE','pH.Telem--Sonde%20Sensor%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=133'}; i = i+1;

dataset(i).Name = {'TEMP_SONDE','Water%20Temp.Best%20Available--Sonde%20Sensor%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169'}; i = i+1;


dataset(i).Name = {'fDOM_SONDE','fDOM.Telem--Sonde%20Sensor%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=74'}; i = i+1;
%WIND____________________________________________________
dataset(i).Name = {'WIND_DIR','Wind%20Dir.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=52'}; i = i+1;
dataset(i).Name = {'WIND_SPEED','Wind%20Vel.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=185'}; i = i+1;


%Air Temp__________________________
dataset(i).Name = {'AIRTEMP','Air%20Temp.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169'}; i = i+1;
dataset(i).Name = {'AIRPRESSURE','Atmos%20Pres.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=145'}; i = i+1;
dataset(i).Name = {'RELHUM','Rel%20Humidity.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=152'}; i = i+1;
dataset(i).Name = {'SOLRAD','Solar%20Rad%20Intensity.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=139'}; i = i+1;




%Temp______________________________________________________
dataset(i).Name = {'TEMP_BOTTOM','Water%20Temp.Best%20Available--Sensor%20near%20bed%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169&_=1628810983605'}; i = i+1;
dataset(i).Name = {'TEMP_SURFACE','Water%20Temp.Best%20Available--Sensor%20near%20surface%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169&_=1628810897780'}; i = i+1;


%dataset(i).Name = {'TEMP_Bottom','Water%20Temp.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169&_=1628812025608'};i = i+1;
dataset(i).Name = {'TEMP','Water%20Temp.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169'}; i = i+1;
dataset(i).Name = {'TEMP_Master','Water%20Temp.Master%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169'}; i = i+1;
%dataset(i).Name = {'TEMP','Water%20Temp.Best%20Available--Continuous%40','&Datasets[0].Calculation=Aggregate&Datasets[0].UnitId=169'}; i = i+1;

%EC______________________________________________________
dataset(i).Name = {'COND_SURFACE','EC%20Corr.Master--Sensor%20near%20bed%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=45&_=1628811029492'}; i = i+1;					
dataset(i).Name = {'COND_BOTTOM','EC%20Corr.Master--Sensor%20near%20surface%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=45'}; i = i+1;
dataset(i).Name = {'COND','EC%20Corr.Best%20Available%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=45'}; i = i+1;



%Velocity
dataset(i).Name = {'Velocity','Water%20Velocity.Telem--Mean%20X%20Section%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=185'}; i = i+1;

%Level______________________________________________________

%dataset(i).Name = {'LEVEL','Water%20Level.Best%20Available--Continuous%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=82&_=1628817128812'};i = i+1;
dataset(i).Name = {'LEVEL','Lake%20Level.Best%20Available--Continuous%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=82'}; i = i+1;
dataset(i).Name = {'LEVEL','Water%20Level.Best%20Available--Continuous%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=82'}; i = i+1;

dataset(i).Name = {'LEVEL','Tide%20Height.Best%20Available--Continuous%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=82'}; i = i+1;
dataset(i).Name = {'LEVEL','Water%20Level.Master--Daily%20Read%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=82'}; i = i+1;

%pH_____________________________________________________
dataset(i).Name = {'WQ_CAR_PH','pH.Best%20Available--Continuous%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=133'}; i = i+1;
%dataset(i).Name = {'pH','pH.Best%20Available--Continuous%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=133'}; i = i+1;

%Flow______________________________________________________
dataset(i).Name = {'FLOW','Discharge.Best%20Available%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=239'};i = i+1;
dataset(i).Name = {'FLOW','Discharge.Telem--ML%2Fday%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=241'};i = i+1;
dataset(i).Name = {'FLOW','Discharge.Master--Daily%20Read--ML%2Fday%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=239'};i = i+1;
dataset(i).Name = {'FLOW','Discharge.Best%20Available%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=239'};i = i+1;





dataset(i).Name = {'WQ_DIAG_TOT_TDS',  'TDS%20from%20EC.Calculated%20from%20Corrected%20EC%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=35'}; i = i+1;

%Turbidity
dataset(i).Name = {'WQ_DIAG_TOT_TURBIDITY_SONDE','Turbidity%20Corr.Best%20Available--Corrected%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=13'}; i = i+1;
dataset(i).Name = {'WQ_DIAG_TOT_TURBIDITY_SONDE','Turbidity%20Corr.Best%20Available--Sonde%20sensor%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=13'}; i = i+1;
dataset(i).Name = {'WQ_DIAG_TOT_TURBIDITY_SONDE','Turbidity%20Corr.Telem--Sonde%20Sensor%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=13'}; i = i+1;
dataset(i).Name = {'WQ_DIAG_TOT_TURBIDITY_SONDE','Turbidity%20Corr.Best%20Available--Corrected%40','Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=13'}; i = i+1;

%SONDE______________________________________________________
dataset(i).Name = {'WQ_PHY_BGA_SONDE','BGA_PE.Best%20Available--Sonde%20sensor%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=43'}; i = i+1;
dataset(i).Name = {'WQ_DIAG_TOT_TCHLA_SONDE','Chlorophyll%20A.Best%20Available--Sonde%20sensor%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=43'}; i = i+1;

dataset(i).Name = {'WQ_OXY_OXY_SAT_SONDE','Dis%20Oxygen%20Sat.Best%20Available--Sonde%20sensor%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=152'}; i = i+1;
dataset(i).Name = {'WQ_OXY_OXY_SAT_SONDE','Dis%20Oxygen%20Sat.Telem--Sonde%20Sensor%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=152'}; i = i+1;

dataset(i).Name = {'WQ_OXY_OXY_SONDE','O2%20(Dis).Best%20Available--Sonde%20sensor%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=41'}; i = i+1;
dataset(i).Name = {'WQ_OXY_OXY_SONDE','O2%20(Dis).Telem--Sonde%20Sensor%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=35'}; i = i+1;

dataset(i).Name = {'WQ_CAR_PH_SONDE','pH.Best%20Available--Sonde%20sensor%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=133'}; i = i+1;
dataset(i).Name = {'WQ_CAR_PH','pH.Best%20Available--Continuous%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=133'}; i = i+1;
dataset(i).Name = {'WQ_CAR_PH_SONDE','pH.Telem--Sonde%20Sensor%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=133'}; i = i+1;

dataset(i).Name = {'TEMP_SONDE','Water%20Temp.Best%20Available--Sonde%20Sensor%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=169'}; i = i+1;


dataset(i).Name = {'fDOM_SONDE','fDOM.Telem--Sonde%20Sensor%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=74'}; i = i+1;
%WIND____________________________________________________
dataset(i).Name = {'WIND_DIR','Wind%20Dir.Best%20Available--Continuous%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=52'}; i = i+1;
dataset(i).Name = {'WIND_SPEED','Wind%20Vel.Best%20Available--Continuous%40','&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=185'}; i = i+1;