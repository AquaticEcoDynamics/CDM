function [time2,wst,hs,t3,x1,y1,depth]   = process_wavedata(wavefile,t1,t2,utmx,utmy)


x=ncread(wavefile,'x');
y=ncread(wavefile,'y');
time=ncread(wavefile,'time'); %/86400+datenum(1970,1,1);
time2=double(time)/86400+datenum(1970,1,1);

ind1=find(abs(time2-t1)==min(abs(time2-t1)));
ind2=find(abs(time2-t2)==min(abs(time2-t2)));

x1=find(abs(x-utmx)==min(abs(x-utmx)));
y1=find(abs(y-utmy)==min(abs(y-utmy)));


hs=ncread(wavefile,'hs',[1 1 ind1],[Inf Inf ind2-ind1]);
hs2=ncread(wavefile,'hs',[x1 y1 1],[1 1 Inf]);
wx=ncread(wavefile,'xwnd',[x1 y1 1],[1 1 Inf]);
wy=ncread(wavefile,'ywnd',[x1 y1 1],[1 1 Inf]);
depth = ncread(wavefile,'depth',[x1 y1 1],[1 1 Inf]);

wst=sqrt(wx.^2+wy.^2);

t3=time2(ind1:ind2-1);
