function out = grab_ALS_Data(fullname,outfile)

filename = [fullname.folder,'\',fullname.name];

fid = fopen(filename,'rt');

fidout = fopen('AWQC_Data_1B.csv', 'a+');

fline = fgetl(fid);
fline = fgetl(fid);
fline = fgetl(fid);
fline = fgetl(fid);


str = split(fline,',');

while ~feof(fid)
    fline = fgetl(fid);
    str = split(fline,',');
    
    
    thefile = fullname.name;
    thefolder = fullname.folder;
    thedate = str{2};
    thesite = str{5};
    
    thevar = regexprep(str{8},'"','');
    theval = str2double(str{9});
    
    if length(str) > 9
        theunits = str{10};
    else
        theunits = [];
    end
    
    
    fprintf(fidout,'%s,%s,%s,%s,%s,%s,%4.4f\n',thefile,thefolder,thesite,thevar,theunits,thedate,theval);
    
end
fclose(fid);
 fclose(fidout);
   
    
