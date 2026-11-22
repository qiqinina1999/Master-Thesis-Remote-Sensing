clear;clc; 
close all
tic
% East Asia
%yrange=85:0.03:145;
%xrange=5:0.03:55;
% Taiwan
yrange=118:0.03:123;%
xrange=21:0.03:26;
[X,Y] = meshgrid(xrange,yrange);%set lat lon range
CASE_name='CASE_20230413';
cd /Volumes/YUCHIHUANG/Matlab/CASE_20230413/MODIS
%MODISfilename='./home/yuchihuang/NAS97/MODIS/MOD04_L2.A2017321.0210.061.2017321210403.hdf';
MODISfilename=dir(['*L2.A20*.hdf'])

m = length(MODISfilename);

for f=1:11  %1:m 

 HI = {MODISfilename(f).name}

 KI=HI{1}(11:14)                                 
 LI=HI{1}(15:17)

 jday=[KI,LI];
 date1=jl2normaldate(str2num(jday),'yyyymmdd')
 year=str2num(date1(1:4));
 month=str2num(date1(5:6));
 day=str2num(date1(7:8));
     
 GMAOfilename=['GEOS.fp.asm.tavg1_2d_flx_Nx.' date1 '_0230.V01.nc4']
 HJ=GMAOfilename;

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

[X1 Y1]=size(MLatitude)

%% Dark_Target
CAODData550 =  hdfread(Mfilename, QR{12}, 'Index', {[2 1 1],[1 1 1],[1 X1 Y1]});
AOD = double(CAODData550);
AOD(find(AOD==-9999)) = NaN;
AOD = AOD.*0.001;

CAODData470 = hdfread(Mfilename, QR{12}, 'Index', {[1 1 1],[1 1 1],[1 X1 Y1]}); 

CAODData660 = hdfread(Mfilename, QR{12}, 'Index', {[3 1 1],[1 1 1],[1 X1 Y1]});
CAODData470 = double(CAODData470);
CAODData550 = double(CAODData550);
CAODData660 = double(CAODData660);
CAODData470(find(CAODData470==-9999)) = NaN;
CAODData550(find(CAODData550==-9999)) = NaN;
CAODData660(find(CAODData660==-9999)) = NaN;
CAODData470 = CAODData470*0.001;
CAODData550 = CAODData550*0.001;
CAODData660 = CAODData660*0.001;
Corrected_Optical_Depth_Land_wav2p1 = hdfread(Mfilename, QR{15}, 'Index', {[1 1],[1 1],[X1 Y1]});
CAODData2130 = double(Corrected_Optical_Depth_Land_wav2p1);
CAODData2130 = CAODData2130*0.001;

%% Deep_Blue
Deep_Blue_Aerosol_Optical_Depth_Land412= hdfread(Mfilename, QR{8}, 'Index', {[1 1 1],[1 1 1],[1 X1 Y1]}); 
Deep_Blue_Aerosol_Optical_Depth_Land470= hdfread(Mfilename, QR{8}, 'Index', {[2 1 1],[1 1 1],[1 X1 Y1]}); 
Deep_Blue_Aerosol_Optical_Depth_Land660= hdfread(Mfilename, QR{8}, 'Index', {[3 1 1],[1 1 1],[1 X1 Y1]}); 
daod412=double(Deep_Blue_Aerosol_Optical_Depth_Land412);
daod470=double(Deep_Blue_Aerosol_Optical_Depth_Land470);
daod660=double(Deep_Blue_Aerosol_Optical_Depth_Land660);
daod412=daod412*0.001;
daod470=daod470*0.001;
daod660=daod660*0.001;

Deep_Blue_Aerosol_Optical_Depth_550_Land = hdfread(Mfilename, QR{2}, 'Index', {[1 1],[1 1],[X1 Y1]}); 
daod550=double(Deep_Blue_Aerosol_Optical_Depth_550_Land);
daod550=daod550*0.001;
DAEData = hdfread(Mfilename,QR{13},  'Index', {[1  1],[1  1],[X1 Y1]});
dae = double(DAEData);
dae = dae*0.001;
DSSAData = hdfread(Mfilename, QR{14}, 'Index', {[1 1 1],[1 1 1],[1 X1 Y1]});
dssa = double(DSSAData);
dssa = dssa*0.001;

%% read QA data
QA_Dark = hdfread(Mfilename, QR{16}, 'Index', {[1 1],[1 1],[X1 Y1]});
QA_Deep = hdfread(Mfilename, QR{17}, 'Index', {[1 1],[1 1],[X1 Y1]});
QA_Dark=double(QA_Dark);
QA_Deep=double(QA_Deep);


for i=1:203  
      for j=1:135
        if (QA_Dark(i,j) <2) % data Quality
                  CAODData470(i,j)=nan;
                  CAODData550(i,j)=nan;
                  CAODData660(i,j)=nan;
                  CAODData2130(i,j)=nan;
        end
      end
end

for i=1:203  
      for j=1:135
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
         CAODData470(i,j)= nanmean([CAODData470B(i,j),CAODData470(i,j)]);
         CAODData550(i,j) = nanmean([CAODData550B(i,j),CAODData550(i,j)]);
         CAODData660(i,j) = nanmean([CAODData660B(i,j),CAODData660(i,j)]);
         CAODData2130(i,j) = nanmean([CAODData2130B(i,j),CAODData2130(i,j)]);
         daod412(i,j) = nanmean([daod412B(i,j),daod412(i,j)]);
         daod470(i,j) = nanmean([daod470B(i,j),daod470(i,j)]);
         daod660(i,j) = nanmean([daod660B(i,j),daod660(i,j)]);
         daod550(i,j) = nanmean([daod550B(i,j),daod550(i,j)]);
%          QA_DarkB= QA_Dark;
            
      end
     end
 end


%% GMAO PBLH
name = ['/Volumes/YUCHIHUANG/Matlab/',CASE_name,'/MODIS/',HJ] %file name
%name = append('/Data01/yuchihuang/',CASE_name,'/MODIS/',HJ);
%name = '/home/ts02061902/NAS97/GMAO/201701_12/GEOS.fp.asm.tavg1_2d_flx_Nx.20171222_0230.V01.nc4'; %file name
pblh0 = ncread(name,'PBLH');
lat0 = ncread(name,'lat');
lon0 = ncread(name,'lon');
 pblh1 = pblh0(959:969,447:464);
 lat1 = (lat0(447:464));
 lon1 = (lon0(959:969));
Gpblh = double(pblh1);
Glat = double(lat1);
Glon = double(lon1);
Gpb1 = Gpblh';
Gpb=flipud(Gpb1)./1000;
pblon=zeros(18,11);
pblat=zeros(18,11);
for i=1:11
    pblon(:,i)=Glon(i);
end
for i=1:18
    pblat(19-i,:)=Glat(i);
end
%% INT. 

[a1,a2] = find(X > 21 & X < 26);
[b1,b2] = find(Y > 118 & Y < 123);
c1 = intersect(a1,b1); 
c2 = intersect(a2,b2);

tw = CAODData660;

twlon = Y;
twlat = X;

la = size(X,1);
lo = size(Y,2);
AA = find(isnan(tw)==1);%
twpb = barnes(pblon,pblat,Gpb,twlon,twlat,0.2,0.2);
%% Mode 
twmode = zeros(la,lo);
for i = 1:la;
    for k = 1:lo;
        if isnan(twpb(i,k))==1;
            %disp([i k]);
        else
           twmode(i,k) = (((0.2*twpb(i,k)+0.1*tw(i,k))-0.065)./1.163)*3.37;
        end
    end
end
%% Sigma
twsigma = zeros(la,lo);
for i = 1:la;
    for k = 1:lo;
        if isnan(twpb(i,k))==1
            %disp([i k]);
        else
            if (twpb(i,k)-twmode(i,k))>=0.4
                T = (twpb(i,k)-2.5*twmode(i,k));
                HR = ((twpb(i,k))/(twmode(i,k)));
                dh = (twpb(i,k)-twmode(i,k));
                slope = (-7.309)*dh+8.818;
                twsigma(i,k) = (HR-2.5)./(slope*T*dh);
            else
                T = (twpb(i,k)-1.3*twmode(i,k));
                HR = ((twpb(i,k))./(twmode(i,k)));
                dh = (twpb(i,k)-twmode(i,k));
                slope = (-32.13)*dh+20.47;
                twsigma(i,k) = (HR-1.3)./(slope*T*dh);
            end
        end
    end
end
%% Mu
twmu=zeros(la,lo);
for i = 1:la;
    for k = 1:lo;
        if isnan(twpb(i,k))==1
            %disp([i k]);         
        else
            twmu(i,k) = log(twmode(i,k))+twsigma(i,k)^2;
        end
    end
end
%% Extinction
twnext = zeros(la,lo);
twnext200 = zeros(la,lo);
twnext270 = zeros(la,lo);
twnext340 = zeros(la,lo);
twnext410 = zeros(la,lo);
twnext480 = zeros(la,lo);
y1 = 0.0375:0.075:10.0125;
y2 = 0.0375:0.075:7.0125;
for i = 1:la;
    for k = 1:lo;
        if isnan(twpb(i,k))==1
           %disp([i k]);
        else
            mu = twmu(i,k);
            si = twsigma(i,k);
            % pdf 
            p1 = pdf('Lognormal',y2,mu,si);
            p2 = p1;
            p2 = p1-p1(1,94);
            p2(1,134) = 0;
            p2(find(p2<0)) = 0;
            p3 = p2;
            p3(1,1:2) = p3(1,3);
            Q2=trapz(y1,p3);
            p4=p3.*(1/Q2);
            twnext200(i,k)=(tw(i,k).*p4(1,3));
            p5=p2;
            p5(1,1:6)=p5(1,7);
            Q3=trapz(y1,p5);
            p6=p5.*(1/Q3);           
            twnext480(i,k)=(tw(i,k).*p6(1,3));
            p7=p2;
            p7(1,1:3)=p7(1,4);
            Q4=trapz(y1,p7);
            p8=p7.*(1/Q4);
            twnext270(i,k)=(tw(i,k).*p8(1,3));
            p9=p2;
            p9(1,1:4)=p7(1,5);
            Q5=trapz(y1,p9);
            p10=p9.*(1/Q5);
            twnext340(i,k)=(tw(i,k).*p10(1,3));
            p11=p2;
            p11(1,1:5)=p7(1,6);
            Q6=trapz(y1,p11);
            p12=p11.*(1/Q6);
            twnext410(i,k)=(tw(i,k).*p12(1,3));
            
            if (twpb(i,k)-twmode(i,k)) >= 0.4
                if twmode(i,k) <= 0.2625
                    twnext(i,k) = twnext200(i,k);
                elseif twmode(i,k) > 0.2625 & twmode(i,k) <= 0.6375
                    twnext(i,k) = twnext270(i,k);
                elseif twmode(i,k) > 0.6375 & twmode(i,k) <= 0.7875
                    twnext(i,k) = twnext340(i,k);
                elseif twmode(i,k) > 0.7875 & twmode(i,k) <= 0.8625
                    twnext(i,k) = twnext410(i,k);
                else
                    twnext(i,k) = twnext480(i,k);
                end
            else
                if twmode(i,k) <= 0.4125
                    twnext(i,k) = twnext200(i,k);
                elseif twmode(i,k) > 0.4125 & twmode(i,k) <= 0.6375
                    twnext(i,k) = twnext270(i,k);
                elseif twmode(i,k) > 0.6375 & twmode(i,k) <= 0.7125
                    twnext(i,k) = twnext340(i,k);
                elseif twmode(i,k) > 0.7125 & twmode(i,k) <= 0.8625
                    twnext(i,k) = twnext410(i,k);
                else
                    twnext(i,k) = twnext480(i,k);
                end
            end
        end
    end
end

%% surface ext

twnext=real(twnext);
twnext1=twnext;
%% retrieved the CAOD1020
for i=1:la
      for j=1:lo
        if (CAODData660(i,j)==-9.9990) && (CAODData2130(i,j) == -9.9990);
         CAE6602130(i,j)=nan;
        elseif (CAODData660(i,j)<=0);
          CAE6602130(i,j)=nan;
        else CAE6602130(i,j)=log((CAODData660(i,j)/CAODData2130(i,j)))/log(2130/660);
        end
    end
end
CAE6602130=real(CAE6602130);

for i=1:la
      for j=1:lo
        if (CAODData660(i,j)==-9.9990);
            CAODData1020(i,j)=-9.9990;
        elseif (CAODData660(i,j)==0);
           CAODData1020(i,j)=0;    
        else CAODData1020(i,j)=exp(log(CAODData660(i,j))-log(1020/660)*CAE6602130(i,j));
    end
    end
end
CAODData1020=real(CAODData1020);
%cslope4701020=(CAODData470-CAODData1020)/(470-1020);
%% retrieved the CAOD870
for i=1:la
      for j=1:lo
        if (CAODData660(i,j) ==-9.9990) && (CAODData1020(i,j) == -9.9990);
         CAE6601020(i,j)=nan;
        elseif (CAODData660(i,j)<=0);
         CAE6601020(i,j)=nan;   
        else CAE6601020(i,j)=log((CAODData660(i,j)/CAODData1020(i,j)))/log(1020/660);
        end
    end
end

CAE6601020=real(CAE6601020);

for i=1:la
      for j=1:lo
        if (CAODData660(i,j)==-9.9990);
            CAODData870(i,j)=-9.9990;
        elseif (CAODData660(i,j)==0);
           CAODData870(i,j)=0;    
        else CAODData870(i,j)=exp(log(CAODData660(i,j))-log(870/660)*CAE6601020(i,j));
    end
    end
end

CAODData870=real(CAODData870);

%cslope470870=(CAODData470-CAODData870)/(470-870);
%% retrieved the CAE470660 & CAE470870
for i=1:la
      for j=1:lo
        if (CAODData470(i,j) ==-9.9990) && (CAODData870(i,j) == -9.9990);
         CAE470870(i,j)=nan;
        elseif (CAODData550(i,j)<=0);
         CAE470870(i,j)=nan;   
        else CAE470870(i,j)=log((CAODData470(i,j)/CAODData870(i,j)))/log(870/470);
        end
    end
end

CAE470870=real(CAE470870);

for i=1:la
      for j=1:lo
        if (CAODData470(i,j) ==-9.9990) && (CAODData660(i,j) == -9.9990);
         CAE470660(i,j)=-9.999;
        elseif (CAODData470(i,j)<=0);
          CAE470660(i,j)=-9.999;   
        else CAE470660(i,j)=log((CAODData470(i,j)/CAODData660(i,j)))/log(660/470);
        end
    end
end

CAE470660=real(CAE470660);

cslope470660=(CAODData470-CAODData660)/(470-660);
cslope470660sss=cslope470660*1000./CAODData470; % slope470660/AOD1020= NGAI method

for i=1:la
      for j=1:lo
        if (CAODData470(i,j) <=0.1) ; % ignore the CAOD <=0.1 to nan <== clear sky
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
PM=twnext;
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
         PM(i,j)=twnext(i,j)*DS_slope+DS_inter;
         elseif  cslope470660sss(i,j)>=-0.56 && cslope470660sss(i,j)<-0.24
         ctestall24(i,j)=6;                                            % Dust ratio is 0.8 and AP ratio is 0.2
         PM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.8)+((twnext(i,j)*AP_slope+AP_inter)*0.2);
         elseif  cslope470660sss(i,j)>=-0.72 && cslope470660sss(i,j)<-0.56
         ctestall24(i,j)=5;                                            % Dust ratio is 0.7 and AP ratio is 0.3
         PM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.7)+((twnext(i,j)*AP_slope+AP_inter)*0.3);
         elseif  cslope470660sss(i,j)>=-0.88 && cslope470660sss(i,j)<-0.72
         ctestall24(i,j)=4;                                             % Dust ratio is 0.6 and AP ratio is 0.4
         PM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.6)+((twnext(i,j)*AP_slope+AP_inter)*0.4);
         elseif  cslope470660sss(i,j)>=-1.04 && cslope470660sss(i,j)<-0.88
         ctestall24(i,j)=3;                                             % Dust ratio is 0.5 and AP ratio is 0.5
         PM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.5)+((twnext(i,j)*AP_slope+AP_inter)*0.5);
         elseif  cslope470660sss(i,j)>=-1.19 && cslope470660sss(i,j)<-1.04
         ctestall24(i,j)=2;                                             % Dust ratio is 0.4 and AP ratio is 0.6
         PM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.4)+((twnext(i,j)*AP_slope+AP_inter)*0.6);
         elseif  cslope470660sss(i,j)>=-1.35 && cslope470660sss(i,j)<-1.19
         ctestall24(i,j)=1;                                             % Dust ratio is 0.3 and AP ratio is 0.7
         PM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.3)+((twnext(i,j)*AP_slope+AP_inter)*0.7);
         elseif  cslope470660sss(i,j)>=-1.51 && cslope470660sss(i,j)<-1.35
         ctestall24(i,j)=0;                                             % Dust ratio is 0.2 and AP ratio is 0.8
         PM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.2)+((twnext(i,j)*AP_slope+AP_inter)*0.8);
         elseif  cslope470660sss(i,j)>-1.67 && cslope470660sss(i,j)<-1.51
         ctestall24(i,j)=-1;                                             %  AP ratio is 1
         PM(i,j)=twnext(i,j)*AP_slope+AP_inter;
         elseif  cslope470660sss(i,j)>-1.83 && cslope470660sss(i,j)<-1.67
         ctestall24(i,j)=-1;                                             %  AP ratio is 1   
         PM(i,j)=twnext(i,j)*AP_slope+AP_inter;
         elseif  cslope470660sss(i,j)>=-1.94 && cslope470660sss(i,j)<-1.83
         ctestall24(i,j)=-2;                                             % AP ratio is 0.8 and BB ratio is 0.2
         PM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.8)+((twnext(i,j)*BB_slope+BB_inter)*0.2);
         elseif  cslope470660sss(i,j)>=-2.00 && cslope470660sss(i,j)<-1.94
         ctestall24(i,j)=-3;                                             % AP ratio is 0.7 and BB ratio is 0.3
         PM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.7)+((twnext(i,j)*BB_slope+BB_inter)*0.3);
         elseif  cslope470660sss(i,j)>=-2.06 && cslope470660sss(i,j)<-2.00
         ctestall24(i,j)=-4;                                             % AP ratio is 0.6 and BB ratio is 0.4  
         PM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.6)+((twnext(i,j)*BB_slope+BB_inter)*0.4);
         elseif  cslope470660sss(i,j)>=-2.11 && cslope470660sss(i,j)<-2.06
         ctestall24(i,j)=-5;                                             % AP ratio is 0.5 and BB ratio is 0.5 
         PM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.5)+((twnext(i,j)*BB_slope+BB_inter)*0.5);
         elseif  cslope470660sss(i,j)>=-2.17 && cslope470660sss(i,j)<-2.11
         ctestall24(i,j)=-6;                                             % AP ratio is 0.4 and BB ratio is 0.6 
         PM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.4)+((twnext(i,j)*BB_slope+BB_inter)*0.6);
         elseif  cslope470660sss(i,j)>=-2.22 && cslope470660sss(i,j)<-2.17
         ctestall24(i,j)=-7;                                             % AP ratio is 0.3 and BB ratio is 0.7
         PM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.3)+((twnext(i,j)*BB_slope+BB_inter)*0.7);
         elseif  cslope470660sss(i,j)>-2.28 && cslope470660sss(i,j)<-2.22
         ctestall24(i,j)=-8;                                             % AP ratio is 0.2 and BB ratio is 0.8
         PM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.2)+((twnext(i,j)*BB_slope+BB_inter)*0.8);
         elseif  cslope470660sss(i,j)<=-2.28
         ctestall24(i,j)=-9;                                             % BB ratio is 1 
         PM(i,j)=(twnext(i,j)*BB_slope+BB_inter);
         end
      end
end 

         ctestall243=ctestall24;

F2=((CAODData470-2*CAODData550+CAODData660)/((0.47-0.55)^2))./CAODData470;

for i=1:la
      for j=1:lo
         if cslope470660sss(i,j)>=-1.65 && cslope470660sss(i,j)<=-0.70 && F2(i,j)>=4.71 && F2(i,j)<=9.30;
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
         if  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-0.46 % DS ratio is 1
         ctestall243(i,j)=7;  
          PM(i,j)=twnext(i,j)*DS_slope+DS_inter;
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-0.67 && cslope470660sss(i,j)<-0.46
         ctestall243(i,j)=-17;                                            % DS ratio is 0.8 and BB ratio is 0.2       
          PM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.2)+((twnext(i,j)*DS_slope+DS_inter)*0.8);
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-0.89 && cslope470660sss(i,j)<-0.67
         ctestall243(i,j)=-16;                                            % DS ratio is 0.7 and BB ratio is 0.3     
          PM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.3)+((twnext(i,j)*DS_slope+DS_inter)*0.7);
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-1.10 && cslope470660sss(i,j)<-0.89
         ctestall243(i,j)=-15;                                             % DS ratio is 0.6 and BB ratio is 0.4        
          PM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.4)+((twnext(i,j)*DS_slope+DS_inter)*0.6);
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-1.32 && cslope470660sss(i,j)<-1.10
         ctestall243(i,j)=-14;                                             % DS ratio is 0.5 and BB ratio is 0.5 
          PM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.5)+((twnext(i,j)*DS_slope+DS_inter)*0.5);
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-1.53 && cslope470660sss(i,j)<-1.32
         ctestall243(i,j)=-13;                                             % DS ratio is 0.4 and BB ratio is 0.6
          PM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.6)+((twnext(i,j)*DS_slope+DS_inter)*0.4);
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-1.75 && cslope470660sss(i,j)<-1.53
         ctestall243(i,j)=-12;                                             % DS ratio is 0.3 and BB ratio is 0.7
          PM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.7)+((twnext(i,j)*DS_slope+DS_inter)*0.3);
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)>=-1.96 && cslope470660sss(i,j)<-1.75
         ctestall243(i,j)=-11;                                             % DS ratio is 0.2 and BB ratio is 0.8
          PM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.8)+((twnext(i,j)*DS_slope+DS_inter)*0.2);
         elseif  ctestall2444(i,j)==-19 && cslope470660sss(i,j)<-1.96
         ctestall243(i,j)=-10;                                           
         PM(i,j)=twnext(i,j)*BB_slope+BB_inter; %BB ratio is 1
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

%% GMAO PBLH
%name = HJ; %file name
%name = 'GEOS.fp.asm.tavg1_2d_flx_Nx.20180217_0230.V01.nc4'; %file name
pblh0 = ncread(name,'PBLH');
lat0 = ncread(name,'lat');
lon0 = ncread(name,'lon');
 pblh1 = pblh0(959:969,447:464);
 lat1 = (lat0(447:464));
 lon1 = (lon0(959:969));
Gpblh = double(pblh1);
Glat = double(lat1);
Glon = double(lon1);
Gpb1 = Gpblh';
Gpb=flipud(Gpb1)./1000;
pblon=zeros(18,11);
pblat=zeros(18,11);
for i=1:11
    pblon(:,i)=Glon(i);
end
for i=1:18
    pblat(19-i,:)=Glat(i);
end
%% INT. 

[a1,a2] = find(X > 21 & X < 26);
[b1,b2] = find(Y > 118 & Y < 123);
c1 = intersect(a1,b1); 
c2 = intersect(a2,b2);

tw = daod660;

twlon = Y;
twlat = X;

la = size(X,1);
lo = size(Y,2);
AA = find(isnan(tw)==1);%
twpb2 = barnes(pblon,pblat,Gpb,twlon,twlat,0.2,0.2);
%% Mode 
twmode = zeros(la,lo);
for i = 1:la;
    for k = 1:lo;
        if isnan(twpb2(i,k))==1;
           % disp([i k]) ;
        else
           twmode(i,k) = (((0.2*twpb2(i,k)+0.1*tw(i,k))-0.065)./1.163)*3.37;
        end
    end
end
%% Sigma
twsigma = zeros(la,lo);
for i = 1:la;
    for k = 1:lo;
        if isnan(twpb2(i,k))==1
            %disp([i k]);
        else
            if (twpb2(i,k)-twmode(i,k))>=0.4
                T = (twpb2(i,k)-2.5*twmode(i,k));
                HR = ((twpb2(i,k))/(twmode(i,k)));
                dh = (twpb2(i,k)-twmode(i,k));
                slope = (-7.309)*dh+8.818;
                twsigma(i,k) = (HR-2.5)./(slope*T*dh);
            else
                T = (twpb2(i,k)-1.3*twmode(i,k));
                HR = ((twpb2(i,k))./(twmode(i,k)));
                dh = (twpb2(i,k)-twmode(i,k));
                slope = (-32.13)*dh+20.47;
                twsigma(i,k) = (HR-1.3)./(slope*T*dh);
            end
        end
    end
end
%% Mu
twmu=zeros(la,lo);
for i = 1:la;
    for k = 1:lo;
        if isnan(twpb2(i,k))==1
            %disp([i k]);         
        else
            twmu(i,k) = log(twmode(i,k))+twsigma(i,k)^2;
        end
    end
end
%% Extinction
twnext = zeros(la,lo);
twnext200 = zeros(la,lo);
twnext270 = zeros(la,lo);
twnext340 = zeros(la,lo);
twnext410 = zeros(la,lo);
twnext480 = zeros(la,lo);
y1 = 0.0375:0.075:10.0125;
y2 = 0.0375:0.075:7.0125;
for i = 1:la;
    for k = 1:lo;
        if isnan(twpb2(i,k))==1
           %disp([i k]);
        else
            mu = twmu(i,k);
            si = twsigma(i,k);
            % pdf 
            p1 = pdf('Lognormal',y2,mu,si);
            p2 = p1;
            p2 = p1-p1(1,94);
            p2(1,134) = 0;
            p2(find(p2<0)) = 0;
            p3 = p2;
            p3(1,1:2) = p3(1,3);
            Q2=trapz(y1,p3);
            p4=p3.*(1/Q2);
            twnext200(i,k)=(tw(i,k).*p4(1,3));
            p5=p2;
            p5(1,1:6)=p5(1,7);
            Q3=trapz(y1,p5);
            p6=p5.*(1/Q3);           
            twnext480(i,k)=(tw(i,k).*p6(1,3));
            p7=p2;
            p7(1,1:3)=p7(1,4);
            Q4=trapz(y1,p7);
            p8=p7.*(1/Q4);
            twnext270(i,k)=(tw(i,k).*p8(1,3));
            p9=p2;
            p9(1,1:4)=p7(1,5);
            Q5=trapz(y1,p9);
            p10=p9.*(1/Q5);
            twnext340(i,k)=(tw(i,k).*p10(1,3));
            p11=p2;
            p11(1,1:5)=p7(1,6);
            Q6=trapz(y1,p11);
            p12=p11.*(1/Q6);
            twnext410(i,k)=(tw(i,k).*p12(1,3));
            
            if (twpb2(i,k)-twmode(i,k)) >= 0.4
                if twmode(i,k) <= 0.2625
                    twnext(i,k) = twnext200(i,k);
                elseif twmode(i,k) > 0.2625 & twmode(i,k) <= 0.6375
                    twnext(i,k) = twnext270(i,k);
                elseif twmode(i,k) > 0.6375 & twmode(i,k) <= 0.7875
                    twnext(i,k) = twnext340(i,k);
                elseif twmode(i,k) > 0.7875 & twmode(i,k) <= 0.8625
                    twnext(i,k) = twnext410(i,k);
                else
                    twnext(i,k) = twnext480(i,k);
                end
            else
                if twmode(i,k) <= 0.4125
                    twnext(i,k) = twnext200(i,k);
                elseif twmode(i,k) > 0.4125 & twmode(i,k) <= 0.6375
                    twnext(i,k) = twnext270(i,k);
                elseif twmode(i,k) > 0.6375 & twmode(i,k) <= 0.7125
                    twnext(i,k) = twnext340(i,k);
                elseif twmode(i,k) > 0.7125 & twmode(i,k) <= 0.8625
                    twnext(i,k) = twnext410(i,k);
                else
                    twnext(i,k) = twnext480(i,k);
                end
            end
        end
    end
end

%% surface ext
twnext=real(twnext);
twnext2=twnext;
%% SURFACE AOD
dPM=twnext2;

%% aerosol type with mixture ratio aerosol type
for i=1:la
    for j=1:lo
         if  dslope470660sss(i,j)>=-0.24
         dtestall24(i,j)=7; %total is Dust aerosol
         dPM(i,j)=twnext(i,j)*DS_slope+DS_inter;
         elseif  dslope470660sss(i,j)>=-0.56 && dslope470660sss(i,j)<-0.24
         dtestall24(i,j)=6;                                            % Dust ratio is 0.8 and AP ratio is 0.2    
         dPM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.8)+((twnext(i,j)*AP_slope+AP_inter)*0.2);
         elseif  dslope470660sss(i,j)>=-0.72 && dslope470660sss(i,j)<-0.56
         dtestall24(i,j)=5;                                            % Dust ratio is 0.7 and AP ratio is 0.3     
         dPM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.7)+((twnext(i,j)*AP_slope+AP_inter)*0.3);
         elseif  dslope470660sss(i,j)>=-0.88 && dslope470660sss(i,j)<-0.72
         dtestall24(i,j)=4;                                             % Dust ratio is 0.6 and AP ratio is 0.4  
         dPM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.6)+((twnext(i,j)*AP_slope+AP_inter)*0.4);
         elseif  dslope470660sss(i,j)>=-1.04 && dslope470660sss(i,j)<-0.88
         dtestall24(i,j)=3;                                             % Dust ratio is 0.5 and AP ratio is 0.5 
         dPM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.5)+((twnext(i,j)*AP_slope+AP_inter)*0.5);
         elseif  dslope470660sss(i,j)>=-1.19 && dslope470660sss(i,j)<-1.04
         dtestall24(i,j)=2;                                             % Dust ratio is 0.4 and AP ratio is 0.6
         dPM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.4)+((twnext(i,j)*AP_slope+AP_inter)*0.6);
         elseif  dslope470660sss(i,j)>=-1.35 && dslope470660sss(i,j)<-1.19
         dtestall24(i,j)=1;                                             % Dust ratio is 0.3 and AP ratio is 0.7
         dPM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.3)+((twnext(i,j)*AP_slope+AP_inter)*0.7);
         elseif  dslope470660sss(i,j)>=-1.51 && dslope470660sss(i,j)<-1.35
         dtestall24(i,j)=0;                                             % Dust ratio is 0.2 and AP ratio is 0.8
         dPM(i,j)=((twnext(i,j)*DS_slope+DS_inter)*0.2)+((twnext(i,j)*AP_slope+AP_inter)*0.8);
         elseif  dslope470660sss(i,j)>-1.67 && dslope470660sss(i,j)<-1.51
         dtestall24(i,j)=-1;                                             %  AP ratio is 1
         dPM(i,j)=twnext(i,j)*AP_slope+AP_inter;
         elseif  dslope470660sss(i,j)>-1.83 && dslope470660sss(i,j)<-1.67
         dtestall24(i,j)=-1;                                             %  AP ratio is 1   
         dPM(i,j)=twnext(i,j)*AP_slope+AP_inter;
         elseif  dslope470660sss(i,j)>=-1.94 && dslope470660sss(i,j)<-1.83
         dtestall24(i,j)=-2;                                             % AP ratio is 0.8 and BB ratio is 0.2
         dPM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.8)+((twnext(i,j)*BB_slope+BB_inter)*0.2);
         elseif  dslope470660sss(i,j)>=-2.00 && dslope470660sss(i,j)<-1.94
         dtestall24(i,j)=-3;                                             % AP ratio is 0.7 and BB ratio is 0.3
         dPM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.7)+((twnext(i,j)*BB_slope+BB_inter)*0.3);
         elseif  dslope470660sss(i,j)>=-2.06 && dslope470660sss(i,j)<-2.00
         dtestall24(i,j)=-4;                                             % AP ratio is 0.6 and BB ratio is 0.4   
         dPM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.6)+((twnext(i,j)*BB_slope+BB_inter)*0.4);
         elseif  dslope470660sss(i,j)>=-2.11 && dslope470660sss(i,j)<-2.06
         dtestall24(i,j)=-5;                                             % AP ratio is 0.5 and BB ratio is 0.5  
         dPM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.5)+((twnext(i,j)*BB_slope+BB_inter)*0.5);
         elseif  dslope470660sss(i,j)>=-2.17 && dslope470660sss(i,j)<-2.11
         dtestall24(i,j)=-6;                                             % AP ratio is 0.4 and BB ratio is 0.6 
         dPM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.4)+((twnext(i,j)*BB_slope+BB_inter)*0.6);
         elseif  dslope470660sss(i,j)>=-2.22 && dslope470660sss(i,j)<-2.17
         dtestall24(i,j)=-7;                                             % AP ratio is 0.3 and BB ratio is 0.7
         dPM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.3)+((twnext(i,j)*BB_slope+BB_inter)*0.7);
         elseif  dslope470660sss(i,j)>-2.28 && dslope470660sss(i,j)<-2.22
         dtestall24(i,j)=-8;                                             % AP ratio is 0.2 and BB ratio is 0.8
         dPM(i,j)=((twnext(i,j)*AP_slope+AP_inter)*0.2)+((twnext(i,j)*BB_slope+BB_inter)*0.8);
         elseif  dslope470660sss(i,j)<=-2.28
         dtestall24(i,j)=-9;                                             % BB ratio is 1 
         dPM(i,j)=twnext(i,j)*BB_slope+BB_inter;
         end
      end
end  

F22=((daod412-2*daod550+twnext)/((0.412-0.55)^2))./daod412;

for i=1:la
    for j=1:lo
         if dslope470660sss(i,j)>=-1.65 && dslope470660sss(i,j)<=-0.70 && F22(i,j)>=4.71 && F22(i,j)<=9.30;
        dtestall2444(i,j)=-19; 
%          elseif F2(i,j)>=3;
%         dtestall2444(i,j)=7;         
         else
          dtestall2444(i,j)=dtestall24(i,j);     
         end
      end
end 

for i=1:la
    for j=1:lo
         if  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-0.46
         dtestall243(i,j)=7;  
         dPM(i,j)=twnext(i,j)*BB_slope+BB_inter;
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-0.67 && dslope470660sss(i,j)<-0.46
         dtestall243(i,j)=-17;                                            % BB ratio is 0.8 and DS ratio is 0.2   
         dPM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.8)+((twnext(i,j)*DS_slope+DS_inter)*0.2);
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-0.89 && dslope470660sss(i,j)<-0.67
         dtestall243(i,j)=-16;                                            % BB ratio is 0.7 and DS ratio is 0.3  
         dPM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.7)+((twnext(i,j)*DS_slope+DS_inter)*0.3);
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-1.10 && dslope470660sss(i,j)<-0.89
         dtestall243(i,j)=-15;                                             % BB ratio is 0.6 and DS ratio is 0.4   
         dPM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.6)+((twnext(i,j)*DS_slope+DS_inter)*0.4);
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-1.32 && dslope470660sss(i,j)<-1.10
         dtestall243(i,j)=-14;                                             % BB ratio is 0.5 and DS ratio is 0.5 
         dPM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.5)+((twnext(i,j)*DS_slope+DS_inter)*0.5);
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-1.53 && dslope470660sss(i,j)<-1.32
         dtestall243(i,j)=-13;                                             % BB ratio is 0.4 and DS ratio is 0.6
         dPM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.4)+((twnext(i,j)*DS_slope+DS_inter)*0.6);
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-1.75 && dslope470660sss(i,j)<-1.53
         dtestall243(i,j)=-12;                                             % BB ratio is 0.3 and DS ratio is 0.7
         dPM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.3)+((twnext(i,j)*DS_slope+DS_inter)*0.7);
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)>=-1.96 && dslope470660sss(i,j)<-1.75
         dtestall243(i,j)=-11;                                             % BB ratio is 0.2 and DS ratio is 0.8
         dPM(i,j)=((twnext(i,j)*BB_slope+BB_inter)*0.2)+((twnext(i,j)*DS_slope+DS_inter)*0.8);
         elseif  dtestall2444(i,j)==-19 && dslope470660sss(i,j)<-1.96
         dtestall243(i,j)=-10;                                             % BB ratio is 0.1 and DS ratio is 0.9
         dPM(i,j)=twnext(i,j)*DS_slope+DS_inter;
         else
         dtestall243(i,j)=dtestall2444(i,j);
          dPM(i,j)=dPM(i,j);
         end
      end
end 

%%
dctestall243=ctestall243;
dcAODData660=CAODData660;
dctestall2=ctestall2;
dcPM=PM;
dctwpb=twpb;
dctwnext=twnext1;
for i=1:la
    for j=1:lo
          if  isnan(dcAODData660(i,j))
              dctestall243(i,j)=dtestall243(i,j);
              dcAODData660(i,j)=daod660(i,j);
              dctestall2(i,j)=dtestall2(i,j);
              dcPM(i,j)=dPM(i,j);
              dctwpb(i,j)=twpb2(i,j);
              dctwnext(i,j)=twnext2(i,j);
          else
              dctestall243(i,j)=ctestall243(i,j);
              dcAODData660(i,j)=CAODData660(i,j);
              dctestall2(i,j)=ctestall2(i,j);
              dcPM(i,j)=PM(i,j);
              dctwpb(i,j)=twpb(i,j);
              dctwnext(i,j)=twnext1(i,j);
          end
      end
end


savename=['/Volumes/YUCHIHUANG/Matlab/',CASE_name,'/mat/',date1,'_10T3km']

save(savename,'X','Y','dctestall243','dctestall2','dcAODData660','dcPM','dctwpb','dctwnext') 
%clearvars -except x m n xx mm nn f num num2 KI KI2 LI LI2 X Y

end
toc
