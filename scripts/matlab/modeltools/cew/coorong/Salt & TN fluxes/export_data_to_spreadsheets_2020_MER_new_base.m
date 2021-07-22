clear all; close all;

outdir = './Spreadsheets_new_Base_2017_2019/';

if ~exist(outdir,'dir')
    mkdir(outdir);
end

sheet_names = {'mean.csv'};

vars = {...
    'SAL',...
    'WQ_NIT_AMM',...
    'WQ_NIT_NIT',...
    'WQ_PHS_FRP',...
    'WQ_SIL_RSI',...
    'WQ_OGM_PON',...
    'WQ_OGM_DON',...
    'WQ_OGM_POP',...
    'WQ_OGM_DOP',...
    'WQ_DIAG_PHY_TCHLA',...
    };

shp = shaperead('C:\Users\00064235\CWorkFolder\github\Lowerlakes-CEW\matlab\lowerlakes\Domain Wide PreProcessing\CEWH_Reporting.shp');

%%
%points = [3];

%point_names = {'C5 - Murray Mouth'};
point_names = {'Mouth','North_L','South_L'};
% ncfile='Z:\Busch\Studysites\Lowerlakes\Ruppia\MER_Coorong_eWater_2020_v1\Output\MER_Scen1_20170701_20200701.nc';


salt_conv = 1;%1000 / 0.56;
oxy_conv = 32/1000;
facs=[1 14/1000 14/1000 31/1000 28.1/1000 14/1000 14/1000 31/1000 31/1000 1];
%__________________________________________________________________________


for i= 1:length(vars)
    
    disp(vars{i});
    for j=1:length(point_names)
        findir=['exported_MER_Base\',point_names{j},'\'];
        D=load([findir,'D.mat']);
        D2=D.savedata.D;
        t0=D.savedata.Time;
        
        data=load([findir,vars{i},'.mat']);
        
        tmp=data.savedata.(vars{i});
        inc=1;
        for k=1:size(D2,2)
            indtmp1=D2(:,k);
            indtmp2=find(indtmp1>0.1);
            avetmp(inc)=mean(tmp(indtmp2,k));
            inc=inc+1;
        end
        
        t1=datenum(2017,7,1);
        t2=datenum(2018,7,1);
        ind1=find(abs(t0-t1)==min(abs(t0-t1)));
        ind2=find(abs(t0-t2)==min(abs(t0-t2)));
        
        avetmp1=avetmp(ind1:ind2);
        
        outputdata11(i,j)=mean(avetmp1)*facs(i);
        %  tmp2=mean(tmp,1);
       % tmp3=sort(avetmp1);
        outputdata21(i,j)=median(avetmp1)*facs(i);
        
        t1=datenum(2018,7,1);
        t2=datenum(2019,7,1);
        ind1=find(abs(t0-t1)==min(abs(t0-t1)));
        ind2=find(abs(t0-t2)==min(abs(t0-t2)));
        
        avetmp2=avetmp(ind1:ind2);
        
        outputdata12(i,j)=mean(avetmp2)*facs(i);
        %  tmp2=mean(tmp,1);
       % tmp3=sort(avetmp);
        outputdata22(i,j)=median(avetmp2)*facs(i);
        
        t1=datenum(2019,7,1);
        t2=datenum(2020,7,1);
        ind1=find(abs(t0-t1)==min(abs(t0-t1)));
        ind2=find(abs(t0-t2)==min(abs(t0-t2)));
        
        avetmp3=avetmp(ind1:ind2);
        
        outputdata13(i,j)=mean(avetmp3)*facs(i);
        %  tmp2=mean(tmp,1);
       % tmp3=sort(avetmp);
        outputdata23(i,j)=median(avetmp3)*facs(i);
        
                t1=datenum(2017,7,1);
        t2=datenum(2019,7,1);
        ind1=find(abs(t0-t1)==min(abs(t0-t1)));
        ind2=find(abs(t0-t2)==min(abs(t0-t2)));
        
        avetmp4=avetmp(ind1:ind2);
        
        outputdata14(i,j)=mean(avetmp4)*facs(i);
        outputdata24(i,j)=median(avetmp4)*facs(i);
        
    end
end

%%


for i = 1:length(sheet_names)
    
    fid = fopen([outdir,sheet_names{i}],'wt');
    
    % Header
    fprintf(fid,'%s\n','Site,SAL,WQ_NIT_AMM,WQ_NIT_NIT,WQ_PHS_FRP,WQ_SIL_RSI,WQ_OGM_PON,WQ_OGM_POP,WQ_DIAG_PHY_TCHLA');
    
    
    for jj=1:length(point_names)
        fprintf(fid,'%s',point_names{jj});
        for ii = 1:length(vars)
            fprintf(fid,',%6.4f',outputdata11(ii,jj));
        end
        fprintf(fid,'%s\n','');
        
        for ii = 1:length(vars)
            fprintf(fid,',%6.4f',outputdata12(ii,jj));
        end
        fprintf(fid,'%s\n','');
        
        for ii = 1:length(vars)
            fprintf(fid,',%6.4f',outputdata13(ii,jj));
        end
        fprintf(fid,'%s\n','');
        
        for ii = 1:length(vars)
            fprintf(fid,',%6.4f',outputdata14(ii,jj));
        end
        fprintf(fid,'%s\n','');
    end
    
end

fclose(fid);

fid = fopen([outdir,'median.csv'],'wt');

% Header
fprintf(fid,'%s\n','Site,SAL,WQ_NIT_AMM,WQ_NIT_NIT,WQ_PHS_FRP,WQ_SIL_RSI,WQ_OGM_PON,WQ_OGM_DON,WQ_OGM_POP,WQ_OGM_DOP,WQ_DIAG_PHY_TCHLA');


for jj=1:length(point_names)
    fprintf(fid,'%s',point_names{jj});
    for ii = 1:length(vars)
        fprintf(fid,',%6.4f',outputdata21(ii,jj));
    end
    fprintf(fid,'%s\n','');
    
    for ii = 1:length(vars)
        fprintf(fid,',%6.4f',outputdata22(ii,jj));
    end
    fprintf(fid,'%s\n','');
    
    for ii = 1:length(vars)
        fprintf(fid,',%6.4f',outputdata23(ii,jj));
    end
    fprintf(fid,'%s\n','');
    
    for ii = 1:length(vars)
        fprintf(fid,',%6.4f',outputdata24(ii,jj));
    end
    fprintf(fid,'%s\n','');
end

fclose(fid);
