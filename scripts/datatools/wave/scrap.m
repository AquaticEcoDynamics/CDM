rot = -43;

xStart=2.98e5;
yStart=6.065e6;
xLength=1.17e5;
yLength=1.45e4;
alpc=-43; % orientation tilt degrees
cell_size = 200;

 ygrid=yStart:200:yStart+yLength;
        [X,Y]=meshgrid(xgrid,ygrid);
        xyc=[xStart, yStart];
        angel = -43;
R = [cosd(angel), -sind(angel); sind(angel), cosd(angel)];
XY = xyc' + R * ([X(:) Y(:)]-xyc)';
XR = reshape(XY(1,:),size(X));
YR = reshape(XY(2,:),size(Y));
%figure(2);
pcolor(XR,YR,XR*0)