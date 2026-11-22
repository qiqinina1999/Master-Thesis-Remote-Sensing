clear all;close all;
TTT='hourly';
loadname=append('MODIS_PM_compared_',TTT,'.mat');
savename_AOD=append('./Figure/AODtoPM_',TTT,'.png');
savename_PM=append('./Figure/PMtoPM_',TTT,'.png');
load('mycolor333');
load(loadname);
%MODIS_AOD_total(MODIS_AOD_total<=0.1)=nan;
%MODIS_PM_total(MODIS_AOD_total<=0.1)=nan;
%MODIS_Type_total(MODIS_AOD_total<=0.1)=nan;
[y,m,d]=ymd(date_MODIS_LC);
new_date=datetime(y,m,d);
new_date_unique=unique(new_date);
for i=1:length(new_date_unique)
    AC=find(new_date==new_date_unique(i));
    MODIS_AOD_uni=mean(MODIS_AOD_total(AC,:),1,'omitnan');
    MODIS_PM_uni=mean(MODIS_PM_total(AC,:),1,'omitnan');
    MODIS_Type_uni=mean(MODIS_Type_total(AC(1),:),1,'omitnan');
    spec_PM_uni=mean(spec_PM_total(AC,:),1,'omitnan');
    MODIS_AOD(i,:)=MODIS_AOD_uni;
    MODIS_PM(i,:)=MODIS_PM_uni;
    MODIS_Type(i,:)=MODIS_Type_uni;
    Ground_PM(i,:)=spec_PM_uni;
end
%TTTT=[1 2 3 4 5 8 9 10 16 23 29 31 38 45 54 60 63];
%TTTT=[2 31 60];
%MODIS_AOD=MODIS_AOD(:,TTTT);
%MODIS_PM=MODIS_PM(:,TTTT);
%MODIS_Type=MODIS_Type(:,TTTT);
%Ground_PM=Ground_PM(:,TTTT);
%MODIS_AOD=reshape(MODIS_AOD,[],1);
%MODIS_PM=reshape(MODIS_PM,[],1);
%MODIS_Type=reshape(MODIS_Type,[],1);
%Ground_PM=reshape(Ground_PM,[],1);
MODIS_AOD=MODIS_AOD(:,58);%11 21
MODIS_PM=MODIS_PM(:,58);
MODIS_Type=MODIS_Type(:,58);
Ground_PM=Ground_PM(:,58);


Ground_PM_AOD=Ground_PM;MODIS_Type_AOD=MODIS_Type;

C=find(isnan(MODIS_AOD));
MODIS_AOD(C)=[];
Ground_PM_AOD(C)=[];
MODIS_Type_AOD(C)=[];
D=find(isnan(Ground_PM_AOD));
MODIS_AOD(D)=[];
Ground_PM_AOD(D)=[];
MODIS_Type_AOD(D)=[];

E=find(isnan(MODIS_PM));
MODIS_PM(E)=[];
Ground_PM(E)=[];
MODIS_Type(E)=[];
F=find(isnan(Ground_PM));
MODIS_PM(F)=[];
Ground_PM(F)=[];
MODIS_Type(F)=[];




%MODIS_AOD=MODIS_AOD(MODIS_Type_AOD==-9);
%Ground_PM_AOD=Ground_PM_AOD(MODIS_Type_AOD==-9);
%MODIS_Type_AOD=MODIS_Type_AOD(MODIS_Type_AOD==-9);

%MODIS_PM=MODIS_PM(MODIS_Type==-9);
%Ground_PM=Ground_PM(MODIS_Type==-9);
%MODIS_Type=MODIS_Type(MODIS_Type==-9);

%MODIS_AOD=MODIS_AOD_total(:,8);
%MODIS_PM=MODIS_PM_total(:,8);
%MODIS_Type=MODIS_Type_total(:,8);
%Ground_PM=spec_PM_total(:,8);

AOD=[MODIS_AOD Ground_PM_AOD MODIS_Type_AOD];
PM=[MODIS_PM Ground_PM MODIS_Type];
%AOD=rmoutliers(AOD,"grubbs") ;
%PM=rmoutliers(PM,"grubbs") ;
AOD=rmoutliers(AOD,"gesd") ;
PM=rmoutliers(PM,"gesd") ;

p_AOD=polyfit(AOD(:,1),AOD(:,2),1);
f_AOD=polyval(p_AOD,AOD(:,1));
p_PM=polyfit(PM(:,1),PM(:,2),1);
f_PM=polyval(p_PM,PM(:,1));

A=corrcoef(AOD(:,1),AOD(:,2),'Rows', 'pairwise','alpha',0.001)
B=corrcoef(PM(:,1),PM(:,2),'Rows','pairwise','alpha',0.001)
textname1=append('R=',string(round(A(2),3)));
textname2=append('R=',string(round(B(2),3)));
textname3=append('y=',string(round(p_AOD(1),3)),'x+',string(round(p_AOD(2),3)));
textname4=append('y=',string(round(p_PM(1),3)),'x+',string(round(p_PM(2),3)));
figure(1);
scatter(AOD(:,1),AOD(:,2),[],AOD(:,3),'filled')%,'MarkerEdgeColor','blue','MarkerFaceColor','black');
%scatter(MODIS_AOD,Ground_PM_AOD,'filled')%,'MarkerEdgeColor','blue','MarkerFaceColor','black');
text(1,70,textname1,'FontSize',14);
text(0.8,65,textname3,'FontSize',14);
box on
hold on
plot(AOD(:,1),f_AOD,'LineWidth',3,'Color','b');
title('MODIS AOD vs Ground PM_{2.5}','FontSize',18,'FontName','Consoals');
xlabel('MODIS AOD');
ylabel('Ground PM_{2.5} (ug/m^3)');
clim([-17 7]);
colormap(mycolor3);
lcolorbar({'DS','','≒ 0.7','','≒0.5','','≒ 0.3','','BB','','≒ 0.7','','≒ 0.5','','≒ 0.3','','AP','','≒ 0.7','','≒ 0.5','','≒ 0.3','','DS'},'fontsize',14,'fontweight','bold')
saveas(gcf,savename_AOD);
figure(2);
scatter(PM(:,1),PM(:,2),[],PM(:,3),'filled');
%scatter(MODIS_PM,Ground_PM,'filled');
text(75,75,textname2,'FontSize',14);
text(65,70,textname4,'FontSize',14);
hold on
plot(PM(:,1),f_PM,'LineWidth',3,'Color','b');
box on
title('MODIS Retrieval PM_{2.5} vs Ground PM_{2.5}','FontSize',18,'FontName','Consoals');
xlabel('MODIS Retrieval PM_{2.5} (ug/m^3)');
ylabel('Ground PM_{2.5} (ug/m^3)');
clim([-17 7]);
colormap(mycolor3);
lcolorbar({'DS','','≒ 0.7','','≒0.5','','≒ 0.3','','BB','','≒ 0.7','','≒ 0.5','','≒ 0.3','','AP','','≒ 0.7','','≒ 0.5','','≒ 0.3','','DS'},'fontsize',14,'fontweight','bold')
saveas(gcf,savename_PM);