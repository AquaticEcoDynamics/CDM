function outdata = clip_interped_data(indata,clipdata);

alldate = indata.Date;
clipdate = clipdata.Date;

outdata = clipdata;
outdata.Date = [];
outdata.Data = [];
outdata.Depth = [];

for i = 1:length(clipdate)
    
    [~,ind]  = min(abs(alldate - clipdate(i)));
    
    outdata.Date(i,1) = alldate(ind);
    outdata.Data(i,1) = indata.Data(ind);
    outdata.Depth(i,1) = indata.Depth(ind);
    
end
