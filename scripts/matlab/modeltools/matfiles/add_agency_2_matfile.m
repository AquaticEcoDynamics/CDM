clear all; close all;

load coorong.mat;

[~,sstr] = xlsread('Agency_Info.csv','A2:B10000');

sites = fieldnames(coorong);

for i = 1:length(sites)
    vars = fieldnames(coorong.(sites{i}));
    
    sss = find(strcmpi(sstr(:,1),sites{i}) == 1);
    if isempty(sss)
        stop;
    end
    for j = 1:length(vars)
        coorong.(sites{i}).(vars{j}).Agency = sstr{sss,2};
    end
end

coorong.A4261123.WQ_DIAG_TOT_TURBIDITY.Agency = 'DEW SONDE';	
coorong.A4261134.WQ_DIAG_TOT_TURBIDITY.Agency = 'DEW SONDE';	
coorong.A4261135.WQ_DIAG_TOT_TURBIDITY.Agency = 'DEW SONDE';	
coorong.A4260633.WQ_DIAG_TOT_TURBIDITY.Agency = 'DEW SONDE';	
coorong.A4261209.WQ_DIAG_TOT_TURBIDITY.Agency = 'DEW SONDE';	
coorong.A4261165.WQ_DIAG_TOT_TURBIDITY.Agency = 'DEW SONDE';




save coorong.mat coorong -mat;

load lowerlakes.mat;

[~,sstr] = xlsread('Agency_Info.csv','A2:B10000');

sites = fieldnames(lowerlakes);

for i = 1:length(sites)
    vars = fieldnames(lowerlakes.(sites{i}));
    
    sss = find(strcmpi(sstr(:,1),sites{i}) == 1);
    if isempty(sss)
        stop;
    end
    for j = 1:length(vars)
        lowerlakes.(sites{i}).(vars{j}).Agency = sstr{sss,2};
    end
end

lowerlakes.A4261123.WQ_DIAG_TOT_TURBIDITY.Agency = 'DEW SONDE';	
lowerlakes.A4261134.WQ_DIAG_TOT_TURBIDITY.Agency = 'DEW SONDE';	
lowerlakes.A4261135.WQ_DIAG_TOT_TURBIDITY.Agency = 'DEW SONDE';	
lowerlakes.A4260633.WQ_DIAG_TOT_TURBIDITY.Agency = 'DEW SONDE';	
lowerlakes.A4261209.WQ_DIAG_TOT_TURBIDITY.Agency = 'DEW SONDE';	
lowerlakes.A4261165.WQ_DIAG_TOT_TURBIDITY.Agency = 'DEW SONDE';


save lowerlakes.mat lowerlakes -mat;