
clear; close all;

shpfile='Coorong_line.shp';
shp=shaperead(shpfile);

int=500;

xx0=shp(1).X;
yy0=shp(1).Y;

xx=xx0; %(end:-1:1);
yy=yy0; %(end:-1:1);


%newx(1)=xx(1);
%newy(1)=yy(1);

inc=1;

for ii=3:length(xx)-1
    dist=sqrt((xx(ii)-xx(ii-1)).^2+(yy(ii)-yy(ii-1)).^2);
    r=floor(dist/int);
    
    if r>0
        for jj=0:r
            newx(inc)=xx(ii-1)+jj*int*(xx(ii)-xx(ii-1))/dist;
            newy(inc)=yy(ii-1)+jj*int*(yy(ii)-yy(ii-1))/dist;
            inc=inc+1;
        end
    else
        newx(inc)=xx(ii-1);
        newy(inc)=yy(ii-1);
        inc=inc+1;
    end
end
    
for kk=1:length(newx)
shp2(kk).Geometry='Point';
shp2(kk).X=newx(kk);
shp2(kk).Y=newy(kk);
end

shapewrite(shp2,'Transect_Coorong.shp');

