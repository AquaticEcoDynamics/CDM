clear; close all;

scenario = {...   
    'hchb_Gen2_201707_202201_all',...
    'hchb_Gen2_201707_202201_noeWater_all',...
    'hchb_Gen2_201707_202201_noSE_all',...
    'hchb_Gen2_201707_202201_scen3a_all',...
    'hchb_Gen2_201707_202201_scen3b_all',...
    };

 year_array = 2018:2021; %:2019;


% shp=shaperead('C:\Users\00101765\OneDrive - The University of Western Australia\Matlab\CIIP\GIS\Coorong_regions_001_R.shp');    %shapefile that contains the north ocean area of coorong - which is to be excluded from area calculation
shpN = shaperead('C:\Users\00101765\AED Dropbox\AED_Coorong_db\7_hchb\Ruppia\GIS\ExtendedNorth3_Merge.shp');
shpS = shaperead('C:\Users\00101765\AED Dropbox\AED_Coorong_db\7_hchb\Ruppia\GIS\ExtendedSouth_Merge.shp');

for n = 1:length(scenario)
    
    %load geo.mat;
    ncfile=['D:\HCHB_GEN2_4yrs_20220620_v2\hchb_Gen2_201707_202201_all.nc'];
    dat = tfv_readnetcdf(ncfile,'timestep',1);
    cell_A=dat.cell_A; %cell area
    cellx=dat.cell_X;
    celly=dat.cell_Y;
%     inpol_N=inpolygon(cellx,celly,shp(3).X,shp(3).Y); %north lagoon
%     inpol_S=inpolygon(cellx,celly,shp(1).X,shp(1).Y); %south lagoon
    inpol_N=inpolygon(cellx,celly,shpN.X, shpN.Y); %north lagoon
    inpol_S=inpolygon(cellx,celly,shpS.X, shpS.Y); %south lagoon
    
%     if scenario{n}(end-20:end-17) == num2str(2013)
%         year_array = 2013:2015;
%     else
%         year_array = 2016:2018;
%     end
    
    for j=1:length(year_array)
        %         for m = 1:length(stage)
        
        infile= ['D:\HCHB_GEN2_4yrs_20220620_v2\Plotting_Ruppia\'];
        dataHSI0=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\HSI_sexual.mat']);
        dataHSI1=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\1_adult_new\HSI_adult.mat']);
        dataHSI2=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\2_flower_new\HSI_flower.mat']);
        dataHSI3=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\3_seed_new\HSI_seed.mat']);
        dataHSI4=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\4_turion_new\HSI_turion.mat']);
        dataHSI5=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\5_sprout_new\HSI_sprout.mat']);
        dataHSI6=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\6_viability\HSI_turionviability.mat']);
        dataHSI7=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\HSI_asexual.mat']);
        dataHSI8=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\HSI_germ_spr_adt.mat']);
        
        data0=dataHSI0.min_cdata;
        data1=dataHSI1.min_cdata;
        data2=dataHSI2.min_cdata;
        data3=dataHSI3.min_cdata;
        data4=dataHSI4.min_cdata;
        data5=dataHSI5.min_cdata;
        data6=dataHSI6.min_cdata;
        data7=dataHSI7.min_cdata;
        data8=dataHSI8.min_cdata;
        
        tarea0_N=0;
        tarea1_N=0;
        tarea2_N=0;
        tarea3_N=0;
        tarea4_N=0;
        tarea5_N=0;
        tarea6_N=0;
        tarea7_N=0;
        tarea8_N=0;
        tarea0_S=0;
        tarea1_S=0;
        tarea2_S=0;
        tarea3_S=0;
        tarea4_S=0;
        tarea5_S=0;
        tarea6_S=0;
        tarea7_S=0;
        tarea8_S=0;
        
        for cc=1:size(data0,1) %for all HSI
            if inpol_N(cc) %if it's  in polygon
                if data0(cc)<=0.5
                    tarea0_N=tarea0_N+0; %if HSI<0.5, area deemed unsuitable
                elseif data0(cc)>0.5
                    tarea0_N=tarea0_N+data0(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data1,1) %for all HSI
            if inpol_N(cc) %if it's  in polygon
                if data1(cc)<=0.5
                    tarea1_N=tarea1_N+0; %if HSI<0.5, area deemed unsuitable
                elseif data1(cc)>0.5
                    tarea1_N=tarea1_N+data1(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data2,1) %for all HSI
            if inpol_N(cc) %if it's  in polygon
                if data2(cc)<=0.5
                    tarea2_N=tarea2_N+0; %if HSI<0.5, area deemed unsuitable
                elseif data2(cc)>0.5
                    tarea2_N=tarea2_N+data2(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data3,1) %for all HSI
            if inpol_N(cc) %if it's  in polygon
                if data3(cc)<=0.5
                    tarea3_N=tarea3_N+0; %if HSI<0.5, area deemed unsuitable
                elseif data3(cc)>0.5
                    tarea3_N=tarea3_N+data3(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data4,1) %for all HSI
            if inpol_N(cc) %if it's  in polygon
                if data4(cc)<=0.5
                    tarea4_N=tarea4_N+0; %if HSI<0.5, area deemed unsuitable
                elseif data4(cc)>0.5
                    tarea4_N=tarea4_N+data4(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data5,1) %for all HSI
            if inpol_N(cc) %if it's  in polygon
                if data5(cc)<=0.5
                    tarea5_N=tarea5_N+0; %if HSI<0.5, area deemed unsuitable
                elseif data5(cc)>0.5
                    tarea5_N=tarea5_N+data5(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data6,1) %for all HSI
            if inpol_N(cc) %if it's  in polygon
                if data6(cc)<=0.5
                    tarea6_N=tarea6_N+0; %if HSI<0.5, area deemed unsuitable
                elseif data6(cc)>0.5
                    tarea6_N=tarea6_N+data6(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data7,1) %for all HSI
            if inpol_N(cc) %if it's  in polygon
                if data7(cc)<=0.5
                    tarea7_N=tarea7_N+0; %if HSI<0.5, area deemed unsuitable
                elseif data7(cc)>0.5
                    tarea7_N=tarea7_N+data7(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data8,1) %for all HSI
            if inpol_N(cc) %if it's  in polygon
                if data8(cc)<=0.5
                    tarea8_N=tarea8_N+0; %if HSI<0.5, area deemed unsuitable
                elseif data8(cc)>0.5
                    tarea8_N=tarea8_N+data8(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end       
        
        yearlyareaRuppia_sexual_N.(scenario{n}).(['year_',num2str(year_array(j))])=tarea0_N/1e6; %convert area m2 to km2
        yearlyareaRuppia_adult_N.(scenario{n}).(['year_',num2str(year_array(j))])=tarea1_N/1e6;
        yearlyareaRuppia_flower_N.(scenario{n}).(['year_',num2str(year_array(j))])=tarea2_N/1e6;
        yearlyareaRuppia_seed_N.(scenario{n}).(['year_',num2str(year_array(j))])=tarea3_N/1e6;
        yearlyareaRuppia_turion_N.(scenario{n}).(['year_',num2str(year_array(j))])=tarea4_N/1e6; 
        yearlyareaRuppia_sprout_N.(scenario{n}).(['year_',num2str(year_array(j))])=tarea5_N/1e6;
        yearlyareaRuppia_viability_N.(scenario{n}).(['year_',num2str(year_array(j))])=tarea6_N/1e6;
        yearlyareaRuppia_asexual_N.(scenario{n}).(['year_',num2str(year_array(j))])=tarea7_N/1e6;
        yearlyareaRuppia_germspradt_N.(scenario{n}).(['year_',num2str(year_array(j))])=tarea8_N/1e6;
        
        
        for cc=1:size(data0,1) %for all HSI
            if inpol_S(cc) %if it's  in polygon
                if data0(cc)<=0.5
                    tarea0_S=tarea0_S+0; %if HSI<0.5, area deemed unsuitable
                elseif data0(cc)>0.5
                    tarea0_S=tarea0_S+data0(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data1,1) %for all HSI
            if inpol_S(cc) %if it's  in polygon
                if data1(cc)<=0.5
                    tarea1_S=tarea1_S+0; %if HSI<0.5, area deemed unsuitable
                elseif data1(cc)>0.5
                    tarea1_S=tarea1_S+data1(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data2,1) %for all HSI
            if inpol_S(cc) %if it's  in polygon
                if data2(cc)<=0.5
                    tarea2_S=tarea2_S+0; %if HSI<0.5, area deemed unsuitable
                elseif data2(cc)>0.5
                    tarea2_S=tarea2_S+data2(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data3,1) %for all HSI
            if inpol_S(cc) %if it's  in polygon
                if data3(cc)<=0.5
                    tarea3_S=tarea3_S+0; %if HSI<0.5, area deemed unsuitable
                elseif data3(cc)>0.5
                    tarea3_S=tarea3_S+data3(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        for cc=1:size(data4,1) %for all HSI
            if inpol_S(cc) %if it's  in polygon
                if data4(cc)<=0.5
                    tarea4_S=tarea4_S+0; %if HSI<0.5, area deemed unsuitable
                elseif data4(cc)>0.5
                    tarea4_S=tarea4_S+data4(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data5,1) %for all HSI
            if inpol_S(cc) %if it's  in polygon
                if data5(cc)<=0.5
                    tarea5_S=tarea5_S+0; %if HSI<0.5, area deemed unsuitable
                elseif data5(cc)>0.5
                    tarea5_S=tarea5_S+data5(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data6,1) %for all HSI
            if inpol_S(cc) %if it's  in polygon
                if data6(cc)<=0.5
                    tarea6_S=tarea6_S+0; %if HSI<0.5, area deemed unsuitable
                elseif data6(cc)>0.5
                    tarea6_S=tarea6_S+data6(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data7,1) %for all HSI
            if inpol_S(cc) %if it's  in polygon
                if data7(cc)<=0.5
                    tarea7_S=tarea7_S+0; %if HSI<0.5, area deemed unsuitable
                elseif data7(cc)>0.5
                    tarea7_S=tarea7_S+data7(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        for cc=1:size(data8,1) %for all HSI
            if inpol_S(cc) %if it's  in polygon
                if data8(cc)<=0.5
                    tarea8_S=tarea8_S+0; %if HSI<0.5, area deemed unsuitable
                elseif data8(cc)>0.5
                    tarea8_S=tarea8_S+data8(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                end
            end
        end
        
        
        yearlyareaRuppia_sexual_S.(scenario{n}).(['year_',num2str(year_array(j))])=tarea0_S/1e6; %convert area m2 to km2
        yearlyareaRuppia_adult_S.(scenario{n}).(['year_',num2str(year_array(j))])=tarea1_S/1e6;
        yearlyareaRuppia_flower_S.(scenario{n}).(['year_',num2str(year_array(j))])=tarea2_S/1e6;
        yearlyareaRuppia_seed_S.(scenario{n}).(['year_',num2str(year_array(j))])=tarea3_S/1e6;
        yearlyareaRuppia_turion_S.(scenario{n}).(['year_',num2str(year_array(j))])=tarea4_S/1e6; 
        yearlyareaRuppia_sprout_S.(scenario{n}).(['year_',num2str(year_array(j))])=tarea5_S/1e6;
        yearlyareaRuppia_viability_S.(scenario{n}).(['year_',num2str(year_array(j))])=tarea6_S/1e6;
        yearlyareaRuppia_asexual_S.(scenario{n}).(['year_',num2str(year_array(j))])=tarea7_S/1e6;
        yearlyareaRuppia_germspradt_S.(scenario{n}).(['year_',num2str(year_array(j))])=tarea8_S/1e6;
        
    end
end


%%



%     %%%%%%%%%%%%%%%%trial
% 
fileID = fopen([infile,'\yearlyarea_NS.csv'],'w'); %w is to make a new workbook, 'a' is to append
fprintf(fileID,'%s\n','Year,stage,Basecase,NoeWater,NoSE,Designed,NoBarrage'); %s-character vector, n- start a new line

for j=1:length(year_array)
    fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual_N');
    %         fprintf(fileID,'%s\n',' ,sexual');    
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,adult_N');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_adult_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,flower_N');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_flower_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,seed_N');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,turion_N');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_turion_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,sprout_N');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_sprout_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,viability_N');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_viability_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual_N');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,germspradt_N');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_germspradt_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual_S');
    %         fprintf(fileID,'%s\n',' ,sexual');    
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,adult_S');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_adult_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,flower_S');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_flower_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,seed_S');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
       fprintf(fileID,'%s',num2str(year_array(j)),' ,turion_S');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_turion_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,sprout_S');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_sprout_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,viability_S');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_viability_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual_S');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,germspradt_S');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_germspradt_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
end


fclose(fileID);    

% %%
% fileID = fopen([infile,'\yearlyarea_N_2016_2018.csv'],'w'); %w is to make a new workbook, 'a' is to append
% fprintf(fileID,'%s\n','Year,stage,SC01,SC02,SC03,SC04,SC05,SC06,SC07,SC08,SC09,SC11'); %s-character vector, n- start a new line
% 
% for j=1:length(year_array)
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual');
%     %         fprintf(fileID,'%s\n',' ,sexual');    
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,adult');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_adult_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,flower');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_flower_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,seed');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end   
%     fprintf(fileID,'%s\n','');
% end
% 
% 
% fclose(fileID);
% %
% 
% fileID = fopen([infile,'\yearlyarea_S_2016_2018.csv'],'w'); %w is to make a new workbook, 'a' is to append
% fprintf(fileID,'%s\n','Year,stage,SC01,SC02,SC03,SC04,SC05,SC06,SC07,SC08,SC09,SC11'); %s-character vector, n- start a new line
% 
% for j=1:length(year_array)
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual');
%     %         fprintf(fileID,'%s\n',' ,sexual');    
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,adult');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_adult_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,flower');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_flower_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,seed');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end   
%     fprintf(fileID,'%s\n','');
% end
% 
% 
% fclose(fileID);

%%



%     %%%%%%%%%%%%%%%%
% 
%     
%     fileID = fopen([infile,'\sexual_yearlyarea_N.csv'],'w'); %w is to make a new workbook, 'a' is to append
%     fprintf(fileID,'%s\n','Year,SC01,SC02,SC03,SC04,SC05,SC06,SC07,SC08,SC09'); %s-character vector, n- start a new line
%     
%     for j=1:length(year_array)
%         fprintf(fileID,'%s',num2str(year_array(j)));
%         
%         for n=1:length(scenario)
%             fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%         end
%         fprintf(fileID,'%s\n','');
%     end
%     
%     
%     fclose(fileID);
%     
%     
%     
%     
%      fileID = fopen([infile,'\sexual_yearlyarea_S.csv'],'w'); %w is to make a new workbook, 'a' is to append
%     fprintf(fileID,'%s\n','Year,SC01,SC02,SC03,SC04,SC05,SC06,SC07,SC08,SC09'); %s-character vector, n- start a new line
%     
%     for j=1:length(year_array)
%         fprintf(fileID,'%s',num2str(year_array(j)));
%         
%         for n=1:length(scenario)
%             fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%         end
%         fprintf(fileID,'%s\n','');
%     end
%     
%     
%     fclose(fileID);
%     
%     
%     
%     
%     
%     
%      fileID = fopen([infile,'\adult_yearlyarea_N.csv'],'w'); %w is to make a new workbook, 'a' is to append
%     fprintf(fileID,'%s\n','Year,SC01,SC02,SC03,SC04,SC05,SC06,SC07,SC08,SC09'); %s-character vector, n- start a new line
%     
%     for j=1:length(year_array)
%         fprintf(fileID,'%s',num2str(year_array(j)));
%         
%         for n=1:length(scenario)
%             fprintf(fileID,',%6.2f',yearlyareaRuppia_adult_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%         end
%         fprintf(fileID,'%s\n','');
%     end
%     
%     
%     
%     
%     fclose(fileID);
%     
%      fileID = fopen(['Y:\CIIP\Scenarios\Plotting\adult_yearlyarea_S.csv'],'w'); %w is to make a new workbook, 'a' is to append
%     fprintf(fileID,'%s\n','Year,SC01,SC02,SC03,SC04,SC05,SC06,SC07,SC08,SC09,SC10,SC11,SC12,SC13,SC14,SC15,SC16,SC17,SC18,SC19,SC20,SC21,SC22,SC23,SC24,SC25,SC26,SC27'); %s-character vector, n- start a new line
%     
%     for j=1:length(year_array)
%         fprintf(fileID,'%s',num2str(year_array(j)));
%         
%         for n=1:length(scenario)
%             fprintf(fileID,',%6.2f',yearlyareaRuppia_adult_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%         end
%         fprintf(fileID,'%s\n','');
%     end
%     
%     
%     fclose(fileID);
%     
%     
%     
%     
%         
%      fileID = fopen(['Y:\CIIP\Scenarios\Plotting\flower_yearlyarea_N.csv'],'w'); %w is to make a new workbook, 'a' is to append
%     fprintf(fileID,'%s\n','Year,SC01,SC02,SC03,SC04,SC05,SC06,SC07,SC08,SC09,SC10,SC11,SC12,SC13,SC14,SC15,SC16,SC17,SC18,SC19,SC20,SC21,SC22,SC23,SC24,SC25,SC26,SC27'); %s-character vector, n- start a new line
%     
%     for j=1:length(year_array)
%         fprintf(fileID,'%s',num2str(year_array(j)));
%         
%         for n=1:length(scenario)
%             fprintf(fileID,',%6.2f',yearlyareaRuppia_flower_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%         end
%         fprintf(fileID,'%s\n','');
%     end
%     
%     
%     
%     
%     fclose(fileID);
%     
%      fileID = fopen(['Y:\CIIP\Scenarios\Plotting\flower_yearlyarea_S.csv'],'w'); %w is to make a new workbook, 'a' is to append
%     fprintf(fileID,'%s\n','Year,SC01,SC02,SC03,SC04,SC05,SC06,SC07,SC08,SC09,SC10,SC11,SC12,SC13,SC14,SC15,SC16,SC17,SC18,SC19,SC20,SC21,SC22,SC23,SC24,SC25,SC26,SC27'); %s-character vector, n- start a new line
%     
%     for j=1:length(year_array)
%         fprintf(fileID,'%s',num2str(year_array(j)));
%         
%         for n=1:length(scenario)
%             fprintf(fileID,',%6.2f',yearlyareaRuppia_flower_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%         end
%         fprintf(fileID,'%s\n','');
%     end
%     
%     
%     fclose(fileID);
%     
%     
%     
%     
%         
%      fileID = fopen(['Y:\CIIP\Scenarios\Plotting\seed_yearlyarea_N.csv'],'w'); %w is to make a new workbook, 'a' is to append
%     fprintf(fileID,'%s\n','Year,SC01,SC02,SC03,SC04,SC05,SC06,SC07,SC08,SC09,SC10,SC11,SC12,SC13,SC14,SC15,SC16,SC17,SC18,SC19,SC20,SC21,SC22,SC23,SC24,SC25,SC26,SC27'); %s-character vector, n- start a new line
%     
%     for j=1:length(year_array)
%         fprintf(fileID,'%s',num2str(year_array(j)));
%         
%         for n=1:length(scenario)
%             fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_N.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%         end
%         fprintf(fileID,'%s\n','');
%     end
%     
%     
%     
%     
%     fclose(fileID);
%     
%      fileID = fopen(['Y:\CIIP\Scenarios\Plotting\seed_yearlyarea_S.csv'],'w'); %w is to make a new workbook, 'a' is to append
%     fprintf(fileID,'%s\n','Year,SC01,SC02,SC03,SC04,SC05,SC06,SC07,SC08,SC09,SC10,SC11,SC12,SC13,SC14,SC15,SC16,SC17,SC18,SC19,SC20,SC21,SC22,SC23,SC24,SC25,SC26,SC27'); %s-character vector, n- start a new line
%     
%     for j=1:length(year_array)
%         fprintf(fileID,'%s',num2str(year_array(j)));
%         
%         for n=1:length(scenario)
%             fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_S.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%         end
%         fprintf(fileID,'%s\n','');
%     end
%     
%     
%     fclose(fileID);
%     
%     
%     
% % end

