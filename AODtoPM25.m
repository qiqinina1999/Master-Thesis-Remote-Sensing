clear all;close all;
%cd /Volumes/YUCHIHUANG/MODISvsGroundStation/MODIS_mat/
%cd /Volumes/YUCHIHUANG/Chuang/MODIS_mat_1/
%cd /Volumes/YUCHIHUANG/Matlab/CASE_20201023/mat/
%cd /Volumes/YUCHIHUANG/Matlab/Work/MODIS_mat/
CASE_name='CASE_20191030';
cd /Volumes/YUCHIHUANG/Matlab/CaseAnalysis/CASE_20191030/PM_OceanLand_mat/mat/

MODISfilename=dir(['2*.mat']);

m = length(MODISfilename);
for k=1:m
    filename=MODISfilename(k).name
    load(filename);
    dctestall243(dcAODData660<0.1)=nan;
    dctestall2(dcAODData660<0.1)=nan;
    dcAODData660(dcAODData660<0.1)=nan;
    dctestall243(dcAODData470<0.1)=nan;
DS_slope=52.8;
DS_inter=9.68;
AP_slope=62.4;
AP_inter=12.4;
BB_slope=98.26;
BB_inter=15.36;
for i=1:size(dcAODData660,1)
    for j=1:size(dcAODData660,2)
         if  dctestall243(i,j)==7 %total is Dust aerosol
         PM_AOD(i,j)=dcAODData660(i,j)*DS_slope+DS_inter;
         PM_AOD_DS(i,j)=dcAODData660(i,j)*DS_slope+DS_inter;
         elseif  dctestall243(i,j)==6 % Dust ratio is 0.8 and AP ratio is 0.2    
         PM_AOD(i,j)=((dcAODData660(i,j)*DS_slope+DS_inter)*0.8)+((dcAODData660(i,j)*AP_slope+AP_inter)*0.2);
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.8;
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.2;
         elseif   dctestall243(i,j)==5                                            % Dust ratio is 0.7 and AP ratio is 0.3     
         PM_AOD(i,j)=((dcAODData660(i,j)*DS_slope+DS_inter)*0.7)+((dcAODData660(i,j)*AP_slope+AP_inter)*0.3);
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.7;
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.3;
         elseif   dctestall243(i,j)==4                                           % Dust ratio is 0.6 and AP ratio is 0.4  
         PM_AOD(i,j)=((dcAODData660(i,j)*DS_slope+DS_inter)*0.6)+((dcAODData660(i,j)*AP_slope+AP_inter)*0.4);
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.6;
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.4;
         elseif  dctestall243(i,j)==3                                             % Dust ratio is 0.5 and AP ratio is 0.5 
         PM_AOD(i,j)=((dcAODData660(i,j)*DS_slope+DS_inter)*0.5)+((dcAODData660(i,j)*AP_slope+AP_inter)*0.5);
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.5;
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.5;
         elseif   dctestall243(i,j)==2                                             % Dust ratio is 0.4 and AP ratio is 0.6
         PM_AOD(i,j)=((dcAODData660(i,j)*DS_slope+DS_inter)*0.4)+((dcAODData660(i,j)*AP_slope+AP_inter)*0.6);
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.4;
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.6;
         elseif   dctestall243(i,j)==1                                             % Dust ratio is 0.3 and AP ratio is 0.7
         PM_AOD(i,j)=((dcAODData660(i,j)*DS_slope+DS_inter)*0.3)+((dcAODData660(i,j)*AP_slope+AP_inter)*0.7);
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.3;
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.7;
         elseif  dctestall243(i,j)==0                                             % Dust ratio is 0.2 and AP ratio is 0.8
         PM_AOD(i,j)=((dcAODData660(i,j)*DS_slope+DS_inter)*0.2)+((dcAODData660(i,j)*AP_slope+AP_inter)*0.8);
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.2;
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.8;
         elseif   dctestall243(i,j)==-1                                             %  AP ratio is 1
         PM_AOD(i,j)=dcAODData660(i,j)*AP_slope+AP_inter;
         PM_AOD_AP(i,j)=dcAODData660(i,j)*AP_slope+AP_inter;
         elseif    dctestall243(i,j)==-2                                             % AP ratio is 0.8 and BB ratio is 0.2
         PM_AOD(i,j)=((dcAODData660(i,j)*AP_slope+AP_inter)*0.8)+((dcAODData660(i,j)*BB_slope+BB_inter)*0.2);
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.8;
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.2;
         elseif    dctestall243(i,j)==-3                                             % AP ratio is 0.7 and BB ratio is 0.3
         PM_AOD(i,j)=((dcAODData660(i,j)*AP_slope+AP_inter)*0.7)+((dcAODData660(i,j)*BB_slope+BB_inter)*0.3);
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.7;
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.3;
         elseif    dctestall243(i,j)==-4                                             % AP ratio is 0.6 and BB ratio is 0.4   
         PM_AOD(i,j)=((dcAODData660(i,j)*AP_slope+AP_inter)*0.6)+((dcAODData660(i,j)*BB_slope+BB_inter)*0.4);
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.6;
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.4;
         elseif    dctestall243(i,j)==-5                                             % AP ratio is 0.5 and BB ratio is 0.5  
         PM_AOD(i,j)=((dcAODData660(i,j)*AP_slope+AP_inter)*0.5)+((dcAODData660(i,j)*BB_slope+BB_inter)*0.5);
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.5;
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.5;
         elseif   dctestall243(i,j)==-6                                             % AP ratio is 0.4 and BB ratio is 0.6 
         PM_AOD(i,j)=((dcAODData660(i,j)*AP_slope+AP_inter)*0.4)+((dcAODData660(i,j)*BB_slope+BB_inter)*0.6);
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.4;
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.6;
         elseif   dctestall243(i,j)==-7                                             % AP ratio is 0.3 and BB ratio is 0.7
         PM_AOD(i,j)=((dcAODData660(i,j)*AP_slope+AP_inter)*0.3)+((dcAODData660(i,j)*BB_slope+BB_inter)*0.7);
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.3;
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.7;
         elseif   dctestall243(i,j)==-8                                             % AP ratio is 0.2 and BB ratio is 0.8
         PM_AOD(i,j)=((dcAODData660(i,j)*AP_slope+AP_inter)*0.2)+((dcAODData660(i,j)*BB_slope+BB_inter)*0.8);
         PM_AOD_AP(i,j)=(dcAODData660(i,j)*AP_slope+AP_inter)*0.2;
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.8;
         elseif  dctestall243(i,j)==-9                                             % BB ratio is 1 
         PM_AOD(i,j)=dcAODData660(i,j)*BB_slope+BB_inter; 
         PM_AOD_BB(i,j)=dcAODData660(i,j)*BB_slope+BB_inter;
         elseif  dctestall243(i,j)==-17                                            % DS ratio is 0.8 and BB ratio is 0.2   
         PM_AOD(i,j)=((dcAODData660(i,j)*BB_slope+BB_inter)*0.2)+((dcAODData660(i,j)*DS_slope+DS_inter)*0.8);
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.2;
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.8;
         elseif  dctestall243(i,j)==-16                                            % DS ratio is 0.7 and BB ratio is 0.3  
         PM_AOD(i,j)=((dcAODData660(i,j)*BB_slope+BB_inter)*0.3)+((dcAODData660(i,j)*DS_slope+DS_inter)*0.7);
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.3;
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.7;
         elseif   dctestall243(i,j)==-15                                            % DS ratio is 0.6 and BB ratio is 0.4   
         PM_AOD(i,j)=((dcAODData660(i,j)*BB_slope+BB_inter)*0.4)+((dcAODData660(i,j)*DS_slope+DS_inter)*0.6);
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.4;
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.6;
         elseif   dctestall243(i,j)==-14                                             % DS ratio is 0.5 and BB ratio is 0.5 
         PM_AOD(i,j)=((dcAODData660(i,j)*BB_slope+BB_inter)*0.5)+((dcAODData660(i,j)*DS_slope+DS_inter)*0.5);
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.5;
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.5;
         elseif  dctestall243(i,j)==-13                                             % DS ratio is 0.4 and BB ratio is 0.6
         PM_AOD(i,j)=((dcAODData660(i,j)*BB_slope+BB_inter)*0.6)+((dcAODData660(i,j)*DS_slope+DS_inter)*0.4);
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.6;
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.4;
         elseif   dctestall243(i,j)==-12                                             % DS ratio is 0.3 and BB ratio is 0.7
         PM_AOD(i,j)=((dcAODData660(i,j)*BB_slope+BB_inter)*0.7)+((dcAODData660(i,j)*DS_slope+DS_inter)*0.3);
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.7;
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.3;
         elseif   dctestall243(i,j)==-11                                             % DS ratio is 0.2 and BB ratio is 0.8
         PM_AOD(i,j)=((dcAODData660(i,j)*BB_slope+BB_inter)*0.8)+((dcAODData660(i,j)*DS_slope+DS_inter)*0.2);
         PM_AOD_BB(i,j)=(dcAODData660(i,j)*BB_slope+BB_inter)*0.8;
         PM_AOD_DS(i,j)=(dcAODData660(i,j)*DS_slope+DS_inter)*0.2;
         elseif  dctestall243(i,j)==-10                                             % BB ratio is 1
         PM_AOD(i,j)=dcAODData660(i,j)*BB_slope+BB_inter;
         PM_AOD_BB(i,j)=dcAODData660(i,j)*BB_slope+BB_inter;
         else
             PM_AOD(i,j)=nan;
             PM_AOD_BB(i,j)=nan;
             PM_AOD_DS(i,j)=nan;
             PM_AOD_AP(i,j)=nan;
         end
         
    end
end
%savename=['/Volumes/YUCHIHUANG/Matlab/CASE_20201023/PM_mat/',MODISfilename(k).name];
savename=['/Volumes/YUCHIHUANG/Matlab/CaseAnalysis/',CASE_name,'/PM_OceanLand_mat/PM_mat/',MODISfilename(k).name];
%save(savename,'X','Y','dctestall243','dctestall2','dcAODData660','PM_AOD','PM_AOD_BB','PM_AOD_DS','PM_AOD_AP','ddsslope470660sss','F222');
save(savename,'X','Y','dctestall243','dcAODData660','dcAODData550','dcAODData470','PM_AOD','PM_AOD_BB','PM_AOD_DS','PM_AOD_AP');
end
