clear; close all;

scenario = {...
    'eWater2021_basecase_t3_all',...
    };

year_array = 2018:2021;


shp=shaperead('C:\Users\00101765\OneDrive - The University of Western Australia\Matlab\CIIP\GIS\ocean_north.shp');    %shapefile that contains the north ocean area of coorong - which is to be excluded from area calculation



for n = 1:length(scenario)
    
    %load geo.mat;
    ncfile=['W:\CDM\output_basecase_hd_ruppia_new\eWater2021_basecase_t3_all.nc'];
    dat = tfv_readnetcdf(ncfile,'timestep',1);
    cell_A=dat.cell_A; %cell area
    cellx=dat.cell_X;
    celly=dat.cell_Y;
    inpol=inpolygon(cellx,celly,shp(1).X,shp(1).Y);
    
    infile= ['E:\output_basecase_hd_ruppia_new\Plotting_Ruppia\'];
    
    for j=1:length(year_array)
        %         for m = 1:length(stage)
        
        dataHSI0=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\HSI_sexual.mat']);
        dataHSI1=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\1_adult_new\HSI_adult.mat']);
        dataHSI2=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\2_flower_new\HSI_flower.mat']);
        dataHSI3=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\3_seed_new\HSI_seed.mat']);
        dataHSI4=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\4_turion_new\HSI_turion.mat']);
        dataHSI5=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\5_sprout_new\HSI_sprout.mat']);
        dataHSI6=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\6_viability\HSI_turionviability.mat']);
        dataHSI7=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\HSI_asexual.mat']);
        dataHSI8=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\HSI_seed_sprout.mat']);
%         dataHSI9=load([infile,scenario{n}, '\Sheets\',num2str(year_array(j)),'\HSI_combined.mat']);
        
        data0=dataHSI0.min_cdata;
        data1=dataHSI1.min_cdata;
        data2=dataHSI2.min_cdata;
        data3=dataHSI3.min_cdata;
        data4=dataHSI4.min_cdata;
        data5=dataHSI5.min_cdata;
        data6=dataHSI6.min_cdata;
        data7=dataHSI7.min_cdata;
        data8=dataHSI8.hsi_seed_sprout;
%         data9=dataHSI9.hsi_combined;
        
        
        tarea0=0;
        tarea0r=0;
        tarea1=0;
        tarea1r=0;
        tarea2=0;
        tarea2r=0;
        tarea3=0;
        tarea3r=0;
        tarea4=0;
        tarea4r=0;
        tarea5=0;
        tarea5r=0;
        tarea6=0;
        tarea6r=0;
        tarea7=0;
        tarea7r=0;
        tarea8=0;
        tarea8r=0;
%         tarea9=0;
%         tarea9r=0;
        tarea10=0;
        tarea10r=0;
         tarea11=0;
        tarea11r=0;
         tarea12=0;
        tarea12r=0;
        
       
        
        
        %calculate areas for dual pathways, and sexual only, or asexual only, excluding dual cells
        
        %dual
        for cc=1:size(data0,1) %for all HSI
            if ~inpol(cc) %if it's not in polygon
                if data0(cc)<=0.5||data7(cc)<=0.5
                    tarea10=tarea10+0; %if HSI<0.5, area deemed unsuitable
                    tarea10r=tarea10r+0;
                elseif data0(cc)>0.5 && data7(cc)>0.5
                    tarea10=tarea10 + (data0(cc)+ data7(cc))/2 *cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                    tarea10r=tarea10r + cell_A(cc);  %real area not weighted
                end
            end
            dual(cc) = data0(cc)>0.5 & data7(cc)>0.5;
        end
        
        %sexual only
         for cc=1:size(data0,1) %for all HSI
                if ~inpol(cc) %if it's not in polygon                  
                    if  data0(cc)<=0.5
                        tarea11=tarea11+0; %if HSI<0.5, area deemed unsuitable
                        tarea11r=tarea11r+0; 
                    elseif dual(cc)== 0 && data0(cc)>0.5
                        tarea11=tarea11+data0(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                        tarea11r=tarea11r + cell_A(cc);
                    end
                end
         end
            
         %asexual only
         for cc=1:size(data7,1) %for all HSI
                if ~inpol(cc) %if it's not in polygon                  
                    if  data7(cc)<=0.5
                        tarea12=tarea12+0; %if HSI<0.5, area deemed unsuitable
                        tarea12r=tarea12r+0; 
                    elseif dual(cc)== 0 && data7(cc)>0.5
                        tarea12=tarea12+data7(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                        tarea12r=tarea12r + cell_A(cc);
                    end
                end
            end
             
             
   
             
         %calculate area for each stage separately          
            
            for cc=1:size(data0,1) %for all HSI
                if ~inpol(cc) %if it's not in polygon
                    if data0(cc)<=0.5
                        tarea0=tarea0+0; %if HSI<0.5, area deemed unsuitable
                        tarea0r=tarea0r+0;
                    elseif data0(cc)>0.5
                        tarea0=tarea0+data0(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                        tarea0r=tarea0r + cell_A(cc);
                    end
                end
            end
            
            for cc=1:size(data1,1) %for all HSI
                if ~inpol(cc) %if it's not in polygon
                    if data1(cc)<=0.5
                        tarea1=tarea1+0; %if HSI<0.5, area deemed unsuitable
                         tarea1r=tarea1r+0;
                    elseif data1(cc)>0.5
                        tarea1=tarea1+data1(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                         tarea1r=tarea1r + cell_A(cc);
                    end
                end
            end
            
            for cc=1:size(data2,1) %for all HSI
                if ~inpol(cc) %if it's not in polygon
                    if data2(cc)<=0.5
                        tarea2=tarea2+0; %if HSI<0.5, area deemed unsuitable
                         tarea2r=tarea2r+0;
                    elseif data2(cc)>0.5
                        tarea2=tarea2+data2(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                         tarea2r=tarea2r + cell_A(cc);
                    end
                end
            end
            
            for cc=1:size(data3,1) %for all HSI
                if ~inpol(cc) %if it's not in polygon
                    if data3(cc)<=0.5
                        tarea3=tarea3+0; %if HSI<0.5, area deemed unsuitable
                         tarea3r=tarea3r+0;
                    elseif data3(cc)>0.5
                        tarea3=tarea3+data3(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                         tarea3r=tarea3r + cell_A(cc);
                    end
                end
            end
            for cc=1:size(data4,1) %for all HSI
                if ~inpol(cc) %if it's not in polygon
                    if data4(cc)<=0.5
                        tarea4=tarea4+0; %if HSI<0.5, area deemed unsuitable
                         tarea4r=tarea4r+0;
                    elseif data4(cc)>0.5
                        tarea4=tarea4+data4(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                         tarea4r=tarea4r + cell_A(cc);
                    end
                end
            end
            
            for cc=1:size(data5,1) %for all HSI
                if ~inpol(cc) %if it's not in polygon
                    if data5(cc)<=0.5
                        tarea5=tarea5+0; %if HSI<0.5, area deemed unsuitable
                         tarea5r=tarea5r+0;
                    elseif data5(cc)>0.5
                        tarea5=tarea5+data5(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                         tarea5r=tarea5r + cell_A(cc);
                    end
                end
            end
            
            for cc=1:size(data6,1) %for all HSI
                if ~inpol(cc) %if it's not in polygon
                    if data6(cc)<=0.5
                        tarea6=tarea6+0; %if HSI<0.5, area deemed unsuitable
                         tarea6r=tarea6r+0;
                    elseif data6(cc)>0.5
                        tarea6=tarea6+data6(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                         tarea6r=tarea6r + cell_A(cc);
                    end
                end
            end
            
            for cc=1:size(data7,1) %for all HSI
                if ~inpol(cc) %if it's not in polygon
                    if data7(cc)<=0.5
                        tarea7=tarea7+0; %if HSI<0.5, area deemed unsuitable
                         tarea7r=tarea7r+0;
                    elseif data7(cc)>0.5
                        tarea7=tarea7+data7(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                         tarea7r=tarea7r + cell_A(cc);
                    end
                end
            end
            for cc=1:size(data8,1) %for all HSI
                if ~inpol(cc) %if it's not in polygon
                    if data8(cc)<=0.5
                        tarea8=tarea8+0; %if HSI<0.5, area deemed unsuitable
                         tarea8r=tarea8r+0;
                    elseif data8(cc)>0.5
                        tarea8=tarea8+data8(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                         tarea8r=tarea8r + cell_A(cc);
                    end
                end
            end
%             for cc=1:size(data9,1) %for all HSI
%                 if ~inpol(cc) %if it's not in polygon
%                     if data9(cc)<=0.5
%                         tarea9=tarea9+0; %if HSI<0.5, area deemed unsuitable
%                          tarea9r=tarea9r+0;
%                     elseif data9(cc)>0.5
%                         tarea9=tarea9 + data9(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
%                          tarea9r=tarea9r + cell_A(cc);
%                     end
%                 end
%             end
%            
            
            
            
            yearlyareaRuppia_sexual.(scenario{n}).(['year_',num2str(year_array(j))])=tarea0/1e6; %convert area m2 to km2          
            yearlyareaRuppia_adult.(scenario{n}).(['year_',num2str(year_array(j))])=tarea1/1e6;
            yearlyareaRuppia_flower.(scenario{n}).(['year_',num2str(year_array(j))])=tarea2/1e6;
            yearlyareaRuppia_seed.(scenario{n}).(['year_',num2str(year_array(j))])=tarea3/1e6;
            yearlyareaRuppia_turion.(scenario{n}).(['year_',num2str(year_array(j))])=tarea4/1e6;
            yearlyareaRuppia_sprout.(scenario{n}).(['year_',num2str(year_array(j))])=tarea5/1e6;
            yearlyareaRuppia_viability.(scenario{n}).(['year_',num2str(year_array(j))])=tarea6/1e6;
            yearlyareaRuppia_asexual.(scenario{n}).(['year_',num2str(year_array(j))])=tarea7/1e6;          
            yearlyareaRuppia_seed_sprout.(scenario{n}).(['year_',num2str(year_array(j))])=tarea8/1e6;
%             yearlyareaRuppia_combined.(scenario{n}).(['year_',num2str(year_array(j))])=tarea9/1e6;
            yearlyareaRuppia_dual.(scenario{n}).(['year_',num2str(year_array(j))])=tarea10/1e6;           
            yearlyareaRuppia_sexual_only.(scenario{n}).(['year_',num2str(year_array(j))])=tarea11/1e6;         
            yearlyareaRuppia_asexual_only.(scenario{n}).(['year_',num2str(year_array(j))])=tarea12/1e6; 
            
            yearlyareaRuppia_sexual_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea0r/1e6;
            yearlyareaRuppia_adult_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea1r/1e6;
            yearlyareaRuppia_flower_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea2r/1e6;
            yearlyareaRuppia_seed_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea3r/1e6;
            yearlyareaRuppia_turion_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea4r/1e6;
            yearlyareaRuppia_sprout_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea5r/1e6;
            yearlyareaRuppia_viability_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea6r/1e6;           
            yearlyareaRuppia_asexual_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea7r/1e6;
            yearlyareaRuppia_seed_sprout_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea8r/1e6;
%             yearlyareaRuppia_combined_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea9r/1e6;
             yearlyareaRuppia_dual_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea10r/1e6;
             yearlyareaRuppia_sexual_only_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea11r/1e6;
             yearlyareaRuppia_asexual_only_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea12r/1e6;
            
            
            
            
        end
end

%%


fileID = fopen([infile,'\yearlyarea_dual_2.csv'],'w'); %w is to make a new workbook, 'a' is to append
fprintf(fileID,'%s\n','Year,stage,Basecase'); %,NC1,NC2,NC3,NC4,NC5,NE1,NE2,NE3,NE4,NE5'); %s-character vector, n- start a new line

for j=1:length(year_array)
    fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual');
    %         fprintf(fileID,'%s\n',' ,sexual');    
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,adult');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_adult.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,flower');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_flower.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,seed');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_seed.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,turion');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_turion.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,sprout');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_sprout.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,viability');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_viability.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,seed_sprout');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_sprout.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,combined');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_combined.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end   
%     fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,dual');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_dual.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual_only');
    %         fprintf(fileID,'%s\n',' ,sexual');    
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_only.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
     fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual_only');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual_only.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');    
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual_r');
    %         fprintf(fileID,'%s\n',' ,sexual');    
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,adult_r');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_adult_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,flower_r');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_flower.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,seed_r');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,turion_r');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_turion_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,sprout_r');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_sprout_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,viability_r');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_viability_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
     fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual_r');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
    fprintf(fileID,'%s',num2str(year_array(j)),' ,seed_sprout_r');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_sprout_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,combined_r');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_combined_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end   
%     fprintf(fileID,'%s\n','');
        
    fprintf(fileID,'%s',num2str(year_array(j)),' ,dual_r');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_dual_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');
    
      fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual_only_r');
    %         fprintf(fileID,'%s\n',' ,sexual');    
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_only_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end
    fprintf(fileID,'%s\n','');
    
     fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual_only_r');
    for n=1:length(scenario)
        fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual_only_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
    end   
    fprintf(fileID,'%s\n','');    

end


fclose(fileID);    
