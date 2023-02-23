clear; close all;

scenario = {...
    'eWater2021_basecase_t3_all',...
    };

year_array = 2018:2021;


shp=shaperead('C:\Users\00101765\OneDrive - The University of Western Australia\Matlab\CIIP\GIS\ocean_north.shp');    %shapefile that contains the north ocean area of coorong - which is to be excluded from area calculation

load('C:\Users\00101765\OneDrive - The University of Western Australia\Matlab\eWater_2022\Area_Information_new.mat');

%%
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
        
        
        tarea0(1:20)=0;
        tarea0r(1:20)=0;
        tarea1(1:20)=0;
        tarea1r(1:20)=0;
        tarea2(1:20)=0;
        tarea2r(1:20)=0;
        tarea3(1:20)=0;
        tarea3r(1:20)=0;
        tarea4(1:20)=0;
        tarea4r(1:20)=0;
        tarea5(1:20)=0;
        tarea5r(1:20)=0;
        tarea6(1:20)=0;
        tarea6r(1:20)=0;
        tarea7(1:20)=0;
        tarea7r(1:20)=0;
        tarea8(1:20)=0;
        tarea8r(1:20)=0;
%         tarea9(1:20)=0;
%         tarea9r(1:20)=0;
        tarea10(1:20)=0;
        tarea10r(1:20)=0;
        tarea11(1:20)=0;
        tarea11r(1:20)=0;
        tarea12(1:20)=0;
        tarea12r(1:20)=0;
        
        
        
        %calculate areas for dual pathways, and sexual only, or asexual only, excluding dual cells
        
        %dual
%         for cc=1:size(data0,1) %for all HSI
%             if ~inpol(cc) %if it's not in polygon
%                 if data0(cc)<=0.5||data7(cc)<=0.5
%                     tarea10=tarea10+0; %if HSI<0.5, area deemed unsuitable
%                     tarea10r=tarea10r+0;
%                 elseif data0(cc)>0.5 && data7(cc)>0.5
%                     tarea10=tarea10 + (data0(cc)+ data7(cc))/2 *cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
%                     tarea10r=tarea10r + cell_A(cc);  %real area not weighted
%                 end
%             end
%             dual(cc) = data0(cc)>0.5 & data7(cc)>0.5;
%         end
        
        for cc=1:size(data0,1) %for all HSI            
            for k = 1:length(Area)   %20 areas/polygons                
                good(cc)= data0(cc)>0.5 & data7(cc)>0.5 & Area(k).cell_ID(cc)>0;                
                if good(cc)==0
                    tarea10(k)=tarea10(k)+0;      
                    tarea10r(k)=tarea10r(k)+0;
                elseif good(cc)==1
                    tarea10(k)=tarea10(k)+(data0(cc)+ data7(cc))/2 *cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                    tarea10r(k)=tarea10r(k) + cell_A(cc);
                end               
                yearlyareaRuppia_dual.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea10(k)/1e6;
                yearlyareaRuppia_dual_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea10r(k)/1e6;
            end   
            dual(cc) = data0(cc)>0.5 & data7(cc)>0.5;
        end
        
        
        %sexual only
%         for cc=1:size(data0,1) %for all HSI
%             if ~inpol(cc) %if it's not in polygon
%                 if  data0(cc)<=0.5
%                     tarea11=tarea11+0; %if HSI<0.5, area deemed unsuitable
%                     tarea11r=tarea11r+0;
%                 elseif dual(cc)== 0 && data0(cc)>0.5
%                     tarea11=tarea11+data0(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
%                     tarea11r=tarea11r + cell_A(cc);
%                 end
%             end
%         end
%         
        for cc=1:size(data0,1) %for all HSI
            for k = 1:length(Area)   %20 areas/polygons
                good(cc)= dual(cc)== 0 & data0(cc)>0.5 & Area(k).cell_ID(cc)>0;
                if good(cc)==0
                    tarea11(k)=tarea11(k)+0;
                    tarea11r(k)=tarea11r(k)+0;
                elseif good(cc)==1
                    tarea11(k)=tarea11(k)+data0(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                    tarea11r(k)=tarea11r(k) + cell_A(cc);
                end
                yearlyareaRuppia_sexual_only.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea11(k)/1e6;
                yearlyareaRuppia_sexual_only_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea11r(k)/1e6;
            end
        end
        
        
        %asexual only
%         for cc=1:size(data7,1) %for all HSI
%             if ~inpol(cc) %if it's not in polygon
%                 if  data7(cc)<=0.5
%                     tarea12=tarea12+0; %if HSI<0.5, area deemed unsuitable
%                     tarea12r=tarea12r+0;
%                 elseif dual(cc)== 0 && data7(cc)>0.5
%                     tarea12=tarea12+data7(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
%                     tarea12r=tarea12r + cell_A(cc);
%                 end
%             end
%         end
        
         for cc=1:size(data7,1) %for all HSI
            for k = 1:length(Area)   %20 areas/polygons
                good(cc)= dual(cc)== 0 & data7(cc)>0.5 & Area(k).cell_ID(cc)>0;
                if good(cc)==0
                    tarea12(k)=tarea12(k)+0;
                    tarea12r(k)=tarea12r(k)+0;
                elseif good(cc)==1
                    tarea12(k)=tarea12(k)+data7(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                    tarea12r(k)=tarea12r(k) + cell_A(cc);
                end
                yearlyareaRuppia_asexual_only.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea12(k)/1e6;
                yearlyareaRuppia_asexual_only_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea12r(k)/1e6;
            end
        end
        
        
        
        
        %calculate area for each stage separately
        
        
        for cc=1:size(data0,1) %for all HSI
            for k = 1:length(Area)   %20 areas/polygons
                good(cc)= data0(cc)>0.5 & Area(k).cell_ID(cc)>0;
                if good(cc)==0
                    tarea0(k)=tarea0(k)+0;
                    tarea0r(k)=tarea0r(k)+0;
                elseif good(cc)==1
                    tarea0(k)=tarea0(k)+data0(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                    tarea0r(k)=tarea0r(k) + cell_A(cc);
                end
                yearlyareaRuppia_sexual.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea0(k)/1e6;
                yearlyareaRuppia_sexual_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea0r(k)/1e6;
            end
        end
        
        
        
        for cc=1:size(data1,1) %for all HSI
            for k = 1:length(Area)   %20 areas/polygons
                good(cc)= data1(cc)>0.5 & Area(k).cell_ID(cc)>0;
                if good(cc)==0
                    tarea1(k)=tarea1(k)+0;
                    tarea1r(k)=tarea1r(k)+0;
                elseif good(cc)==1
                    tarea1(k)=tarea1(k)+data1(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                    tarea1r(k)=tarea1r(k) + cell_A(cc);
                end
                yearlyareaRuppia_adult.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)=tarea1(k)/1e6;
                yearlyareaRuppia_adult_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)=tarea1r(k)/1e6;
            end
        end
        
        for cc=1:size(data2,1) %for all HSI
            for k = 1:length(Area)   %20 areas/polygons
                good(cc)= data2(cc)>0.5 & Area(k).cell_ID(cc)>0;
                if good(cc)==0
                    tarea2(k)=tarea2(k)+0;
                    tarea2r(k)=tarea2r(k)+0;
                elseif good(cc)==1
                    tarea2(k)=tarea2(k)+data2(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                    tarea2r(k)=tarea2r(k) + cell_A(cc);
                end
                yearlyareaRuppia_flower.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)=tarea2(k)/1e6;
                yearlyareaRuppia_flower_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)=tarea2r(k)/1e6;
            end
        end
        
        
        for cc=1:size(data3,1) %for all HSI
            for k = 1:length(Area)   %20 areas/polygons
                good(cc)= data3(cc)>0.5 & Area(k).cell_ID(cc)>0;
                if good(cc)==0
                    tarea3(k)=tarea3(k)+0;
                    tarea3r(k)=tarea3r(k)+0;
                elseif good(cc)==1
                    tarea3(k)=tarea3(k)+data3(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                    tarea3r(k)=tarea3r(k) + cell_A(cc);
                end
                yearlyareaRuppia_seed.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)=tarea3(k)/1e6;
                yearlyareaRuppia_seed_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)=tarea3r(k)/1e6;
            end
        end
        
        
        for cc=1:size(data4,1) %for all HSI
            for k = 1:length(Area)   %20 areas/polygons
                good(cc)= data4(cc)>0.5 & Area(k).cell_ID(cc)>0;
                if good(cc)==0
                    tarea4(k)=tarea4(k)+0;
                    tarea4r(k)=tarea4r(k)+0;
                elseif good(cc)==1
                    tarea4(k)=tarea4(k)+data4(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                    tarea4r(k)=tarea4r(k) + cell_A(cc);
                end
                yearlyareaRuppia_turion.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea4(k)/1e6;
                yearlyareaRuppia_turion_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea4r(k)/1e6;
            end
        end
        
        
        for cc=1:size(data5,1) %for all HSI
            for k = 1:length(Area)   %20 areas/polygons
                good(cc)= data5(cc)>0.5 & Area(k).cell_ID(cc)>0;
                if good(cc)==0
                    tarea5(k)=tarea5(k)+0;
                    tarea5r(k)=tarea5r(k)+0;
                elseif good(cc)==1
                    tarea5(k)=tarea5(k)+data5(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                    tarea5r(k)=tarea5r(k) + cell_A(cc);
                end
                yearlyareaRuppia_sprout.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea5(k)/1e6;
                yearlyareaRuppia_sprout_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea5r(k)/1e6;
            end
        end
        
        for cc=1:size(data6,1) %for all HSI
            for k = 1:length(Area)   %20 areas/polygons
                good(cc)= data6(cc)>0.5 & Area(k).cell_ID(cc)>0;
                if good(cc)==0
                    tarea6(k)=tarea6(k)+0;
                    tarea6r(k)=tarea6r(k)+0;
                elseif good(cc)==1
                    tarea6(k)=tarea6(k)+data6(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                    tarea6r(k)=tarea6r(k) + cell_A(cc);
                end
                yearlyareaRuppia_viability.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea6(k)/1e6;
                yearlyareaRuppia_viability_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea6r(k)/1e6;
            end
        end
        
        for cc=1:size(data7,1) %for all HSI
            for k = 1:length(Area)   %20 areas/polygons
                good(cc)= data7(cc)>0.5 & Area(k).cell_ID(cc)>0;
                if good(cc)==0
                    tarea7(k)=tarea7(k)+0;
                    tarea7r(k)=tarea7r(k)+0;
                elseif good(cc)==1
                    tarea7(k)=tarea7(k)+data7(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                    tarea7r(k)=tarea7r(k) + cell_A(cc);
                end
                yearlyareaRuppia_asexual.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea7(k)/1e6;
                yearlyareaRuppia_asexual_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea7r(k)/1e6;
            end
        end
        
        for cc=1:size(data8,1) %for all HSI
            for k = 1:length(Area)   %20 areas/polygons
                good(cc)= data8(cc)>0.5 & Area(k).cell_ID(cc)>0;
                if good(cc)==0
                    tarea8(k)=tarea8(k)+0;
                    tarea8r(k)=tarea8r(k)+0;
                elseif good(cc)==1
                    tarea8(k)=tarea8(k)+data8(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
                    tarea8r(k)=tarea8r(k) + cell_A(cc);
                end
                yearlyareaRuppia_seed_sprout.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea8(k)/1e6;
                yearlyareaRuppia_seed_sprout_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea8r(k)/1e6;
            end
        end
        
%         for cc=1:size(data9,1) %for all HSI
%             for k = 1:length(Area)   %20 areas/polygons
%                 good(cc)= data9(cc)>0.5 & Area(k).cell_ID(cc)>0;
%                 if good(cc)==0
%                     tarea9(k)=tarea9(k)+0;
%                     tarea9r(k)=tarea9r(k)+0;
%                 elseif good(cc)==1
%                     tarea9(k)=tarea9(k)+data9(cc).*cell_A(cc); %if HSI>=0.5, suitable area=HSI*area(m2)
%                     tarea9r(k)=tarea9r(k) + cell_A(cc);
%                 end
%                 yearlyareaRuppia_combined.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea9(k)/1e6;
%                 yearlyareaRuppia_combined_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k) =tarea9r(k)/1e6;
%             end
%         end
        
      
        
%         
%         
%         yearlyareaRuppia_sexual.(scenario{n}).(['year_',num2str(year_array(j))])=tarea0/1e6; %convert area m2 to km2
%         yearlyareaRuppia_adult.(scenario{n}).(['year_',num2str(year_array(j))])=tarea1/1e6;
%         yearlyareaRuppia_flower.(scenario{n}).(['year_',num2str(year_array(j))])=tarea2/1e6;
%         yearlyareaRuppia_seed.(scenario{n}).(['year_',num2str(year_array(j))])=tarea3/1e6;
%         yearlyareaRuppia_turion.(scenario{n}).(['year_',num2str(year_array(j))])=tarea4/1e6;
%         yearlyareaRuppia_sprout.(scenario{n}).(['year_',num2str(year_array(j))])=tarea5/1e6;
%         yearlyareaRuppia_viability.(scenario{n}).(['year_',num2str(year_array(j))])=tarea6/1e6;
%         yearlyareaRuppia_asexual.(scenario{n}).(['year_',num2str(year_array(j))])=tarea7/1e6;
%         yearlyareaRuppia_seed_sprout.(scenario{n}).(['year_',num2str(year_array(j))])=tarea8/1e6;
%         yearlyareaRuppia_combined.(scenario{n}).(['year_',num2str(year_array(j))])=tarea9/1e6;
%         yearlyareaRuppia_dual.(scenario{n}).(['year_',num2str(year_array(j))])=tarea10/1e6;
%         yearlyareaRuppia_sexual_only.(scenario{n}).(['year_',num2str(year_array(j))])=tarea11/1e6;
%         yearlyareaRuppia_asexual_only.(scenario{n}).(['year_',num2str(year_array(j))])=tarea12/1e6;
%         
%         yearlyareaRuppia_sexual_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea0r/1e6;
%         yearlyareaRuppia_adult_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea1r/1e6;
%         yearlyareaRuppia_flower_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea2r/1e6;
%         yearlyareaRuppia_seed_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea3r/1e6;
%         yearlyareaRuppia_turion_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea4r/1e6;
%         yearlyareaRuppia_sprout_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea5r/1e6;
%         yearlyareaRuppia_viability_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea6r/1e6;
%         yearlyareaRuppia_asexual_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea7r/1e6;
%         yearlyareaRuppia_seed_sprout_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea8r/1e6;
%         yearlyareaRuppia_combined_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea9r/1e6;
%         yearlyareaRuppia_dual_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea10r/1e6;
%         yearlyareaRuppia_sexual_only_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea11r/1e6;
%         yearlyareaRuppia_asexual_only_r.(scenario{n}).(['year_',num2str(year_array(j))])=tarea12r/1e6;
        
        
        
        
    end
end

%%


% fileID = fopen([infile,'\yearlyarea_dual_2.csv'],'w'); %w is to make a new workbook, 'a' is to append
% fprintf(fileID,'%s\n','Year,stage,Basecase'); %,NC1,NC2,NC3,NC4,NC5,NE1,NE2,NE3,NE4,NE5'); %s-character vector, n- start a new line
% 
% for j=1:length(year_array)
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual');
%     %         fprintf(fileID,'%s\n',' ,sexual');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,adult');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_adult.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,flower');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_flower.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,seed');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_seed.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,turion');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_turion.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,sprout');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_sprout.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,viability');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_viability.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,seed_sprout');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_sprout.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,combined');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_combined.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,dual');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_dual.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual_only');
%     %         fprintf(fileID,'%s\n',' ,sexual');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_only.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual_only');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual_only.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual_r');
%     %         fprintf(fileID,'%s\n',' ,sexual');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,adult_r');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_adult_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,flower_r');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_flower.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,seed_r');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,turion_r');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_turion_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,sprout_r');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_sprout_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,viability_r');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_viability_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual_r');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,seed_sprout_r');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_sprout_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,combined_r');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_combined_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,dual_r');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_dual_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual_only_r');
%     %         fprintf(fileID,'%s\n',' ,sexual');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_only_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
%     fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual_only_r');
%     for n=1:length(scenario)
%         fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual_only_r.(scenario{n}).(['year_',num2str(year_array(j))])); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
%     end
%     fprintf(fileID,'%s\n','');
%     
% end
% 
% 
% fclose(fileID);
% 


fileID = fopen([infile,'\yearlyarea_poly_2.csv'],'w'); %w is to make a new workbook, 'a' is to append
fprintf(fileID,'%s\n','Year,stage,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20'); %,NC1,NC2,NC3,NC4,NC5,NE1,NE2,NE3,NE4,NE5'); %s-character vector, n- start a new line

for n = 1:length(scenario)
    n=1;
    
    for j=1:length(year_array)
        fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,adult');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_adult.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,flower');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_flower.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,seed');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_seed.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,turion');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_turion.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,sprout');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_sprout.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,viability');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_viability.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,seed_sprout');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_sprout.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,combined');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_combined.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,dual');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_dual.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual_only');
        %         fprintf(fileID,'%s\n',' ,sexual');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_only.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual_only');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual_only.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual_r');
        %         fprintf(fileID,'%s\n',' ,sexual');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,adult_r');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_adult_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,flower_r');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_flower.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,seed_r');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,turion_r');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_turion_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,sprout_r');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_sprout_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,viability_r');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_viability_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual_r');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,seed_sprout_r');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_seed_sprout_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,combined_r');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_combined_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,dual_r');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_dual_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,sexual_only_r');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_sexual_only_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
        fprintf(fileID,'%s',num2str(year_array(j)),' ,asexual_only_r');
        for k=1:length(Area)
            fprintf(fileID,',%6.2f',yearlyareaRuppia_asexual_only_r.(scenario{n}).(['year_',num2str(year_array(j))]).Area(k)); %6.2f: 6 digits,2 decimal points, floating data type, other types include interger, double
        end
        fprintf(fileID,'%s\n','');
        
    end
end


fclose(fileID);

