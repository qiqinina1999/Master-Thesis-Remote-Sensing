%% Project:　Air Mass Trajectory and Aerosol Type Analysis
%% Description: This project identifies and analyzes aerosol types along air mass trajectories by spatially matching trajectory coordinates with satellite-derived aerosol type data. The frequency of each aerosol type along the trajectories is then calculated.

clear all;close all;clc;
height='500m';


file_traj=append('GIS_*.txt');
A=dir(file_traj);
filename_traj=append(A.folder,'/',A.name);
rawdata_traj=readmatrix(filename_traj);
rawdata_traj(end,:)=[];
rawdata_traj=flip(rawdata_traj);
timeA=datetime(2017,12,24,16,0,0);
%timeA=datetime(2019,10,29,20,0,0);
time_UTC_traj=timeA-hours(rawdata_traj(:,1)-1000);
time_LC_traj=time_UTC_traj+hours(8);
rawdata_traj(:,1)=[];
%time_LC_traj(1:72,:)=[];
%time_UTC_traj(1:72,:)=[];
%rawdata_traj(1:72,:)=[];

time=time3:days(1):time4;
for i=4%:length(time)
yr=year(time(i));
mon=month(time(i));
dy=day(time(i));
if mon<10
    month_str=append('0',num2str(mon));
else
    month_str=num2str(mon);
end
if dy<10
    day_str=append('0',num2str(dy));
else
    day_str=num2str(dy);
end
year_str=num2str(yr);
time_now=append(year_str,month_str,day_str)
pressure='700';
title_name1=append(time_now,' AOD with ',pressure,'hPa wind');
title_name2=append('      ',time_now,' Aerosol Type with ',pressure,'hPa wind');
title_name3=append(time_now,' PM_{2.5} with ',pressure,'hPa wind');
save_name1=append('/AOD.png');
save_name2=append('/Type.png');
save_name3=append('/PM.png');
%% AOD
filename_AOD=append('*_10T3km.mat');
load(filename_AOD);

%% traj
traj_time_spec=find(time_LC_traj==time(i));
if time(i)==time_LC_traj(end) %最後一個時間段
    traj_time=nan;
    traj_X=nan;
    traj_Y=nan;
    traj_height=nan;
elseif isnan(traj_time_spec)
    traj_time=nan;
    traj_X=nan;
    traj_Y=nan;
    traj_height=nan;
else
    traj_time=time_LC_traj(traj_time_spec:(traj_time_spec+23));
    traj_X=rawdata_traj(traj_time_spec:(traj_time_spec+23),2);
    traj_Y=rawdata_traj(traj_time_spec:(traj_time_spec+23),1);
    traj_height=rawdata_traj(traj_time_spec:(traj_time_spec+23),3);
end
%% Find Aerosol Type
AerosolType=[];
for j=1:length(traj_X)
traj_X_spec=traj_X(j,1);
traj_Y_spec=traj_Y(j,1);
distance_X=abs(X-traj_X_spec);
distance_Y=abs(Y-traj_Y_spec);
[col_X,row_X]=find(distance_X==min(min(distance_X)));%row
[col_Y,row_Y]=find(distance_Y==min(min(distance_Y)));%col
AerosolType_a=dctestall243(col_Y(1),row_X(1));
AerosolType=[AerosolType;AerosolType_a];
end
AerosolType(isnan(AerosolType))=[];
Unique_Type=unique(AerosolType);
[m n]=hist(AerosolType,Unique_Type)
end

