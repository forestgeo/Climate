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

%%% Data set parameters
%CRU:
CRU_start=1901;
CRU_end=2019;
CRU_file_ext='.1901.2019-ForestGEO_sites-6-03.csv';

%PRISM:
PRISM_start=1930;
PRISM_end=2015;
PRISM_file_ext='_1930-2015.csv';

%% CYCLE THROUGH SITE-VARIABLE COMPARISONS & CORRECTIONS
for n=1:height(CC)
    
%%% READ IN CRU DATA
ClimV_CRU=cell2mat(CC.ClimV_CRU(n)); %identify variables to be used
Site_CRU=cell2mat(CC.Site_CRU(n)); %CRU site name
% read in CRU data table
cd(CRU_data_dir);
CRU_table=readtable(strcat(ClimV_CRU,CRU_file_ext));
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
sgtitle (strcat(cell2mat(CC.ClimV_CRU(n)),' -  ', cell2mat(CC.Site_CRU(n))),  'Interpreter', 'none')

figure (100+n)
for m=1:12
    subplot (3,4,m)
    %plot (CRU_matrix (m,:), ALT_CRUyrs(m,:),'ok'); hold on;
    plot (CRU_ALTyrs(m,:), ALT_matrix(m,:),'ok'); hold on;
    p = polyfit(CRU_ALTyrs(m,:)', ALT_matrix(m,:)',1);
    regline=refline(p(1), p(2));
    regline.Color='k';
    OneOneline=refline(1,0);
    OneOneline.Color='b';
    ylabel (alt_name);
    xlabel ('CRU');
    title (strcat('month = ',num2str(m)));
end
sgtitle (strcat(cell2mat(CC.ClimV_CRU(n)),' -  ', cell2mat(CC.Site_CRU(n))), 'Interpreter', 'none')


%%% CREATE CORRECTED MONTHLY RECORD IN CRU FORMAT

%%% REPLACE ORIGINAL CRU RECORD WITH CORRECTED VARIABLE, WRITE OUTPUT FILE

end
