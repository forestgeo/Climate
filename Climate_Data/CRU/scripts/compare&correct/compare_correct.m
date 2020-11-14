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
PRISM_high_res_dir='/Users/kteixeira/Dropbox (Smithsonian)/GitHub/ForestGEO/Climate_Private/PRISM data/';
El_Claro_dir='/Users/kteixeira/Dropbox (Smithsonian)/GitHub/ForestGEO/Climate/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/';
CRU_corrected_dir='/Users/kteixeira/Dropbox (Smithsonian)/GitHub/ForestGEO/Climate/Climate_Data/CRU/CRU_corrected/';
CRU_corrected_figures_dir='/Users/kteixeira/Dropbox (Smithsonian)/GitHub/ForestGEO/Climate/Climate_Data/CRU/CRU_corrected/figures/';


%%% Data set parameters
%CRU:
CRU_start=1901;
CRU_end=2019;
CRU_file_ext='.1901.2019-ForestGEO_sites-6-03.csv';

%PRISM:
PRISM_start=1930;
PRISM_end=2015;
PRISM_file_ext='_1930-2015.csv';

%El_Claro (BCI)
EC_start=1929;
EC_end=2019;

%% READ IN CLIMATE DATA
%CRU
cd(CRU_data_dir);
CRU_tmn=readtable(strcat('tmn',CRU_file_ext));
CRU_tmp=readtable(strcat('tmp',CRU_file_ext));
CRU_tmx=readtable(strcat('tmx',CRU_file_ext));
CRU_pre=readtable(strcat('pre',CRU_file_ext));
CRU_wet=readtable(strcat('wet',CRU_file_ext));
CRU_pet=readtable(strcat('pet',CRU_file_ext));
CRU_pet_sum=readtable(strcat('pet_sum',CRU_file_ext));
CRU_dtr=readtable(strcat('dtr',CRU_file_ext));
CRU_frs=readtable(strcat('frs',CRU_file_ext));

%% initialize some variables
tmn_corrected=0;
tmp_corrected=0;
tmx_corrected=0;
pre_corrected=0;
mean_CRUmALT=NaN*ones(height(CC),12);
CRU_ALT_different=NaN*ones(height(CC),1);
cons_correct=NaN*ones(height(CC),1);

distrust_T=0*ones(height(CRU_tmn),1); %vector to mark distrusted T values (any T variable)
distrust_PPT=0*ones(height(CRU_tmn),1); %vector to mark distrusted PPT values

%% CYCLE THROUGH SITE-VARIABLE COMPARISONS & CORRECTIONS
for n=1:height(CC)
if CC.compare(n)==1
    
%%% READ IN CRU DATA
ClimV_CRU=cell2mat(CC.ClimV_CRU(n)); %identify variables to be used
Site_CRU=cell2mat(CC.Site_CRU(n)); %CRU site name

if strcmp(ClimV_CRU, 'tmn')==1 
    if tmn_corrected ==1 %if variable has already been run, select corrected matrix
        CRU_table=CRU_tmn_corrected_all;
        CRU_table_cons=CRU_tmn_corrected_conservative;
    else
        CRU_table=CRU_tmn;
        CRU_table_cons=CRU_tmn;
    end
elseif strcmp(ClimV_CRU, 'tmp') ==1
    if tmp_corrected ==1 %if variable has already been run, select corrected matrix
        CRU_table=CRU_tmp_corrected_all;
        CRU_table_cons=CRU_tmp_corrected_conservative;
    else
        CRU_table=CRU_tmp;
        CRU_table_cons=CRU_tmp;
    end
elseif strcmp(ClimV_CRU, 'tmx') ==1
    if tmx_corrected ==1 %if variable has already been run, select corrected matrix
        CRU_table=CRU_tmx_corrected_all;
        CRU_table_cons=CRU_tmx_corrected_conservative;
    else
        CRU_table=CRU_tmx;
        CRU_table_cons=CRU_tmx;
    end
elseif strcmp(ClimV_CRU, 'pre') ==1
    if pre_corrected ==1 %if variable has already been run, select corrected matrix
        CRU_table=CRU_pre_corrected_all;
        CRU_table_cons=CRU_pre_corrected_conservative;
    else
        CRU_table=CRU_pre;
        CRU_table_cons=CRU_pre;
    end

end

CRU_site_index=find(strcmp(Site_CRU, CRU_table.sites_sitename)==1);
CRU_site_record= CRU_table(CRU_site_index, 2:end); % pulls out row corresponding to site of interest
CRU_matrix=reshape(table2array(CRU_site_record), [12, CRU_end-CRU_start+1]); % creates matrix with months as rows, years as columns
CRU_year=linspace(CRU_start,CRU_end,CRU_end-CRU_start+1);
CRU_table2=cell2table(num2cell([CRU_year; CRU_matrix]'),'VariableNames',{'Year' 'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec'});

%%% READ IN ALTERNATIVE DATA
ClimV_alt=cell2mat(CC.ClimV_alt(n));
Site_alt=cell2mat(CC.Site_alt(n)); %PRISM site name
if strcmp(CC.Source_alt(n), "PRISM")==1 %PRISM high-res comparison
    alt_name='PRISM';
    ALT_start=PRISM_start;
    ALT_end=PRISM_end;
    % read in PRISM data table
    cd(PRISM_high_res_dir);
    PRISM_table=readtable(strcat('PRISM_',ClimV_alt,PRISM_file_ext));
    PRISM_index= strcmp(Site_alt, PRISM_table.Site) + strcmp(CC.cellPosition(n), PRISM_table.cellPosition)==2; %find PRISM record for desired site and cell position
    PRISM_site_record= PRISM_table(PRISM_index, 5:end); % pull out row corresponding to site of interest
    ALT_matrix=reshape(table2array(PRISM_site_record), [12, ALT_end-ALT_start+1]); % create matrix with months as rows, years as columns

elseif strcmp(CC.Source_alt(n), "El_Claro")==1
    alt_name="El_Claro";
    ALT_start=EC_start;
    ALT_end=EC_end;
    % read in El Claro data table
    cd(El_Claro_dir);
    El_Claro_table=readtable(strcat(ClimV_alt,'_BCI.csv'));
    El_Claro_record=El_Claro_table.climvar_val'; % pull out climate variable column 
    if strcmp(ClimV_alt,'wet')==1
        %currently a problem with wet_BCI.csv: missing months with 0 precip. 
        %This will have to be fixed here or, ideally, in the source file.
    end
    ALT_matrix=reshape(El_Claro_record, [12, ALT_end-ALT_start+1]); % create matrix with months as rows, years as columns
    
end

%%% CREATE PARALLEL MATRICES FOR CRU AND ALT
%%% matrix and table of ALT data for CRU years
ALT_CRUyrs=cat(2, NaN*ones(12, ALT_start-CRU_start), ALT_matrix, NaN*ones(12, CRU_end-ALT_end));
ALT_table2=cell2table(num2cell([CRU_year; ALT_CRUyrs]'),'VariableNames',{'Year' 'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec'});
%%% matrices with ALT years 
ALT_year=linspace(ALT_start,ALT_end, ALT_end-ALT_start+1); %alt_year vector
CRU_ALTyrs=CRU_matrix(:, ALT_start-CRU_start+1:length(CRU_matrix)-(CRU_end-ALT_end)); %CRU matrix limited to alt years

%%% CREATE CORRECTED MONTHLY RECORD IN CRU FORMAT
CRU_corrected0_matrix=CRU_matrix;

for m=1:12
    p = polyfit(CRU_ALTyrs(m,:)', ALT_matrix(m,:)',1); %regression between CRU & ALT variable
    CRU_corrected0_matrix(m,:)=CRU_matrix(m,:)*p(1)+p(2);  %fill matrix based on CRU-ALT regression
end

CRU_corrected_matrix=CRU_corrected0_matrix; %create second matrix that will use original ALT variable data
CRU_corrected_matrix(:,ALT_start-CRU_start+1:length(CRU_matrix)-(CRU_end-ALT_end))=ALT_matrix;
CRU_corrected_vector=reshape(CRU_corrected_matrix,1,[]); % convert matrix to row vector

%%% CALCULATE SOME STATS
ALT_monthly_means=mean(ALT_matrix,2);
CRU_monthly_means_ALTyrs=mean(CRU_ALTyrs,2);
mean_CRUmALT(n,:)=ALT_monthly_means'-CRU_monthly_means_ALTyrs';
meanCRUmALT=mean(mean_CRUmALT,2); %mean of monthly temp differences
CRU_ALT_different(n)=ttest(table2array(CRU_site_record),CRU_corrected_vector);

%%% CREATE PLOTS
f1=figure ('visible','off');
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
cd(CRU_corrected_figures_dir)
print(f1,strcat(cell2mat(CC.ClimV_CRU(n)),' -  ', cell2mat(CC.Site_CRU(n)),'-ts'),'-dpng')

f2=figure ('visible','off');
for m=1:12
    subplot (3,4,m)
    plot (ALT_matrix(m,:), CRU_ALTyrs(m,:), 'ok'); hold on;
    plot (ALT_CRUyrs(m,:), CRU_corrected0_matrix(m,:),  'ob')
    OneOneline=refline(1,0);
    OneOneline.Color='b';
    xlabel (alt_name, 'Interpreter', 'none');
    ylabel ('CRU');
    title (strcat('month = ',num2str(m)));
end
legend ('CRU', 'CRU-corrected0', '1:1 line')
sgtitle (strcat(cell2mat(CC.ClimV_CRU(n)),' -  ', cell2mat(CC.Site_CRU(n))), 'Interpreter', 'none')
print(f2, strcat(cell2mat(CC.ClimV_CRU(n)),' -  ', cell2mat(CC.Site_CRU(n)),'-corr'),'-dpng')

%%% REPLACE ORIGINAL CRU RECORD WITH CORRECTED VARIABLE 
%create tables into which corrected values will be pasted
CRU_table_corrected_all=CRU_table; %all in CC
CRU_table_corrected_conservative=CRU_table_cons; %conservative (if correct=1 in CC)

%paste CRU_corrected_vector in CRU_table_corrected:
%correct all:
CRU_table_corrected_all (strcmp(Site_CRU, CRU_table.sites_sitename)==1,2:end)=array2table(CRU_corrected_vector);

%correct only a subset
if CRU_ALT_different(n)==1 %only eligible for correction of t-test is sig
    if strcmp(ClimV_CRU,'pre')==1 && abs(meanCRUmALT(n))>20 % for pre, replace if off by >20mm/mo (note that a higher threshold would require force correction of BCI PRE). 
        cons_correct(n)=1;
        distrust_PPT(CRU_site_index)=1;
    elseif strcmp(ClimV_CRU,'pre')~=1 && abs(meanCRUmALT(n))>2.5 % >2.5 degrees T difference --> replace
        cons_correct(n)=1;
        distrust_T(CRU_site_index)=1;
    else
        cons_correct(n)=0;
    end
else
    cons_correct(n)=0;
end
if cons_correct(n)==1 % conservative  (sig differences only)
    CRU_table_corrected_conservative (strcmp(Site_CRU, CRU_table.sites_sitename)==1,2:end)=array2table(CRU_corrected_vector);
end
    
%save matrix for climate variable, as it may be corrected for multiple sites
if strcmp(ClimV_CRU, 'tmn')==1
    CRU_tmn_corrected_all=CRU_table_corrected_all;
    CRU_tmn_corrected_conservative=CRU_table_corrected_conservative;
    tmn_corrected=1;
elseif strcmp(ClimV_CRU, 'tmp')==1
    CRU_tmp_corrected_all=CRU_table_corrected_all;
    CRU_tmp_corrected_conservative=CRU_table_corrected_conservative;
    tmp_corrected=1;
elseif strcmp(ClimV_CRU, 'tmx')==1
    CRU_tmx_corrected_all=CRU_table_corrected_all;
    CRU_tmx_corrected_conservative=CRU_table_corrected_conservative;
    tmx_corrected=1;
elseif strcmp(ClimV_CRU, 'pre')==1
    CRU_pre_corrected_all=CRU_table_corrected_all;
    CRU_pre_corrected_conservative=CRU_table_corrected_conservative;
    pre_corrected=1;
end


end
end

%% READ IN CRU VARIABLES WITH NO ALTERATIVE SOURCE, REMOVE UNRELIABLE RECORDS
% Specifically,...
% - if T variables are substantially off, we don't trust PET, DTR, FRS
CRU_pet{logical(distrust_T), 2:end}=NaN;
CRU_pet_sum{logical(distrust_T), 2:end}=NaN;
CRU_dtr{logical(distrust_T), 2:end}=NaN;
CRU_frs{logical(distrust_T), 2:end}=NaN;

% - if PPT is substantially off, we don't trust WET
CRU_wet{logical(distrust_PPT), 2:end}=NaN;

% - not currently making corrected versions of CLD or VAP



%% WRITE OUT CORRECTED MATRICES
cd(CRU_corrected_dir)
if tmn_corrected==1
writetable(CRU_tmn_corrected_all,'tmn_CRU_corrected_all.csv')
writetable(CRU_tmn_corrected_conservative,'tmn_CRU_corrected_conservative.csv')
end
if tmp_corrected==1
writetable(CRU_tmp_corrected_all,'tmp_CRU_corrected_all.csv')
writetable(CRU_tmp_corrected_conservative,'tmp_CRU_corrected_conservative.csv')
end
if tmx_corrected==1
writetable(CRU_tmx_corrected_all,'tmx_CRU_corrected_all.csv')
writetable(CRU_tmx_corrected_conservative,'tmx_CRU_corrected_conservative.csv')
end
if pre_corrected==1
writetable(CRU_pre_corrected_all,'pre_CRU_corrected_all.csv')
writetable(CRU_pre_corrected_conservative,'pre_CRU_corrected_conservative.csv')
end

%Other tables:
writetable(CRU_pet,'pet_CRU_corrected_conservative.csv')
writetable(CRU_pet_sum,'pet_sum_CRU_corrected_conservative.csv')
writetable(CRU_frs,'frs_CRU_corrected_conservative.csv')
writetable(CRU_dtr,'dtr_CRU_corrected_conservative.csv')
writetable(CRU_wet,'wet_CRU_corrected_conservative.csv')

%% GENERATE AND WRITE OUT REPORT 
meanCRUmALT=mean(mean_CRUmALT,2); %mean of monthly temp differences
corrections_report=table(CC.Site_CRU,CC.ClimV_CRU,CC.Source_alt, cons_correct, CRU_ALT_different, meanCRUmALT);
corrections_report.Properties.VariableNames = {'Site' 'Climate Variable' 'Alternate Source' 'Corrected in _conservative' 'CRU and ALT differ in paired t-test?' 'Mean (CRU_monthly_mean-ALT_monthly_mean)'};

writetable(corrections_report,'corrections_report.csv')
disp('DONE!')