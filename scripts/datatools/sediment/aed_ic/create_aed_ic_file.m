clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

gridflie = 'CoorongBGC_mesh_000.2dm';

[XX,YY,ZZ,nodeID,faces,X,Y,Z,ID,MAT,A] = tfv_get_node_from_2dm(gridflie);

fs1 = 0.4;

fid = fopen('AED_Benthic.csv','wt');

fprintf(fid,'ID,NCS_fs1\n');

for i = 1:length(ID)
    fprintf(fid,'%i,%4.4f\n',ID(i),fs1);
end
fclose(fid);