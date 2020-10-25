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
CRU_corrected_dir='/Users/kteixeira/Dropbox (Smithsonian)/GitHub/ForestGEO/Climate/CRU_corrected/';
PRISM_high_res_dir='/Users/kteixeira/Dropbox (Smithsonian)/GitHub/ForestGEO/Climate_Private/PRISM data/';

%% CYCLE THROUGH SITE-VARIABLE COMPARISONS & CORRECTIONS
for n=1:height(CC)
    
%%% READ IN CRU DATA
ClimV_CRU=cell2mat(CC.ClimV_CRU(n)); %identify variables to be used
Site_CRU=cell2mat(CC.Site_CRU(n)); %CRU site name
% read in CRU data table
cd(CRU_data_dir);
CRU_table=readtable(strcat(ClimV_CRU,'.1901.2019-ForestGEO_sites-6-03.csv'));
CRU_site_record= CRU_table(strcmp(Site_CRU, CRU_table.sites_sitename)==1, 2:end); % pulls out row corresponding to site of interest
CRU_matrix=reshape(table2array(CRU_site_record), [12, 2019-1901+1]); % creates matrix with months as rows, years as columns
CRU_year=linspace(1901,2019,2019-1901+1);

%%% READ IN ALTERNATIVE DATA
if strcmp(CC.Source_alt, "PRISM")==1 %PRISM high-res comparison
    alt_name='PRISM';
    ClimV_PRISM=cell2mat(CC.ClimV_alt(n));
    Site_PRISM=cell2mat(CC.Site_alt(n)); %PRISM site name
    % read in PRISM data table
    cd(PRISM_high_res_dir);
    PRISM_table=readtable(strcat('PRISM_',ClimV_PRISM,'_1930-2015.csv'));
    PRISM_index= strcmp(Site_PRISM, PRISM_table.Site) + strcmp(CC.cellPosition(n), PRISM_table.cellPosition)==2; %find PRISM record for desired site and cell position
    PRISM_site_record= PRISM_table(PRISM_index, 3:end); % pull out row corresponding to site of interest
    ALT_matrix=reshape(table2array(PRISM_site_record), [12, 2015-1930+1]); % create matrix with months as rows, years as columns
    ALT_year=linspace(1930,2015, 2015-1930+1);
end

%%% CREATE COMPARISON PLOTS
figure (n)
for m=1:12
    subplot (3,4,m)
    plot (CRU_year, CRU_matrix (m,:)); hold on;
    plot (ALT_year, ALT_matrix (m,:));
    ylabel (cell2mat(CC.ClimV_CRU(n)))
    title (strcat('month = ',num2str(m)))
    xlabel ('year')
end
legend ('CRU', alt_name)
sgtitle (strcat(cell2mat(CC.ClimV_CRU(n)),' -  ', cell2mat(CC.Site_CRU(n))))




%%% CREATE CORRECTED MONTHLY RECORD IN CRU FORMAT

%%% REPLACE ORIGINAL CRU RECORD WITH CORRECTED VARIABLE, WRITE OUTPUT FILE

end
