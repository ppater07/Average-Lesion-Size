%% Function CalculateAverageLesionSize

% This function calculates the average size of SSB and DSB lesions. 
% I: 'dataFolder' is a string with the path of the folder dontaining the
% data files.

% O: 'SSBLesionSizes' and DSBLesionSizes' are M x 1 arrays with the average
%       lesion size of each of the M simulations found in 'dataFolder'
%    'simNames' is a M x 1 cell with the names of each simulation
%% Example of Use
% Ex: % dataFolder='/Users/Piotr/Documents/MATLAB_data/data/LionTrack/SourcesNewROI/angular/';

%% References
% Piotr PATER, McGill University , 
% date: 6/09/2015
     
function [SSBLesionSizes,DSBLesionSizes,simNames]=CalculateAverageLesionSize(dataFolder)

    e2=dir([strcat(dataFolder) '*MeV*']); % find all data files in the folder which have to contain a * MeV* in the name
    nSimulations=size(e2,1);
    simNames=cell(nSimulations,1);
    SSBLesionSizes=simNames;DSBLesionSizes=simNames;
    for iD=1:nSimulations % for each simulation

        simNames{iD}=e2(iD).name; %'H+001.00MeVu-1';
        p=[dataFolder simNames{iD} '/results/'];
        e=dir(strcat(p,'CsizeSource*.mat'));
        nAngles=size(e,1);
        averageSSBLesionSize=cell(1,nAngles);averageDSBLesionSize=averageSSBLesionSize;
        for i=1:nAngles %for each Angle
            loadedData=load([p e(i).name]); % Load CsizeSource
            % CsizeSource is a 1 x nFractions cell array. Each cell is an m
            % x 2 array with the first column corresponding to the damage type (0=nothing, 1=SSB, 2=DSB, 4=Bd)
            % and the second column to the size of the lesion
            SSBsizes=cellfun(@(x) x(x(:,1)==1,2),loadedData.CsizeSource,'UniformOutput',false);
            DSBsizes=cellfun(@(x) x(x(:,1)==2,2),loadedData.CsizeSource,'UniformOutput',false);
            
            averageSSBLesionSize{i}=mean(cell2mat(SSBsizes));
            averageDSBLesionSize{i}=mean(cell2mat(DSBsizes));
        end
        clear loadedData;
        w=0.5*sin([90:-10:0]*pi/180);
        tempSSB=cell2mat(averageSSBLesionSize');
        tempDSB=cell2mat(averageDSBLesionSize');
        SSBLesionSizes{iD}=sum(w.*tempSSB(:,1)')/sum(w);
        DSBLesionSizes{iD}=sum(w.*tempDSB(:,1)')/sum(w);
    end
    SSBLesionSizes=cell2mat(SSBLesionSizes);
    DSBLesionSizes=cell2mat(DSBLesionSizes);
end