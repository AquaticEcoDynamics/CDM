function [udate,udata] = calculate_daily_ave(adate,adata)

udate = unique(floor(adate));

for i = 1:length(udate)
    sss = find(floor(adate) == udate(i));
    udata(i,1) = mean(adata(sss));
end