%% Project: AOD, Aerosol Type, PM2.5 and Air Mass Trajectory Analysis
%% Description: This project integrates satellite-derived aerosol products, atmospheric wind fields, and air mass trajectories to analyze the spatial distribution of aerosols and their transport patterns.

clear all;close all;clc;
height='500m';
%pressure='700';
addpath /Volumes/YUCHIHUANG/Matlab/m_map
load('time_date.mat');


heightlevel=[3000 2500 2250 2000 1750 1500 1250 1000 750 500 250 0];
%pressurelevel=[975 950 925 900 875 850 825 800 775 750 725 700];

file_trajA=append('GIS_traj_',height,'/GIS_*.txt');
A=dir(file_trajA);
filename_trajA=append(A.folder,'/',A.name);
rawdata_trajA=readmatrix(filename_trajA);
rawdata_trajA(end,:)=[];
rawdata_trajA=flip(rawdata_trajA);
timeA=datetime(2019,10,29,20,0,0);
%timeA=datetime(2017,12,24,16,0,0);
time_UTC_trajA=timeA-hours(rawdata_trajA(:,1)-1000);
time_LC_trajA=time_UTC_trajA+hours(8);
rawdata_trajA(:,1)=[];

file_trajB=append('GIS_traj_',height,'_forward/GIS_*.txt');
A=dir(file_trajB);
filename_trajB=append(A.folder,'/',A.name);
rawdata_trajB=readmatrix(filename_trajB);
rawdata_trajB(end,:)=[];
rawdata_trajB(1,:)=[];
time_UTC_trajB=timeA+hours(rawdata_trajB(:,1)-1000);
time_LC_trajB=time_UTC_trajB+hours(8);
rawdata_trajB(:,1)=[];

time_UTC_traj=[time_UTC_trajA;time_UTC_trajB];
time_LC_traj=[time_LC_trajA;time_LC_trajB];
rawdata_traj=[rawdata_trajA;rawdata_trajB];

time_UTC_traj(189:end,:)=[];
time_LC_traj(189:end,:)=[];
rawdata_traj(189:end,:)=[];
time_UTC_traj(1:92,:)=[];
time_LC_traj(1:92,:)=[];
rawdata_traj(1:92,:)=[];
spec_traj=find(time_UTC_traj==timeA);
time=time_LC_traj(1):days(1):time_LC_traj(end-23);

[yy,mm,dd] = ymd(time(1));
year_str_spec=num2str(yy);
month_str_spec=num2str(mm);
filename_wind=append('wind',year_str_spec,month_str_spec);
lon_wind=ncread(filename_wind,'longitude');
lat_wind=ncread(filename_wind,'latitude');
time_wind=ncread(filename_wind,'time');
pressurelevel=ncread(filename_wind,'level');
date1900=datetime(1900,1,1,0,0,0);
date_wind=date1900+hours(time_wind);
u_all=ncread(filename_wind,'u');
v_all=ncread(filename_wind,'v');
lon_wind=double(lon_wind);lat_wind=double(lat_wind);
pressurelevel=double(pressurelevel);


for i=1:length(time)
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
time_now=append(year_str,month_str,day_str);
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

traj_height_mean=mean(traj_height,'omitnan');
[~,pressure_index]=min(abs(heightlevel-traj_height_mean));
%pressure_index=8;
pressure=string(pressurelevel(pressure_index));

%% wind
    LC_time=time(i)-hours(8);
    time_specA=find(date_wind==LC_time);
    time_specB=time_specA+23;
    u_spec=squeeze(u_all(:,:,pressure_index,time_specA:time_specB));
    v_spec=squeeze(v_all(:,:,pressure_index,time_specA:time_specB));
    u=mean(u_spec,3,'omitnan');
    v=mean(v_spec,3,'omitnan');
    [Lat_wind,Lon_wind]=meshgrid(lat_wind,lon_wind);

%% savename
title_name1=append(year_str,'/',month_str,'/',day_str,' AOD with ',pressure,'hPa wind');
title_name2=append('      ',year_str,'/',month_str,'/',day_str,' Aerosol Type with ',pressure,'hPa wind');
title_name3=append(year_str,'/',month_str,'/',day_str,' PM_{2.5} with ',pressure,'hPa wind');
save_name1=append('AOD.png');
save_name2=append('Type.png');
save_name3=append('PM.png');

%% figure
%% AOD
f=figure(1);
f.Position(3:4) = [500 600];
subplot('position',[0.12 0.4 0.85 0.55]);
m_proj('miller','lat',[10 50],'long',[90 140]);
m_pcolor(Y,X,dcAODData660);
m_coast('linewidth',1,'color',"#0072BD");
m_grid('box','on','tickdir','out','FontSize',14,'FontName','Times New Roman');
colormap(mycolor);
colorbar('FontSize',14,'FontName','Times New Roman');
clim([0 2]);
hold on
d=10;
m_quiver(Lon_wind(1:d:end,1:d:end),Lat_wind(1:d:end,1:d:end),u(1:d:end,1:d:end),v(1:d:end,1:d:end),'k','linewidth',1);
hold on
m_line(rawdata_traj(:,1),rawdata_traj(:,2),'linewi',3,'color','r');
hold on
m_line(traj_Y(1:6:end),traj_X(1:6:end),'linewi',1.5,'color','r','linest','none','marker','o','markerfacecolor','w','markersize',8);
hold on
m_line(rawdata_traj(spec_traj,1),rawdata_traj(spec_traj,2),'linewi',1.5,'color','r','linest','none','marker',"pentagram",'markerfacecolor','w','MarkerSize',13);
title(title_name1,'FontSize',23,'FontName','Times New Roman');
% Height
subplot('position',[0.12 0.07 0.8 0.25]);
plot(time_LC_traj,rawdata_traj(:,3),'r','linewidth',1.5);
hold on
if isempty(traj_height)
        %
else
    plot(traj_time(1:6:end),traj_height(1:6:end),'linewi',1.7,'LineStyle','none','Marker','o','MarkerEdgeColor','r','MarkerFaceColor','w','markersize',9);
end
hold on
plot(time_LC_traj(spec_traj),rawdata_traj(spec_traj,3),'linewi',1.7,'LineStyle','none','Marker',"pentagram",'MarkerEdgeColor','r','MarkerFaceColor','w','MarkerSize',15)
set(gca,'FontSize',14,'FontName','Times New Roman');
title('Height of trajectories','FontSize',20,'FontName','Times New Roman')
xlabel('Time (MMM/dd)','Fontsize',16);ylabel('Height(m)','Fontsize',16);
saveas(gcf,save_name1);
close figure 1

%% Aerosol Type
f=figure(2);
f.Position(3:4) = [500 600];
subplot('position',[0.09 0.4 0.85 0.55]);
m_proj('miller','lat',[10 50],'long',[90 140]);
m_pcolor(Y,X,dctestall243);
m_coast('linewidth',1,'color',"#0072BD");
m_grid('box','on','tickdir','out','FontSize',14,'FontName','Times New Roman');
colormap(mycolor3);
p=lcolorbar({'DS','','≒ 0.7','','≒0.5','','≒ 0.3','','BB','','≒ 0.7','','≒ 0.5','','≒ 0.3','','AP','','≒ 0.7','','≒ 0.5','','≒ 0.3','','DS'},'fontsize',14,'fontweight','bold','FontName','Times New Roman');
p.Position(1)=p.Position(1)-0.03;
hold on
d=10;
m_quiver(Lon_wind(1:d:end,1:d:end),Lat_wind(1:d:end,1:d:end),u(1:d:end,1:d:end),v(1:d:end,1:d:end),'k','linewidth',1);
hold on
m_line(rawdata_traj(:,1),rawdata_traj(:,2),'linewi',3,'color','k');
hold on
m_line(traj_Y(1:6:end),traj_X(1:6:end),'linewi',1.5,'color','k','linest','none','marker','o','markerfacecolor','w','markersize',8);
hold on
m_line(rawdata_traj(spec_traj,1),rawdata_traj(spec_traj,2),'linewi',1.5,'color','k','linest','none','marker',"pentagram",'markerfacecolor','w','MarkerSize',13);
title(title_name2,'FontSize',23,'FontName','Times New Roman');
% Height
subplot('position',[0.12 0.07 0.8 0.25]);
plot(time_LC_traj,rawdata_traj(:,3),'color',"#0072BD",'linewidth',1.5);
hold on
if isempty(traj_height)
        %
else
    plot(traj_time(1:6:end),traj_height(1:6:end),'linewi',1.7,'LineStyle','none','Marker','o','MarkerEdgeColor',"#0072BD",'MarkerFaceColor','w','markersize',9);
end
hold on
plot(time_LC_traj(spec_traj),rawdata_traj(spec_traj,3),'linewi',1.7,'LineStyle','none','Marker',"pentagram",'MarkerEdgeColor',"#0072BD",'MarkerFaceColor','w','MarkerSize',15)
set(gca,'FontSize',14,'FontName','Times New Roman');
title('Height of trajectories','FontSize',20,'FontName','Times New Roman')
xlabel('Time (MMM/dd)');ylabel('Height(m)');
saveas(gcf,save_name2);
close figure 2


%% PM2.5
f=figure(3);
f.Position(3:4) = [500 650];
subplot('position',[0.12 0.4 0.85 0.55]);
m_proj('miller','lat',[10 50],'long',[90 140]);
m_pcolor(Y,X,PM_AOD);
m_coast('linewidth',1,'color',"#0072BD");
m_grid('box','on','tickdir','out','FontSize',14,'FontName','Times New Roman');
colormap(mycolor);
colorbar('FontSize',14,'FontName','Times New Roman');
clim([0 100]);
hold on
d=10;
m_quiver(Lon_wind(1:d:end,1:d:end),Lat_wind(1:d:end,1:d:end),u(1:d:end,1:d:end),v(1:d:end,1:d:end),'k','linewidth',1);
hold on
m_line(rawdata_traj(:,1),rawdata_traj(:,2),'linewi',3,'color','r');
hold on
m_line(traj_Y(1:6:end),traj_X(1:6:end),'linewi',1.5,'color','r','linest','none','marker','o','markerfacecolor','w','markersize',8);
hold on
m_line(rawdata_traj(spec_traj,1),rawdata_traj(spec_traj,2),'linewi',1.5,'color','r','linest','none','marker',"pentagram",'markerfacecolor','w','MarkerSize',13);
title(title_name3,'FontSize',23,'FontName','Times New Roman');
% Height
subplot('position',[0.12 0.07 0.8 0.25]);
plot(time_LC_traj,rawdata_traj(:,3),'r','linewidth',1.5);
hold on
if isempty(traj_height)
        %
else
    plot(traj_time(1:6:end),traj_height(1:6:end),'linewi',1.7,'LineStyle','none','Marker','o','MarkerEdgeColor','r','MarkerFaceColor','w','markersize',9);
end
hold on
plot(time_LC_traj(spec_traj),rawdata_traj(spec_traj,3),'linewi',1.7,'LineStyle','none','Marker',"pentagram",'MarkerEdgeColor','r','MarkerFaceColor','w','MarkerSize',15)
set(gca,'FontSize',14,'FontName','Times New Roman');
title('Height of trajectories','FontSize',20,'FontName','Times New Roman')
xlabel('Time (MMM/dd)');ylabel('Height(m)');
saveas(gcf,save_name3);
close figure 3
end
