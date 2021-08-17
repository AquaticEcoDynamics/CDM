clear al; close all;

disp('Downloading site information');
sdata =  download_Site_Info;
disp('DONE');


[snum,sstr]  =xlsread('Vars.xlsx','A2:C100');

oldnames = sstr(:,1);
newnames = sstr(:,2);
conv = snum(:,1);

maindir = 'Output/';

dirlist = dir(maindir);




