clear all; close all;

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));


salt = tfv_readBCfile('Salt_Creek_20120101_20220101.csv');

salt.ML = salt.FLOW * (86400/1000);

save salt.mat salt -mat;
