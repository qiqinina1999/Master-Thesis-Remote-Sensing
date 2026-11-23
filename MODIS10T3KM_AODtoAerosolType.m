%% Project: Retrieved Aerosol Type from Aerosol Optical Depth (AOD)
%% Description:  This project extracts the fractions of total aerosol optical depth (fAOD) contributed by major aerosol components (Desert Dust (DS), Biomass Burning (BB), and Anthropogenic Pollution (AP)) using the Normalized Derivative Aerosol Index (NDAI), following the method proposed by Lin et al. (2021).
"""

clear;clc; 
close all
tic
% Taiwan
%yrange=118:0.03:123;%
%xrange=21:0.03:26;
% East Asia
yrange=90:0.03:140;
xrange=10:0.03:50;
[X,Y] = meshgrid(xrange,yrange);%set lat lon range
MODISfilename=dir(['MOD04_L2.A20*.hdf'])

m = length(MODISfilename);

for f=1:m  %1:m 

 HI = {MODISfilename(f).name}

 KI=HI{1}(11:14);                                
 LI=HI{1}(15:17);

 jday=[KI,LI];
 date1=jl2normaldate(str2double(jday),'yyyymmdd')
 year=str2double(date1(1:4));
 month=str2double(date1(5:6));
 day=str2double(date1(7:8));

 %%  QR is a name to choose the parameter you need from the hdf file 
QR={'Optical_Depth_Land_And_Ocean' 
'Deep_Blue_Aerosol_Optical_Depth_550_Land'
'Angstrom_Exponent_Land'
'Angstrom_Exponent_1_Ocean'
'Angstrom_Exponent_2_Ocean'
'Longitude'
'Latitude'
'Deep_Blue_Spectral_Aerosol_Optical_Depth_Land'
'Optical_Depth_Large_Average_Ocean'
'Aerosol_Type_Land'       %(0=mixed, 1=dust, 2=sulfate, 3=smoke, 4=heavy absorbing smoke)
'Optical_Depth_Small_Land'
'Corrected_Optical_Depth_Land'
'Deep_Blue_Angstrom_Exponent_Land'
'Deep_Blue_Spectral_Single_Scattering_Albedo_Land'
'Corrected_Optical_Depth_Land_wav2p1'
'Land_Ocean_Quality_Flag'
'Deep_Blue_Aerosol_Optical_Depth_550_Land_QA_Flag'};

 %% identified same day data
 jday0=0;
 if f>2
   HI0 = {MODISfilename(f-1).name};
   KI0=HI0{1}(11:14);                                 
   LI0=HI0{1}(15:17);  
   jday0=[KI0,LI0];
 end
   if jday0==jday          
         CAODData470B = CAODData470;
         CAODData550B = CAODData550;
         CAODData660B = CAODData660;
         CAODData2130B = CAODData2130;
         daod412B = daod412;
         daod470B = daod470;
         daod660B = daod660;
         daod550B = daod550;
        % QA_DarkB= QA_Dark;          
   end

%% MODIS AOD (10KM) 
%Mfilename = './home/yuchihuang/NAS97/MOD04_L2.A2017321.0210.061.2017321210403.hdf';
Mfilename = ([HI{1}]);

MLongitude = hdfread(Mfilename, 'Longitude', 'Index', {[],[],[]});
MLatitude = hdfread(Mfilename, 'Latitude', 'Index', {[],[],[]});
Mlat = double(MLatitude);
Mlon = double(MLongitude);

[X1,Y1]=size(MLatitude);

%% Dark_Target
CAODData550 =  hdfread(Mfilename, QR{12}, 'Index', {[2 1 1],[1 1 1],[1 X1 Y1]});
AOD = double(CAODData550);
AOD(AOD==-9999) = NaN;
AOD = AOD.*0.001;

CAODData470 = hdfread(Mfilename, QR{12}, 'Index', {[1 1 1],[1 1 1],[1 X1 Y1]}); 
CAODData660 = hdfread(Mfilename, QR{12}, 'Index', {[3 1 1],[1 1 1],[1 X1 Y1]});
CAODData470 = double(CAODData470);
CAODData550 = double(CAODData550);
CAODData660 = double(CAODData660);
CAODData470(CAODData470==-9999) = NaN;
CAODData550(CAODData550==-9999) = NaN;
CAODData660(CAODData660==-9999) = NaN;
CAODData470 = CAODData470*0.001;
CAODData550 = CAODData550*0.001;
CAODData660 = CAODData660*0.001;
Corrected_Optical_Depth_Land_wav2p1 = hdfread(Mfilename, QR{15}, 'Index', {[1 1],[1 1],[X1 Y1]});
CAODData2130 = double(Corrected_Optical_Depth_Land_wav2p1);
CAODData2130 = CAODData2130*0.001;
CAODData2130(CAODData2130==-9999) = NaN;
%CAODData470(CAODData470<0)=nan;
%CAODData660(CAODData660<0)=nan;
%CAODData550(CAODData550<0)=nan;
%CAODData2130(CAODData2130<0)=nan;

%% Deep_Blue
Deep_Blue_Aerosol_Optical_Depth_Land412= hdfread(Mfilename, QR{8}, 'Index', {[1 1 1],[1 1 1],[1 X1 Y1]}); 
Deep_Blue_Aerosol_Optical_Depth_Land470= hdfread(Mfilename, QR{8}, 'Index', {[2 1 1],[1 1 1],[1 X1 Y1]}); 
Deep_Blue_Aerosol_Optical_Depth_Land660= hdfread(Mfilename, QR{8}, 'Index', {[3 1 1],[1 1 1],[1 X1 Y1]}); 
daod412=double(Deep_Blue_Aerosol_Optical_Depth_Land412);
daod470=double(Deep_Blue_Aerosol_Optical_Depth_Land470);
daod660=double(Deep_Blue_Aerosol_Optical_Depth_Land660);
daod412(daod412==-9999)=nan;
daod470(daod470==-9999)=nan;
daod660(daod660==-9999)=nan;
daod412=daod412*0.001;
daod470=daod470*0.001;
daod660=daod660*0.001;

Deep_Blue_Aerosol_Optical_Depth_550_Land = hdfread(Mfilename, QR{2}, 'Index', {[1 1],[1 1],[X1 Y1]}); 
daod550=double(Deep_Blue_Aerosol_Optical_Depth_550_Land);
daod550(daod550==-9999)=nan;
daod550=daod550*0.001;
DAEData = hdfread(Mfilename,QR{13},  'Index', {[1  1],[1  1],[X1 Y1]});
dae = double(DAEData);
dae(dae==-9999)=nan;
dae = dae*0.001;
DSSAData = hdfread(Mfilename, QR{14}, 'Index', {[1 1 1],[1 1 1],[1 X1 Y1]});
dssa = double(DSSAData);
dssa(dssa==-9999)=nan;
dssa = dssa*0.001;
%daod412(daod412<0)=nan;
%daod470(daod470<0)=nan;
%daod660(daod470<0)=nan;
%daod550(daod550<0)=nan;
%dae(dae<0)=nan;
%dssa(dssa<0)=nan;


%% read QA data
QA_Dark = hdfread(Mfilename, QR{16}, 'Index', {[1 1],[1 1],[X1 Y1]});
QA_Deep = hdfread(Mfilename, QR{17}, 'Index', {[1 1],[1 1],[X1 Y1]});
QA_Dark=double(QA_Dark);
QA_Deep=double(QA_Deep);


for i=1:size(QA_Dark,1)  
      for j=1:size(QA_Dark,2)  
        if (QA_Dark(i,j) <2) % data Quality
                  CAODData470(i,j)=nan;
                  CAODData550(i,j)=nan;
                  CAODData660(i,j)=nan;
                  CAODData2130(i,j)=nan;
        end
      end
end

for i=1:size(QA_Deep,1)
      for j=1:size(QA_Deep,2)
        if (QA_Deep(i,j) <2) % data Quality
                  daod412(i,j)=nan;
                  daod470(i,j)=nan;
                  daod660(i,j)=nan;
                  daod550(i,j)=nan;
                  dae(i,j)=nan;
                  dssa(i,j)=nan;
        end
      end
end

CAODData470 = griddata(Mlat,Mlon,CAODData470,X,Y);%reset window size  134*167
CAODData550 = griddata(Mlat,Mlon,CAODData550,X,Y);%reset window size
CAODData660 = griddata(Mlat,Mlon,CAODData660,X,Y);%reset window size
CAODData2130 = griddata(Mlat,Mlon,CAODData2130,X,Y);%reset window size
daod412=griddata(Mlat,Mlon,daod412,X,Y);
daod470=griddata(Mlat,Mlon,daod470,X,Y);
daod660=griddata(Mlat,Mlon,daod660,X,Y);
daod550=griddata(Mlat,Mlon,daod550,X,Y);
 dae=griddata(Mlat,Mlon,dae,X,Y);
% dssa=griddata(Mlat,Mlon,dssa,X,Y);
%QA_Dark=griddata(Mlat,Mlon,QA_Dark,X,Y);
%QA_Deep=griddata(Mlat,Mlon,QA_Deep,X,Y);


la = size(X,1);
lo = size(Y,2);

 if jday0==jday
     for i=1:la
      for j=1:lo
         CAODData470(i,j)= mean([CAODData470B(i,j),CAODData470(i,j)],'omitnan');
         CAODData550(i,j) = mean([CAODData550B(i,j),CAODData550(i,j)],'omitnan');
         CAODData660(i,j) = mean([CAODData660B(i,j),CAODData660(i,j)],'omitnan');
         CAODData2130(i,j) = mean([CAODData2130B(i,j),CAODData2130(i,j)],'omitnan');
         daod412(i,j) = mean([daod412B(i,j),daod412(i,j)],'omitnan');
         daod470(i,j) = mean([daod470B(i,j),daod470(i,j)],'omitnan');
         daod660(i,j) = mean([daod660B(i,j),daod660(i,j)],'omitnan');
         daod550(i,j) = mean([daod550B(i,j),daod550(i,j)],'omitnan');
%          QA_DarkB= QA_Dark;
            
      end
     end
 end
%% retrieved the CAOD500
CAE470550=nan(la,lo);
CAODData500=nan(la,lo);

for i=1:la
    for j=1:lo
        if (isnan(CAODData470(i,j))) && (isnan(CAODData550(i,j)))
         CAE470550(i,j)=nan;
        elseif (CAODData470(i,j)<=0)
          CAE470550(i,j)=nan;
        else 
          CAE470550(i,j)=log((CAODData470(i,j)/CAODData550(i,j)))/log(550/470);
        end
    end
end
CAE470550=real(CAE470550);

for i=1:la
    for j=1:lo
        if (isnan(CAODData470(i,j)))
            CAODData500(i,j)=-9.9990;
        elseif (CAODData470(i,j)==0)
           CAODData500(i,j)=0;    
        else 
           CAODData500(i,j)=exp(log(CAODData470(i,j))-log(500/470)*CAE470550(i,j));
        end
    end
end

CAODData500=real(CAODData500); 
 
%% retrieved the CAOD1020
CAE6602130=nan(la,lo);
CAODData1020=nan(la,lo);
for i=1:la
    for j=1:lo
        if (isnan(CAODData660(i,j))) && (isnan(CAODData2130(i,j)))
         CAE6602130(i,j)=nan;
        elseif (CAODData660(i,j)<=0)
          CAE6602130(i,j)=nan;
        else 
          CAE6602130(i,j)=log((CAODData660(i,j)/CAODData2130(i,j)))/log(2130/660);
        end
    end
end
CAE6602130=real(CAE6602130);

for i=1:la
    for j=1:lo
        if (isnan(CAODData660(i,j)))
            CAODData1020(i,j)=nan;
        elseif (CAODData660(i,j)==0)
           CAODData1020(i,j)=0;    
        else 
           CAODData1020(i,j)=exp(log(CAODData660(i,j))-log(1020/660)*CAE6602130(i,j));
        end
    end
end
CAODData1020=real(CAODData1020);
%cslope4701020=(CAODData470-CAODData1020)/(470-1020);
%% retrieved the CAOD870
CAE6601020=nan(la,lo);
CAODData870=nan(la,lo);
for i=1:la
    for j=1:lo
        if (isnan(CAODData660(i,j))) && (isnan(CAODData1020(i,j)))
         CAE6601020(i,j)=nan;
        elseif (CAODData660(i,j)<=0)
         CAE6601020(i,j)=nan;   
        else 
          CAE6601020(i,j)=log((CAODData660(i,j)/CAODData1020(i,j)))/log(1020/660);
        end
    end
end

CAE6601020=real(CAE6601020);

for i=1:la
    for j=1:lo
        if (isnan(CAODData660(i,j)))
            CAODData870(i,j)=nan;
        elseif (CAODData660(i,j)==0)
           CAODData870(i,j)=0;    
        else 
            CAODData870(i,j)=exp(log(CAODData660(i,j))-log(870/660)*CAE6601020(i,j));
        end
    end
end

CAODData870=real(CAODData870);

%cslope470870=(CAODData470-CAODData870)/(470-870);
%% retrieved the CAE470660 & CAE470870
CAE470870=nan(la,lo);
CAE470660=nan(la,lo);
for i=1:la
    for j=1:lo
        if (isnan(CAODData470(i,j))) && (isnan(CAODData870(i,j)))
         CAE470870(i,j)=nan;
        elseif (CAODData550(i,j)<=0)
         CAE470870(i,j)=nan;   
        else 
         CAE470870(i,j)=log((CAODData470(i,j)/CAODData870(i,j)))/log(870/470);
        end
    end
end

CAE470870=real(CAE470870);

for i=1:la
    for j=1:lo
        if (isnan(CAODData470(i,j))) && (isnan(CAODData660(i,j)))
         CAE470660(i,j)=nan;
        elseif (CAODData470(i,j)<=0)
          CAE470660(i,j)=nan;   
        else 
          CAE470660(i,j)=log((CAODData470(i,j)/CAODData660(i,j)))/log(660/470);
        end
    end
end

CAE470660=real(CAE470660);

cslope470660=(CAODData470-CAODData660)/(470-660);
cslope470660sss=cslope470660*1000./CAODData470; % slope470660/AOD1020= NGAI method

for i=1:la
    for j=1:lo
        if (CAODData470(i,j) <=0.1)  % ignore the CAOD <=0.1 to nan <== clear sky
                  CAE470660(i,j)=nan;
                  CAODData470(i,j)=nan;
                  CAODData550(i,j)=nan;
                  CAODData660(i,j)=nan;              
                        cslope470660(i,j)=nan;
                        cslope470660sss(i,j)=nan;
%         elseif (QA_Dark(i,j) <2) ; % 
%          CAE470660(i,j)=nan;
%                   CAODData470(i,j)=nan;
%                   CAODData550(i,j)=nan;
%                   CAODData660(i,j)=nan;
%                         cslope470660(i,j)=nan;
%                         cslope470660sss(i,j)=nan;                        
        else
            CAE470660(i,j)=CAE470660(i,j);
                    CAODData470(i,j)=CAODData470(i,j);
                    CAODData550(i,j)=CAODData550(i,j);
                    CAODData660(i,j)=CAODData660(i,j);                    
                        cslope470660(i,j)=cslope470660(i,j);
                        cslope470660sss(i,j)=cslope470660sss(i,j);%
        end
    end
end

ctestall2=cslope470660;
ctestall24=ctestall2;     

%F2=((CAODData470-2*CAODData550+CAODData660)/((0.47-0.55)^2))./CAODData470;
%% aerosol type without mixture ratio aerosol type
for i=1:la
      for j=1:lo
         if cslope470660sss(i,j)>=-0.24 %&& cslope470660sss(i,j)<=-0.96; %DS
        ctestall2(i,j)=-1; 
         elseif  cslope470660sss(i,j)>-1.51 && cslope470660sss(i,j)<-0.24
         ctestall2(i,j)=0;         
         elseif  cslope470660sss(i,j)>=-1.83 && cslope470660sss(i,j)<=-1.51 %AP
         ctestall2(i,j)=-3; 
         elseif  cslope470660sss(i,j)>-2.28 && cslope470660sss(i,j)<-1.83
         ctestall2(i,j)=0;         
         elseif  cslope470660sss(i,j)<=-2.28 %&& cslope470660sss(i,j)>=-8.34 %BB
         ctestall2(i,j)=-2;     
%          else 
%          ctestall24(i,j)=-4;     
         end
      end
end

%PM=CAODData660;
DS_slope=52.8;
DS_inter=9.68;
AP_slope=62.4;
AP_inter=12.4;
BB_slope=98.26;
BB_inter=15.36;

%% aerosol type with mixture ratio aerosol type
for i=1:la
      for j=1:lo
         if  cslope470660sss(i,j)>=-0.24
         ctestall24(i,j)=7; %total is Dust aerosol 
         
         elseif  cslope470660sss(i,j)>=-0.56 && cslope470660sss(i,j)<-0.24
         ctestall24(i,j)=6;                                            % Dust ratio is 0.8 and AP ratio is 0.2
         
         elseif  cslope470660sss(i,j)>=-0.72 && cslope470660sss(i,j)<-0.56
         ctestall24(i,j)=5;                                            % Dust ratio is 0.7 and AP ratio is 0.3
         
         elseif  cslope470660sss(i,j)>=-0.88 && cslope470660sss(i,j)<-0.72
         ctestall24(i,j)=4;                                             % Dust ratio is 0.6 and AP ratio is 0.4
         
         elseif  cslope470660sss(i,j)>=-1.04 && cslope470660sss(i,j)<-0.88
         ctestall24(i,j)=3;                                             % Dust ratio is 0.5 and AP ratio is 0.5
         
         elseif  cslope470660sss(i,j)>=-1.19 && cslope470660sss(i,j)<-1.04
         ctestall24(i,j)=2;                                             % Dust ratio is 0.4 and AP ratio is 0.6
         
         elseif  cslope470660sss(i,j)>=-1.35 && cslope470660sss(i,j)<-1.19
         ctestall24(i,j)=1;                                             % Dust ratio is 0.3 and AP ratio is 0.7
         
         elseif  cslope470660sss(i,j)>=-1.51 && cslope470660sss(i,j)<-1.35
         ctestall24(i,j)=0;                                             % Dust ratio is 0.2 and AP ratio is 0.8
         
         elseif  cslope470660sss(i,j)>-1.67 && cslope470660sss(i,j)<-1.51
         ctestall24(i,j)=-1;                                             %  AP ratio is 1
     
         elseif  cslope470660sss(i,j)>-1.83 && cslope470660sss(i,j)<-1.67
         ctestall24(i,j)=-1;                                             %  AP ratio is 1   
      
         elseif  cslope470660sss(i,j)>=-1.94 && cslope470660sss(i,j)<-1.83
         ctestall24(i,j)=-2;                                             % AP ratio is 0.8 and BB ratio is 0.2
       
         elseif  cslope470660sss(i,j)>=-2.00 && cslope470660sss(i,j)<-1.94
         ctestall24(i,j)=-3;                                             % AP ratio is 0.7 and BB ratio is 0.3
         
         elseif  cslope470660sss(i,j)>=-2.06 && cslope470660sss(i,j)<-2.00
         ctestall24(i,j)=-4;                                             % AP ratio is 0.6 and BB ratio is 0.4  
         
         elseif  cslope470660sss(i,j)>=-2.11 && cslope470660sss(i,j)<-2.06
         ctestall24(i,j)=-5;                                             % AP ratio is 0.5 and BB ratio is 0.5 
        
         elseif  cslope470660sss(i,j)>=-2.17 && cslope470660sss(i,j)<-2.11
         ctestall24(i,j)=-6;                                             % AP ratio is 0.4 and BB ratio is 0.6 
         
         elseif  cslope470660sss(i,j)>=-2.22 && cslope470660sss(i,j)<-2.17
         ctestall24(i,j)=-7;                                             % AP ratio is 0.3 and BB ratio is 0.7
         
         elseif  cslope470660sss(i,j)>-2.28 && cslope470660sss(i,j)<-2.22
         ctestall24(i,j)=-8;                                             % AP ratio is 0.2 and BB ratio is 0.8
         
         elseif  cslope470660sss(i,j)<=-2.28
         ctestall24(i,j)=-9;                                             % BB ratio is 1 
       
         end
      end
end 

         ctestall243=ctestall24;

F2=((CAODData470-2*CAODData550+CAODData660)/((0.47-0.55)^2))./CAODData470;
ctestall2444=nan(la,lo);
for i=1:la
      for j=1:lo
         if cslope470660sss(i,j)>=-1.65 && cslope470660sss(i,j)<=-0.70 && F2(i,j)>=4.71 && F2(i,j)<=9.30
            ctestall2444(i,j)=-19; 
%          elseif F2(i,j)>=3;
%         ctestall2444(i,j)=7;         
         else
          ctestall2444(i,j)=ctestall24(i,j);     
         end
      end
end 

for i=1:la
      for j=1:lo
         if  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-0.46 % BB ratio is 1
         ctestall243(i,j)=7;  
          
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-0.67 && cslope470660sss(i,j)<-0.46
         ctestall243(i,j)=-17;                                            % BB ratio is 0.8 and DS ratio is 0.2       
          
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-0.89 && cslope470660sss(i,j)<-0.67
         ctestall243(i,j)=-16;                                            % BB ratio is 0.7 and DS ratio is 0.3     
          
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-1.10 && cslope470660sss(i,j)<-0.89
         ctestall243(i,j)=-15;                                             % BB ratio is 0.6 and DS ratio is 0.4        
         
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-1.32 && cslope470660sss(i,j)<-1.10
         ctestall243(i,j)=-14;                                             % BB ratio is 0.5 and DS ratio is 0.5 
        
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-1.53 && cslope470660sss(i,j)<-1.32
         ctestall243(i,j)=-13;                                             % BB ratio is 0.4 and DS ratio is 0.6
          
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-1.75 && cslope470660sss(i,j)<-1.53
         ctestall243(i,j)=-12;                                             % BB ratio is 0.3 and DS ratio is 0.7
          
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-1.96 && cslope470660sss(i,j)<-1.75
         ctestall243(i,j)=-11;                                             % BB ratio is 0.2 and DS ratio is 0.8
          
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)<-1.96
         ctestall243(i,j)=-10;                                           
         %DS ratio is 1
%          else
%          ctestall243(i,j)=ctestall2444(i,j); 
%          PM(i,j)=PM(i,j);
         end
      end
end 


%% classified the aerosol type  (DEEP BLUE)
for i=1:la
    for j=1:lo
        if (daod470(i,j) <=0.1)
            daod412(i,j)=nan;
            daod470(i,j)=nan;
            daod550(i,j)=nan;
            daod660(i,j)=nan;
            dae(i,j)=nan;
        else
            daod412(i,j)=daod412(i,j);
            daod470(i,j)=daod470(i,j);
            daod550(i,j)=daod550(i,j);
            daod660(i,j)=daod660(i,j);
            dae(i,j)=dae(i,j);
        end
    end
end
dslope470660=(daod470-daod660)/(470-660);
dslope470660sss=dslope470660*1000./daod470; % dslope470660/DAOD470= NGAI method
dtestall2=dslope470660;
dtestall24=dtestall2; 

%% retrevial daod500
daode470550=nan(la,lo);
daod500=nan(la,lo);
for i=1:la
     for j=1:lo
        if (isnan(daod470(i,j))) && (isnan(daod550(i,j)))
         daode470550(i,j)=nan;
        elseif (CAODData470(i,j)<=0)
          daode470550(i,j)=nan;
        else 
          daode470550(i,j)=log((daod470(i,j)/daod550(i,j)))/log(550/470);
        end
    end
end
daode470550=real(daode470550);

for i=1:la
    for j=1:lo
        if (isnan(daod470(i,j)))
            daod500(i,j)=-9.9990;
        elseif (daod470(i,j)==0)
           daod500(i,j)=0;    
        else 
            daod500(i,j)=exp(log(daod470(i,j))-log(500/470)*daode470550(i,j));
        end
    end
end
daod500=real(daod500); 
%% aerosol type without mixture ratio aerosol type
for i=1:la
    for j=1:lo
         if dslope470660sss(i,j)>=-0.24 %&& dslope470660sss(i,j)<=-0.96; %DS
        dtestall2(i,j)=-1; 
         elseif  dslope470660sss(i,j)>-1.51 && dslope470660sss(i,j)<-0.24
         dtestall2(i,j)=0;         
         elseif  dslope470660sss(i,j)>=-1.83 && dslope470660sss(i,j)<=-1.51 %AP
         dtestall2(i,j)=-3; 
         elseif  dslope470660sss(i,j)>-2.28 && dslope470660sss(i,j)<-1.83
         dtestall2(i,j)=0;         
         elseif  dslope470660sss(i,j)<=-2.28 %&& dslope470660sss(i,j)>=-8.34 %BB
         dtestall2(i,j)=-2;     
%          else 
%          ctestall24(i,j)=-4;     
         end
    end
end 

%% aerosol type with mixture ratio aerosol type
for i=1:la
    for j=1:lo
         if  dslope470660sss(i,j)>=-0.24
         dtestall24(i,j)=7; %total is Dust aerosol
         elseif  dslope470660sss(i,j)>=-0.56 && dslope470660sss(i,j)<-0.24
         dtestall24(i,j)=6;                                            % Dust ratio is 0.8 and AP ratio is 0.2    
         elseif  dslope470660sss(i,j)>=-0.72 && dslope470660sss(i,j)<-0.56
         dtestall24(i,j)=5;                                            % Dust ratio is 0.7 and AP ratio is 0.3     
         elseif  dslope470660sss(i,j)>=-0.88 && dslope470660sss(i,j)<-0.72
         dtestall24(i,j)=4;                                             % Dust ratio is 0.6 and AP ratio is 0.4  
         elseif  dslope470660sss(i,j)>=-1.04 && dslope470660sss(i,j)<-0.88
         dtestall24(i,j)=3;                                             % Dust ratio is 0.5 and AP ratio is 0.5
         elseif  dslope470660sss(i,j)>=-1.19 && dslope470660sss(i,j)<-1.04
         dtestall24(i,j)=2;                                             % Dust ratio is 0.4 and AP ratio is 0.6
         elseif  dslope470660sss(i,j)>=-1.35 && dslope470660sss(i,j)<-1.19
         dtestall24(i,j)=1;                                             % Dust ratio is 0.3 and AP ratio is 0.7
         elseif  dslope470660sss(i,j)>=-1.51 && dslope470660sss(i,j)<-1.35
         dtestall24(i,j)=0;                                             % Dust ratio is 0.2 and AP ratio is 0.8
         elseif  dslope470660sss(i,j)>-1.67 && dslope470660sss(i,j)<-1.51
         dtestall24(i,j)=-1;                                             %  AP ratio is 1
         elseif  dslope470660sss(i,j)>-1.83 && dslope470660sss(i,j)<-1.67
         dtestall24(i,j)=-1;                                             %  AP ratio is 1   
         elseif  dslope470660sss(i,j)>=-1.94 && dslope470660sss(i,j)<-1.83
         dtestall24(i,j)=-2;                                             % AP ratio is 0.8 and BB ratio is 0.2         
         elseif  dslope470660sss(i,j)>=-2.00 && dslope470660sss(i,j)<-1.94
         dtestall24(i,j)=-3;                                             % AP ratio is 0.7 and BB ratio is 0.3
         elseif  dslope470660sss(i,j)>=-2.06 && dslope470660sss(i,j)<-2.00
         dtestall24(i,j)=-4;                                             % AP ratio is 0.6 and BB ratio is 0.4   
         elseif  dslope470660sss(i,j)>=-2.11 && dslope470660sss(i,j)<-2.06
         dtestall24(i,j)=-5;                                             % AP ratio is 0.5 and BB ratio is 0.5  
         elseif  dslope470660sss(i,j)>=-2.17 && dslope470660sss(i,j)<-2.11
         dtestall24(i,j)=-6;                                             % AP ratio is 0.4 and BB ratio is 0.6 
         elseif  dslope470660sss(i,j)>=-2.22 && dslope470660sss(i,j)<-2.17
         dtestall24(i,j)=-7;                                             % AP ratio is 0.3 and BB ratio is 0.7
         elseif  dslope470660sss(i,j)>-2.28 && dslope470660sss(i,j)<-2.22
         dtestall24(i,j)=-8;                                             % AP ratio is 0.2 and BB ratio is 0.8
         elseif  dslope470660sss(i,j)<=-2.28
         dtestall24(i,j)=-9;                                             % BB ratio is 1 
         end
    end
end  

F22=((daod412-2*daod550+daod660)/((0.412-0.55)^2))./daod412;
dtestall2444=nan(la,lo);
for i=1:la
    for j=1:lo
         if dslope470660sss(i,j)>=-1.65 && dslope470660sss(i,j)<=-0.70 && F22(i,j)>=4.71 && F22(i,j)<=9.30
        dtestall2444(i,j)=-19; 
%          elseif F2(i,j)>=3;
%         dtestall2444(i,j)=7;         
         else
          dtestall2444(i,j)=dtestall24(i,j);     
         end
     end
end 
dtestall243=nan(la,lo);
for i=1:la
    for j=1:lo
         if  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-0.46
         dtestall243(i,j)=7;  
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-0.67 && dslope470660sss(i,j)<-0.46
         dtestall243(i,j)=-17;                                            % BB ratio is 0.8 and DS ratio is 0.2   
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-0.89 && dslope470660sss(i,j)<-0.67
         dtestall243(i,j)=-16;                                            % BB ratio is 0.7 and DS ratio is 0.3  
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-1.10 && dslope470660sss(i,j)<-0.89
         dtestall243(i,j)=-15;                                             % BB ratio is 0.6 and DS ratio is 0.4   
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-1.32 && dslope470660sss(i,j)<-1.10
         dtestall243(i,j)=-14;                                             % BB ratio is 0.5 and DS ratio is 0.5 
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-1.53 && dslope470660sss(i,j)<-1.32
         dtestall243(i,j)=-14;                                             % BB ratio is 0.4 and DS ratio is 0.6 
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-1.75 && dslope470660sss(i,j)<-1.53
         dtestall243(i,j)=-12;                                             % BB ratio is 0.3 and DS ratio is 0.7
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-1.96 && dslope470660sss(i,j)<-1.75
         dtestall243(i,j)=-11;                                             % BB ratio is 0.2 and DS ratio is 0.8
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)<-1.96
         dtestall243(i,j)=-10;                                             % BB ratio is 0.1 and DS ratio is 0.9
         else
         dtestall243(i,j)=dtestall2444(i,j);
         end
    end
end 

%%
F222=F2;
ddsslope470660sss=cslope470660sss;
dctestall243=ctestall243;
dcAODData660=CAODData660;
dcAODData550=CAODData550;
dcAODData470=CAODData470;
dcAODData500=CAODData500;
dctestall2=ctestall2;
for i=1:la
    for j=1:lo
          if  isnan(dcAODData660(i,j))
              dctestall243(i,j)=dtestall243(i,j);
              dcAODData660(i,j)=daod660(i,j);
              dcAODData550(i,j)=daod550(i,j);
              dcAODData500(i,j)=daod500(i,j);
              dcAODData470(i,j)=daod470(i,j);
              dctestall2(i,j)=dtestall2(i,j);
              F222(i,j)=F22(i,j);
              ddsslope470660sss(i,j)=dslope470660sss(i,j);
          else
              dctestall243(i,j)=ctestall243(i,j);
              dcAODData660(i,j)=CAODData660(i,j);
              dcAODData550(i,j)=CAODData550(i,j);
              dcAODData500(i,j)=CAODData500(i,j);
              dcAODData470(i,j)=CAODData470(i,j);
              dctestall2(i,j)=ctestall2(i,j);
              F222(i,j)=F2(j);
              ddsslope470660sss(i,j)=cslope470660sss(i,j);
          end
    end
end


savename=['date1,'_10T3km']

save(savename,'X','Y','dctestall243','dctestall2','dcAODData660','dcAODData550','dcAODData470') ;
%clearvars -except x m n xx mm nn f num num2 KI KI2 LI LI2 X Y

end
toc
