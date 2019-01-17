clear all
ref=datenum('12/31/2012');

%SBC=importdata('D:\Projects\Metdata\other stations\SCB\SBC_Metdata_5min_2012.csv');
SBC=importdata('SBC_Metdata_5min_2013_10_30_15_21_18.csv');

N=length(SBC.data);
SBC.decday=datenum(SBC.textdata(5:end,1),'mm/dd/yyyy HH:MM')-ref;
SBC.Rs=SBC.data(:,2);
SBC.Rs(:,2)=SBC.data(:,4);
SBC.T_air=SBC.data(:,6);
SBC.T_air(:,2)=SBC.data(:,8);
SBC.RH=SBC.data(:,10);
SBC.WS=SBC.data(:,12);
SBC.WD=SBC.data(:,13);
SBC.WM=SBC.data(:,14);
SBC.PPT=SBC.data(:,17);
SBC.Asp_fan=SBC.data(:,22);
SBC.Batt_V=SBC.data(:,23);
%%%%%%%%%%%%%%%%%
figure(1);clf
plot(SBC.decday,SBC.Rs)
xlabel('time (decimal day)','Fontsize',14)
ylabel('Solar radiation (W m^-^2)','Fontsize',14)
figure(2);clf
plot(SBC.decday,SBC.T_air);hold all
xlabel('time (decimal day)','Fontsize',14)
ylabel('temperature (C)','Fontsize',14)
figure(3);clf
plot(SBC.decday,SBC.RH);hold all
xlabel('time (decimal day)','Fontsize',14)
ylabel('Relative humidity (%)','Fontsize',14)
figure(4);clf
plot(SBC.decday,SBC.WS)
xlabel('time (decimal day)','Fontsize',14)
ylabel('wind speed (m/s)','Fontsize',14)
use2=find(SBC.WS>1 & SBC.WS<10);
figure(5);clf
rose(SBC.WD(use2)/180*pi,50)
P1=nan(365,1);
for i=1:365
    use=find(floor(SBC.decday)==i);if ~isempty(use);
    P1(i,1)=sum(SBC.PPT(use));end
end
figure(6);clf
bar(1:365,P1)
 
figure(7);clf
figure(7);clf
plot(SBC.decday,SBC.Batt_V);hold all
xlabel('time (decimal day)','Fontsize',14)
ylabel('Battery voltage (V)','Fontsize',14)



