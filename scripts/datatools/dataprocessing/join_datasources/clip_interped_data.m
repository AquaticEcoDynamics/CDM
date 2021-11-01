function outdata = clip_interped_data(indata,clipdata);

alldate = indata.Date;
clipdate = clipdata.Date;

outdata = clipdata;
outdata.Date = [];
outdata.Data = [];
outdata.Depth = [];

int = 1;

for i = 1:length(clipdate)
    
    [val_raw,ind]  = min(abs(alldate - clipdate(i)));
    
%     val = clipdate(i) - val_raw;
%     val_raw
%     val
%    stop
    if val_raw < 2
    
        outdata.Date(int,1) = alldate(ind);
        outdata.Data(int,1) = indata.Data(ind);
        outdata.Depth(int,1) = indata.Depth(ind);
        
        int = int + 1;
    
    end
end
