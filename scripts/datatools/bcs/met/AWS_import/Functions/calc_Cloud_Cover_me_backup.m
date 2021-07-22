function Clouds_final = calc_Cloud_Cover(startdate,enddate,TZ,lat,lon,SP)


%this script is used to calculate cloud cover based on the method of Luo
%et al. (2012)
%Luo, L., Hamilton, D., & Han, B. (2010). Estimation of total cloud cover from solar radiation observations at Lake Rotorua, New Zealand. Solar Energy, 84(3), 501-506.
% then use cloud cove during day time to interpolat cloud cover at night.

% four interpolation methods are used.
% 1. average  of cloud cover  of two daysat day time 
% 2. linear interplolation between two days.
% 3. median of cloud over of two days  at day time 
% 4. minimum of cloud cover of two days at day time

% clc
% clear
% close all

%   load('D:\Research in UWA\overview of data available in anvil\all_togehter_plotting\anvil.mat');
% Sol  = anvil.Met.DAFWA.LRD.southPerth.SolRad; % solar radiation

% lat = -31.991043; %-31.991043, 115.886068 % the latitude and gratitude of location, I use the location of anvil way compensation basin.
% lon = 115.886068; 
% % define the period of calculating clourd cover
% startdate =  datenum('2005/01/01 00:00:00'); % start time
% enddate  =  datenum('2018/06/30 23:00:00');   % 
%mDate = (startdate : 1/24: enddate)' ; % interval is one hour
% TZ = 8; % time zone
SolRad = SP.SolRad;
mDate = SP.mDate;

timeint = SP.mDate(2) - SP.mDate(1);

[GHI ZenithAngle NewDate] = genBirdSolarData(lat,lon,startdate,enddate,TZ,timeint);
NewDate = NewDate';  

%Unsure yet what this is used for.
% nn = find( startdate <=  Sol.Date &  Sol.Date  <=  enddate   );
% SolRad = Sol.Data(nn,1); 



% figure
% plot(   NewDate, GHI )
% hold on
% plot(NewDate,   ZenithAngle    )
% hold on
% datestr(NewDate, 'yyyy/mm/dd HH:MM:SS')

GHI_Interp = interp1(NewDate,GHI,mDate);
ZenithAngle_Interp = interp1(NewDate,ZenithAngle,mDate);

nn = find(ZenithAngle_Interp <= 90);

k = floor(mDate(nn));

xx = unique(floor(mDate(nn)));



for i = 1:length(xx)
    rr = find(xx(i) == k);
    SunShineHours(i) = length(rr);
    GHI_avg(i) = mean(GHI_Interp(nn(rr)));
end

SunShineHours = interp1(xx,SunShineHours,mDate); 



nn = find(isnan(SunShineHours));
SunShineHours(nn) = SunShineHours(nn-1);

GHI_avg = interp1(xx,GHI_avg,mDate);
nn = find(isnan(GHI_avg));
GHI_avg(nn) = GHI_avg(nn-1);


GHI_Interp = interp1(NewDate,GHI,mDate);

Radiation = SolRad;
for i = 1:length(GHI_Interp)
    if Radiation(i) > GHI_Interp(i)
        Radiation(i) = GHI_Interp(i);
    end
end
% plot(mDate,GHI_Interp,'r');hold on;
% 
% 
% plot(mDate,SolRad,'k');hold on;

% Conversion of Daily Solar Data into the right units

%Radiation = ((SolRad)./(SunShineHours)).*1000;



% plot(NewDate,GHI,'r');hold on
% plot(mDate,Radiation,'k');
% 
% stop


% Get corresponding average TC for each Radiation value. Solving the 
% quadratic.

%GHI = GHI';

Cloud_Frac = (Radiation./GHI');
%Cloud_Frac = (Radiation./GHI_avg);

% figure;plot(mDate,GHI_Interp,'r');hold on
% plot(mDate,SolRad,'k');hold on
% 
% GHI_Interp(GHI_Interp < 0) = 0;
% 
% Cloud_Frac = (Radiation./GHI_Interp);

Cloud_Frac(isnan(Cloud_Frac)) = 0;
Cloud_Frac(isinf(Cloud_Frac)) = 0;


mm = find(Cloud_Frac > 0.98475);
Cloud_Frac(mm) = 0.98;
% 
mm = find( Cloud_Frac >0 & Cloud_Frac < 0.12297   );  %   enable b^2 - 4ac >0
Cloud_Frac(mm) = 0.13;
%calculate cloud cover throughout the day
Daily_Cloud = zeros(length(mDate), 1) * nan;

for i = 1:length(Cloud_Frac)
    
    a = 0.66182;
    b = -1.5236;
    c(i) = 0.98475  -Cloud_Frac(i);
    
    % the following equation is from Luo et al. (2010) 
    %Luo, L., Hamilton, D., & Han, B. (2010). Estimation of total cloud cover from solar radiation observations at Lake Rotorua, New Zealand. Solar Energy, 84(3), 501-50
    if ( power(b,2) - 4*a*c(i) > 0 ) & (2 * a  + b >  - sqrt(power(b,2) - 4*a*c(i)) )
    d(i) = sqrt(power(b,2) - 4*a*c(i));
   Daily_Cloud(i) = ( -b - d(i) ) / (2*a);  %   1 >Daily_Cloud(i)> 0 %  Cloud_Frac>0.01525
    end
end

% Interp to get Hourly Cloud
% whos
% Clouds = interp1(mDate,Daily_Cloud,NewDate);
% nn = find(isnan(Clouds));
% Clouds(nn) = min(Clouds);


Clouds = Daily_Cloud;
% for i = 1:length(days)
%     sss = find(mDate == days(i));
%     Clouds(sss) = mean(Daily_Cloud(sss));
% end



% use average to interpolate cloud cover at night
% Clouds(1, nn) = 1*nan;
CloudsAve(1,:) = Clouds;
 mday = unique(floor(mDate));
 
save test.mat CloudsAve Clouds mday mDate GHI  -mat;
for ii = 1:length(mday)
    % one day is divdied into three parts
    %(1) up 00:00 -7:00 
   % (2) median 7:00 -18:00 
   % (3) down 18:00 -23:00
    if ii == 1 % the night at first day
       ss_up = find(     mday(ii,1)  <  mDate              &  mDate <=  mday(ii,1)  + datenum(0,0,0, 12, 0,0)   ) ;  % period from 00:00 - 7:00 or 8:00
       ss_up
       nn_up = find( GHI(ss_up,1) ==0  );
       nn_up
       ss_m = find(     mday(ii,1)  == floor( mDate)  ) ;  % period from 7:00 or 8:00  to 18: 00 or 19:00
       ss_m
       nn_m = find( GHI(ss_m,1) >0  );
         nn_m       
       CloudsAve(ss_up(nn_up),1) = mean( CloudsAve(ss_m(  nn_m ,1),1   ));
    end
    
    if ii == length(mday) % the night at last day

       % period from 7:00 or 8:00  to 18: 00 or 19:00
       ss_m = find(     mday(ii,1)  == floor( mDate)  ) ;   % m represent median 7:00 -18:00 
       nn_m = find( GHI(ss_m,1) >0  );
       
       % period from 18: 00 or 19:00 to 23:00  % d represent down 18:00 -23:00
             ss_d = find(     mday(ii,1)  + datenum(0,0,0, 12, 0,0) <  mDate              &  mDate <=  mday(ii,1)  + datenum(0,0,0, 24, 0,0)   ) ; 
             nn_d = find( GHI(ss_d,1) ==0  );  
                
       CloudsAve(ss_d(nn_d),1) = mean( CloudsAve(ss_m(  nn_m ,1),1   ));
    end
    
    
       ss_two = find(     mday(ii,1) -   datenum(0,0,0, 12, 0,0) <  mDate              &  mDate <=  mday(ii,1)  + datenum(0,0,0, 12, 0,0)   ) ;  % period from 00:00 - 7:00 or 8:00
       nn_two_day = find( GHI(ss_two,1) >0  ); % find the day time from 00:00 +  48:00
       nn_two_night = find( GHI(ss_two,1) ==0  );  % find the night time from 00:00 : 48:00
      CloudsAve(ss_two(nn_two_night,1),1) = mean( CloudsAve(ss_two(nn_two_day,1),1) );
end



figure
plot(mDate,   CloudsAve,'*')
hold on 
% plot(mDate,   Clouds, 'o')

datetick('x', 19)
       
% use median to interpolate cloud cover at night
CloudsMedian = Clouds;

for ii = 1:length(mday)
    
    
    if ii == 1
       ss_up = find(     mday(ii,1)  <  mDate              &  mDate <=  mday(ii,1)  + datenum(0,0,0, 12, 0,0)   ) ;  % period from 00:00 - 7:00 or 8:00
       nn_up = find( GHI(ss_up,1) ==0  );
       
       ss_m = find(     mday(ii,1)  == floor( mDate)  ) ;  % period from 7:00 or 8:00  to 18: 00 or 19:00
       nn_m = find( GHI(ss_m,1) >0  );
                
       CloudsMedian(ss_up(nn_up),1) = median( CloudsMedian(ss_m(  nn_m ,1),1   ));
    end
    
    if ii == length(mday)

       
       ss_m = find(     mday(ii,1)  == floor( mDate)  ) ;  % period from 7:00 or 8:00  to 18: 00 or 19:00
       nn_m = find( GHI(ss_m,1) >0 );
       
             ss_d = find(     mday(ii,1)  + datenum(0,0,0, 12, 0,0) <  mDate              &  mDate <=  mday(ii,1)  + datenum(0,0,0, 24, 0,0)   ) ; 
             nn_d = find( GHI(ss_d,1) ==0  );  % period from 18: 00 or 19:00 to 23:00
                
       CloudsMedian(ss_d(nn_d),1) = median( CloudsMedian(ss_m(  nn_m ,1),1   ));
    end
    
    
       ss_two = find(     mday(ii,1) -   datenum(0,0,0, 12, 0,0) <  mDate              &  mDate <=  mday(ii,1)  + datenum(0,0,0, 12, 0,0)   ) ;  % period from 00:00 - 7:00 or 8:00
       nn_two_day = find( GHI(ss_two,1) >0  ); % find the day time from 00:00 +  48:00
       nn_two_night = find(GHI(ss_two,1) ==0  );  % find the night time from 00:00 : 48:00
      CloudsMedian(ss_two(nn_two_night,1),1) = median( CloudsMedian(ss_two(nn_two_day,1),1) );
end

figure
plot(mDate,   CloudsMedian,'*')
hold on 
% plot(mDate,   Clouds, 'o')
  
datetick('x', 19)

% use linear to interpolate cloud cover at night
CloudsLinear = Clouds;
for ii = 1:length(mday)
    
    if ii == 1  % this option  is intended to fill the gap in the moring of first day 00:00 - 7:00
       ss_up = find(     mday(ii,1)  <=  mDate              &  mDate <=  mday(ii,1)  + datenum(0,0,0, 12, 0,0)   ) ;  % period from 00:00 - 7:00 or 8:00
       nn_up = find( GHI(ss_up,1) ==0  );
       
       ss_m = find(     mday(ii,1)  == floor( mDate)  ) ;  % period from 7:00 or 8:00  to 18: 00 or 19:00
       nn_m = find( GHI(ss_m,1) >0  );
                
       CloudsLinear(ss_up(nn_up),1) = median( CloudsLinear(ss_m(  nn_m ,1),1   ));
    end
    
    if ii == length(mday) % this option  is intended to fill the gap in the evening of last day from sunset to 23:00

       
       ss_m = find(     mday(ii,1)  == floor( mDate)  ) ;  % period from 7:00 or 8:00  to 18: 00 or 19:00
       nn_m = find( GHI(ss_m,1) >0  );
       
             ss_d = find(     mday(ii,1)  + datenum(0,0,0, 12, 0,0) <  mDate              &  mDate <=  mday(ii,1)  + datenum(0,0,0, 24, 0,0)   ) ; 
             nn_d = find( GHI(ss_d,1) == 0 );  % period from 18: 00 or 19:00 to 23:00
                
       CloudsLinear(ss_d(nn_d),1) = median( CloudsLinear(ss_m(  nn_m ,1),1   ));
    end
  
    if    length(mday) > ii   %  ii = 1 is incluled ,because i need to fill the gap at night of first day.
    
  
      ss_today = find(     mday(ii,1) == floor(mDate)  ) ;
      nn_today = find( GHI(ss_today,1) >0);
      
          ss_tomorrow = find(     mday(ii+1,1) == floor(mDate)  ) ;
      nn_tomorrow = find( GHI(ss_tomorrow,1) >0);
      startIndex = ss_today(nn_today(end),1) ;
      endIndex = ss_tomorrow(nn_tomorrow(1),1);
      
      inter.Date(1,1) =  mDate( startIndex  ,1);
      inter.Date(2,1) =  mDate(      endIndex  ,1);
      
      inter.Data(1,1) =  CloudsLinear(       startIndex  ,1);
      inter.Data(2,1) =  CloudsLinear( endIndex   ,1);
      
            CloudsLinear( startIndex +1 : endIndex-1 ,1)  =   interp1(  inter.Date,  inter.Data, mDate( startIndex +1 : endIndex-1  ,1),'linear');
%       
%          figure
%          
%          plot(inter.Date,inter.Data,'*');
%          hold on
%          plot(mDate( startIndex +1 : endIndex-1  ,1),       CloudsLinear( startIndex +1 : endIndex-1 ,1) );
    end

      
end

figure
% plot(mDate,   CloudsLinear,'*')
plot(mDate,   CloudsLinear)
hold on 
% plot(mDate,   Clouds, 'o')
  

% use minium to interpolate cloud cover at night
CloudsMin = Clouds;

for ii = 1:length(mday)
    
    if ii == 1
       ss_up = find(     mday(ii,1)  <  mDate              &  mDate <=  mday(ii,1)  + datenum(0,0,0, 12, 0,0)   ) ;  % period from 00:00 - 7:00 or 8:00
       nn_up = find( GHI(ss_up,1) ==0  );
       
       ss_m = find(     mday(ii,1)  == floor( mDate)  ) ;  % period from 7:00 or 8:00  to 18: 00 or 19:00
       nn_m = find( GHI(ss_m,1) >0  );
                
       CloudsMin(ss_up(nn_up),1) = min( CloudsMin(ss_m(  nn_m ,1),1   ));
    end
    
    if ii == length(mday)

       
       ss_m = find(     mday(ii,1)  == floor( mDate)  ) ;  % period from 7:00 or 8:00  to 18: 00 or 19:00
       nn_m = find( GHI(ss_m,1) >0 );
       
             ss_d = find(     mday(ii,1)  + datenum(0,0,0, 12, 0,0) <  mDate              &  mDate <=  mday(ii,1)  + datenum(0,0,0, 24, 0,0)   ) ; 
             nn_d = find( GHI(ss_d,1) ==0  );  % period from 18: 00 or 19:00 to 23:00
                
       CloudsMin(ss_d(nn_d),1) = min( CloudsMin(ss_m(  nn_m ,1),1   ));
    end
    
    
       ss_two = find(     mday(ii,1) -   datenum(0,0,0, 12, 0,0) <  mDate              &  mDate <=  mday(ii,1)  + datenum(0,0,0, 12, 0,0)   ) ;  % period from 00:00 - 7:00 or 8:00
       nn_two_day = find( GHI(ss_two,1) >0  ); % find the day time from 00:00 +  48:00
       nn_two_night = find(GHI(ss_two,1) ==0  );  % find the night time from 00:00 : 48:00
      CloudsMin(ss_two(nn_two_night,1),1) = min( CloudsMin(ss_two(nn_two_day,1),1) );
end



datetick('x', 19)
cloud.mDate = mDate;
cloud.GHI = GHI;
cloud.mday = Clouds;
cloud.Cave    = CloudsAve;
cloud.Cmedian    = CloudsMedian;
cloud.Clinear   = CloudsLinear;
cloud.Cmin   = CloudsMin;
save cloud.mat cloud
%-----------Output to the file---------------------

 filename = ['CloudCover.csv'];

fid = fopen(filename,'wt');

fprintf(fid,'ISOTime, GHI, cloudsAve, cloudsMedian,cloudsLinear, cloudsMin\n');

for i = 1:length(mDate)
    fprintf(fid,'%s,',datestr(mDate(i),'dd/mm/yyyy HH:MM:SS'));
    fprintf(fid,'%4.4f, %4.4f, %4.4f, %4.4f, %4.4f\n',   GHI(i), CloudsAve(i),CloudsMedian(i),  CloudsLinear(i), CloudsMin(i)  );
end
fclose(fid);

Clouds_final = cloud.Cmin;



