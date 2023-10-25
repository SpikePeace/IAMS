r=[10000;20000;10000];
v=[-2.5;-2.5;3];
mu=398600.433;
[a, e, i, OM, om, th] = car2kep(r, v, mu)

kep=[a; e; i; OM; om; th]
% Call the Terra_3D Function
Terra3d;
% Call the plotOrbit function
[X,Y,Z] = plotOrbit(kep,mu,2*pi,deg2rad(0.1));
% Plot the 3D satellite orbit
Thf=kepEl(6):stepTh:kepEl(6)+deltaTh;
for i=1:length(Thf)
    r=kep2car(kepEl(1),kepEl(2),kepEl(3),kepEl(4),kepEl(5),Thf(i),mu);
    X(i)=r(1);
    Y(i)=r(2);
    Z(i)=r(3);
end
plot3(X,Y,Z);
Terra3d;
% Define an indefinite plot
h = plot3(nan,nan,nan,'or');
% Define the moving point
for i= 1:10:length(X)
set(h,'XData',X(i),'YData',Y(i),'ZData',Z(i));
drawnow
end




%%%%%%%

mu=398600.433;

%Punto iniziale
ri=[-7894.6436; -854.6173; 2641.2167];
vi=[-0.3252; -6.7530; -1.1450];

[ai, ei, ii, OMi, omi, thi] = car2kep(ri, vi, mu);
kepi=[ai; ei; ii; OMi; omi; thi];
[Xi,Yi,Zi] = plotOrbit(kepi,mu,2*pi,deg2rad(1));
%
hold on
Thf=kepi(6):deg2rad(1):kepi(6)+2*pi;
for i=1:length(Thf)
    r=kep2car(kepi(1),kepi(2),kepi(3),kepi(4),kepi(5),Thf(i),mu);
    Xi(i)=r(1);
    Yi(i)=r(2);
    Zi(i)=r(3);
end
plot3(Xi,Yi,Zi,':or','LineWidth',1,'MarkerIndices',1);
%

hold on
grid on

%Punto finale
af=13490.0000;
ef=0.3593;
iF=0.7717;
OMf=0.8843;
omf=1.7230;
thf=2.0450;

kepf=[af; ef; iF; OMf; omf; thf];
%
hold on
Thf=kepf(6):deg2rad(1):kepf(6)+2*pi;
for i=1:length(Thf)
    r=kep2car(kepf(1),kepf(2),kepf(3),kepf(4),kepf(5),Thf(i),mu);
    Xf(i)=r(1);
    Yf(i)=r(2);
    Zf(i)=r(3);
end
plot3(Xf,Yf,Zf,':ok','LineWidth',1,'MarkerIndices',1);
%
[Xf,Yf,Zf] = plotOrbit(kepf,mu,2*pi,deg2rad(1));

%%manovra standard 

%1) cambio piano
[Dv1,om1,th1,dt1] = changeOrbitalPlane(ai,ei,ii,OMi,omi,iF,OMf,thi); %ricontrollare
kep1=[ai; ei; iF; OMf; om1; th1];
figure
[X1,Y1,Z1] = plotOrbit(kep1,mu,2*pi,deg2rad(1));
%
hold on
Thf=kepi(6):deg2rad(1):kep1(6);
for i=1:length(Thf)
    r=kep2car(kepi(1),kepi(2),kepi(3),kepi(4),kepi(5),Thf(i),mu);
    Xi1(i)=r(1);
    Yi1(i)=r(2);
    Zi1(i)=r(3);
end
plot3(Xi1,Yi1,Zi1,'-go','LineWidth',1,'MarkerIndices',length(Thf)); %plotta lo spostamento dal punto iniziale al primo punto di manovra
%
%2) omega piccolo
dom=omf-om1;
[dv2,om2,th2,dt2] = changePeriapsisArg(ai,ei,om1,dom,th1);
kep2=[ai; ei; iF; OMf; om2; th2];
figure
[X2,Y2,Z2] = plotOrbit(kep2,mu,2*pi,deg2rad(1));
%
hold on
Thf=kep1(6):deg2rad(1):(kep2(6)+dom);
for i=1:length(Thf)
    r=kep2car(kep1(1),kep1(2),kep1(3),kep1(4),kep1(5),Thf(i),mu);
    X12(i)=r(1);
    Y12(i)=r(2);
    Z12(i)=r(3);
end
plot3(X12,Y12,Z12,'-bo','LineWidth',1,'MarkerIndices',length(Thf)); %plotta lo spostamento dal punto 1 al punto 2
%

%2.b) arrivo a apogeo sull'orbita 2
Thf=kep2(6):deg2rad(1):(pi);
for i=1:length(Thf)
    r=kep2car(kep2(1),kep2(2),kep2(3),kep2(4),kep2(5),Thf(i),mu);
    X2p(i)=r(1);
    Y2p(i)=r(2);
    Z2p(i)=r(3);
end
plot3(X2p,Y2p,Z2p,'-mo','LineWidth',1,'MarkerIndices',length(Thf));
[dt2p] = timeOfFlight(ai,ei,mu,kep2(6),pi);

%3)manovra bitangente apogeo (orbita 2) - perigeo (orbita finale)
[dv1,dv2,dv3,thf,dt,at,et] = changeOrbitShape(kep2(1),kep2(2),kep2(5),af,ef,omf,1);
kept=[at;et;iF;OMf;omf;pi];
%
hold on
Thf=pi:deg2rad(1):2*pi;
for i=1:length(Thf)
    r=kep2car(kept(1),kept(2),kept(3),kept(4),kept(5),Thf(i),mu);
    Xt(i)=r(1);
    Yt(i)=r(2);
    Zt(i)=r(3);
end
plot3(Xt,Yt,Zt,'-oc','LineWidth',1,'MarkerIndices',length(Thf));
figure
Terra3d;
[Xt,Yt,Zt] = plotOrbit(kept,mu,pi,deg2rad(1));
%3.b) arrivo a punto finale
[dtpf] = timeOfFlight(af,ef,mu,0,kepf(6));

hold on
PlotEarth



