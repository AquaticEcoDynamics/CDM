function out = grab_BGA_Data(fullname,numfile)

filename = [fullname.folder,'\',fullname.name];

fid = fopen(filename,'rt');
fline = fgetl(fid);

fidout = fopen('BGA_Data.csv', 'a+');
thefile = fullname.name;
thefolder = fullname.folder;

if numfile == 1
    
fprintf(fidout,'Filename,Foldername,%s\n',fline);

end



while ~feof(fid)
    
    fline = fgetl(fid);    
    fprintf(fidout,'%s,%s,%s\n',thefile,thefolder,fline);
    
end
fclose(fid);
fclose(fidout);
   
    
