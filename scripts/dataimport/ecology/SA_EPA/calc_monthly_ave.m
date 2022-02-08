function [thedate,thedata] = calc_monthly_ave(alldate,alldata,thetime)

[yyyy,mmmm,dddd] = datevec(thetime);

thedate(:,1) = thetime;
thedata(1:length(thetime),1) = NaN;

[y1,m1] = datevec(alldate);
for i = 1:12
    sss = find(m1 == i);
   if ~isempty(sss)
       
       mdata = mean(alldata(sss));
       
       ttt = find(mmmm == i);
       
       thedata(ttt) = mdata; clear mdata;
   end
end
       
    
    
    





