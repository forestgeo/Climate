% Purpose: Compare CRU data with other climate data, correct when appropriate
% Author: Kristina Anderson-Teixeira
% Date: October 2020
%%%%%%%%%

%% INITIATE
clear all; clf; clc; clear; close all;

%% SETTINGS
%%% identify sites and variables to compare and correct
CC = readtable('variables_sites_for_CC.csv');

%%% Directories
CRU_data_dir='/Users/kteixeira/Dropbox (Smithsonian)/GitHub/ForestGEO/Climate/Climate_Data/CRU/CRU_v4_04/';
CRU_corrected_dir='/Users/kteixeira/Dropbox (Smithsonian)/GitHub/ForestGEO/Climate/Climate_Data/CRU/CRU_corrected/';
PRISM_high_res_dir='/Users/kteixeira/Dropbox (Smithsonian)/GitHub/ForestGEO/Climate_Private/PRISM data/';

%%% Data set parameters
%CRU:
CRU_start=1901;
CRU_end=2019;
CRU_file_ext='.1901.2019-ForestGEO_sites-6-03.csv';

%PRISM:
PRISM_start=1930;
PRISM_end=2015;
PRISM_file_ext='_1930-2015.csv';

%% initialize some variables
tmn_corrected=0;
tmp_corrected=0;
tmx_corrected=0;
pre_corrected=0;

%% CYCLE THROUGH SITE-VARIABLE COMPARISONS & CORRECTIONS
for n=1:height(CC)
    
%%% READ IN CRU DATA
ClimV_CRU=cell2mat(CC.ClimV_CRU(n)); %identify variables to be used
Site_CRU=cell2mat(CC.Site_CRU(n)); %CRU site name

if strcmp(ClimV_CRU, 'tmn') + tmn_corrected ==2 %if variable has already been run, select corrected matrix
    CRU_table=CRU_tmn_corrected;
elseif strcmp(ClimV_CRU, 'tmp') + tmp_corrected ==2 
    CRU_table=CRU_tmp_corrected;
elseif strcmp(ClimV_CRU, 'tmx') + tmx_corrected ==2 
    CRU_table=CRU_tmx_corrected;
elseif strcmp(ClimV_CRU, 'pre') + pre_corrected ==2 
    CRU_table=CRU_pre_corrected;
else % read in CRU data table
    cd(CRU_data_dir);
    CRU_table=readtable(strcat(ClimV_CRU,CRU_file_ext));
end

CRU_site_record= CRU_table(strcmp(Site_CRU, CRU_table.sites_sitename)==1, 2:end); % pulls out row corresponding to site of interest
CRU_matrix=reshape(table2array(CRU_site_record), [12, CRU_end-CRU_start+1]); % creates matrix with months as rows, years as columns
CRU_year=linspace(CRU_start,CRU_end,CRU_end-CRU_start+1);
CRU_table2=cell2table(num2cell([CRU_year; CRU_matrix]'),'VariableNames',{'Year' 'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec'});

%%% READ IN ALTERNATIVE DATA
if strcmp(CC.Source_alt, "PRISM")==1 %PRISM high-res comparison
    alt_name='PRISM';
    ClimV_PRISM=cell2mat(CC.ClimV_alt(n));
    Site_PRISM=cell2mat(CC.Site_alt(n)); %PRISM site name
    % read in PRISM data table
    cd(PRISM_high_res_dir);
    PRISM_table=readtable(strcat('PRISM_',ClimV_PRISM,PRISM_file_ext));
    PRISM_index= strcmp(Site_PRISM, PRISM_table.Site) + strcmp(CC.cellPosition(n), PRISM_table.cellPosition)==2; %find PRISM record for desired site and cell position
    PRISM_site_record= PRISM_table(PRISM_index, 3:end); % pull out row corresponding to site of interest
    ALT_matrix=reshape(table2array(PRISM_site_record), [12, PRISM_end-PRISM_start+1]); % create matrix with months as rows, years as columns
    ALT_year=linspace(PRISM_start,PRISM_end, PRISM_end-PRISM_start+1);
    ALT_CRUyrs=cat(2, NaN*ones(12, PRISM_start-CRU_start), ALT_matrix, NaN*ones(12, CRU_end-PRISM_end));
    ALT_table2=cell2table(num2cell([CRU_year; ALT_CRUyrs]'),'VariableNames',{'Year' 'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec'});
    CRU_ALTyrs=CRU_matrix(:, PRISM_start-CRU_start+1:length(CRU_matrix)-(CRU_end-PRISM_end));
end

%%% CREATE CORRECTED MONTHLY RECORD IN CRU FORMAT
CRU_corrected0_matrix=CRU_matrix;

for m=1:12
    p = polyfit(CRU_ALTyrs(m,:)', ALT_matrix(m,:)',1); %regression between CRU & ALT variable
    CRU_corrected0_matrix(m,:)=CRU_matrix(m,:)*p(1)+p(2);  %fill matrix based on CRU-ALT regression
end

CRU_corrected_matrix=CRU_corrected0_matrix; %create second matrix that will use original ALT variable data
CRU_corrected_matrix(:,PRISM_start-CRU_start+1:length(CRU_matrix)-(CRU_end-PRISM_end))=ALT_matrix;


%%% CREATE PLOTS
figure (n)
for m=1:12
    subplot (3,4,m)
    plot (CRU_year, CRU_matrix (m,:), 'k', CRU_year, CRU_corrected0_matrix (m,:), 'b',CRU_year,  CRU_corrected_matrix (m,:), 'c'); hold on;
    plot (ALT_year, ALT_matrix (m,:));
    ylabel (cell2mat(CC.ClimV_CRU(n)))
    title (strcat('month = ',num2str(m)))
    xlabel ('year')
end
legend ('CRU','CRU-corrected0', 'CRU-corrected', alt_name)
sgtitle (strcat(cell2mat(CC.ClimV_CRU(n)),' -  ', cell2mat(CC.Site_CRU(n))),  'Interpreter', 'none')

figure (100+n)
for m=1:12
    subplot (3,4,m)
    plot (ALT_matrix(m,:), CRU_ALTyrs(m,:), 'ok'); hold on;
    plot (ALT_CRUyrs(m,:), CRU_corrected0_matrix(m,:),  'ob')
    %regline=refline(p(1), p(2));
    %regline.Color='k';
    OneOneline=refline(1,0);
    OneOneline.Color='b';
    xlabel (alt_name);
    ylabel ('CRU');
    title (strcat('month = ',num2str(m)));
end
legend ('CRU', 'CRU-corrected0', '1:1 line')
sgtitle (strcat(cell2mat(CC.ClimV_CRU(n)),' -  ', cell2mat(CC.Site_CRU(n))), 'Interpreter', 'none')


%%% REPLACE ORIGINAL CRU RECORD WITH CORRECTED VARIABLE, WRITE OUTPUT FILE
CRU_table_corrected=CRU_table; %this is a table in corrected value will be pasted
%transform CRU_corrected_matrix to vector:
CRU_corrected_vector=reshape(CRU_corrected_matrix,1,[]); % convert matrix to row vector
%...then paste this vector in CRU_table_corrected:
CRU_table_corrected (strcmp(Site_CRU, CRU_table.sites_sitename)==1,2:end)=array2table(CRU_corrected_vector);

%save matrix for climate variable, as it may be corrected for multiple sites
if strcmp(ClimV_CRU, 'tmn')==1
    CRU_tmn_corrected=CRU_table_corrected;
    tmn_corrected=1;
elseif strcmp(ClimV_CRU, 'tmp')==1
    CRU_tmp_corrected=CRU_table_corrected;
    tmp_corrected=1;
elseif strcmp(ClimV_CRU, 'tmx')==1
    CRU_tmx_corrected=CRU_table_corrected;
    tmx_corrected=1;
elseif strcmp(ClimV_CRU, 'pre')==1
    CRU_pre_corrected=CRU_table_corrected;
    pre_corrected=1;
end

end

%write out corrected matrices
cd(CRU_corrected_dir)
writetable(CRU_tmn_corrected,'tmn_CRU_corrected.csv')
writetable(CRU_tmp_corrected,'tmp_CRU_corrected.csv')
writetable(CRU_tmx_corrected,'tmx_CRU_corrected.csv')
writetable(CRU_pre_corrected,'pre_CRU_corrected.csv')
