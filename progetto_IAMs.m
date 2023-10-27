

r=[10000;20000;10000];
v=[-2.5;-2.5;3];
mu=398600.433;
[a, e, i, OM, om, th] = cart2kep(r, v, mu)

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

%%
%% manovra standard 

    %1) cambio piano
    [Dv1,om1,th1,dt1] = changeOrbitalPlane(ai,ei,ii,OMi,omi,iF,OMf,'o',thi); %ricontrollare
    kep1=[ai; ei; iF; OMf; om1; th1];
    figure
    [X1,Y1,Z1] = plotOrbit(kep1,mu,2*pi,deg2rad(1));
    
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
    [dv2,tha,th2] = changePeriapsisArg(ai,ei,om1,omf,th1);
    th2
    kep2=[ai; ei; iF; OMf; omf; th2(1,2)];
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

    orbit2.a=kep2(1);
    orbit2.e=kep2(2);
    orbit2.inc=kep2(3);
    orbit2.OM=kep2(4);
    orbit2.om=kep2(5);
    orbit2.rp=orbit2.a*(1-orbit2.e);
    orbit2.ra=orbit2.a*(1+orbit2.e);

    orbitf.a=kepf(1);
    orbitf.e=kepf(2);
    orbitf.inc=kepf(3);
    orbitf.OM=kepf(4);
    orbitf.om=kepf(5);
    orbitf.rp=orbitf.a*(1-orbitf.e);
    orbitf.ra=orbitf.a*(1+orbitf.e);



    [dv3t,dvt3,dt,orbitt] = bitangentTransfer(orbit2,orbitf,'ap');
    kept=[orbitt.a;orbitt.e;orbitt.inc;orbitt.OM;orbitt.om;0];
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

    Thf=0:deg2rad(1):thf;
    for i=1:length(Thf)
        r=kep2car(kepf(1),kepf(2),kepf(3),kepf(4),kepf(5),Thf(i),mu);
        Xf(i)=r(1);
        Yf(i)=r(2);
        Zf(i)=r(3);
    end
    plot3(Xf,Yf,Zf,'-k','LineWidth',1);
    
    hold on
    PlotEarth

%%
%% Cambio di piano lontano dall'orbita
%%(valutare se è meglio apogeo-perigeo o perigeo-apogeo

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

%A) apogeo-perigeo
    %1)portare al apogeo
    
    [dvi,dvf,null,thf,dt,at,et] = changeOrbitShape(ai,ei,omi,af,ef,omi,1);
    kept=[at;et;ii;OMi;omi;pi];
    hold on
    Thf=pi:deg2rad(1):2*pi;
    for i=1:length(Thf)
        r=kep2car(kept(1),kept(2),kept(3),kept(4),kept(5),Thf(i),mu);
        Xt(i)=r(1);
        Yt(i)=r(2);
        Zt(i)=r(3);
    end
    plot3(Xt,Yt,Zt,'-oc','LineWidth',1,'MarkerIndices',length(Thf));
    

    %2)Manovra bitangente tra orbita iniziale e orbita finale nel piano
    %dell'orbita iniziale
    
    kepfi=[af; ef; ii; OMi; omi; thf];
    hold on
    Thf=kepfi(6):deg2rad(1):kepfi(6)+2*pi;
    for i=1:length(Thf)
        r=kep2car(kepfi(1),kepfi(2),kepfi(3),kepfi(4),kepfi(5),Thf(i),mu);
        Xfi(i)=r(1);
        Yfi(i)=r(2);
        Zfi(i)=r(3);
    end
    plot3(Xfi,Yfi,Zfi,':ok','LineWidth',1,'MarkerIndices',1);
    [Xfi,Yfi,Zfi] = plotOrbit(kepfi,mu,2*pi,deg2rad(1));

    %2.b)da punto di arrivo precedente a punto di manovra 3 (devo fare
    %prima il comando successivo)

    hold on
    Thf=kepfi(6):deg2rad(1):kep3(6);
    for i=1:length(Thf)
        r=kep2car(kepfi(1),kepfi(2),kepfi(3),kepfi(4),kepfi(5),Thf(i),mu);
        Xi1(i)=r(1);
        Yi1(i)=r(2);
        Zi1(i)=r(3);
    end
    plot3(Xi1,Yi1,Zi1,'-go','LineWidth',1,'MarkerIndices',length(Thf));

    %3)cambio di piano
    [Dv1,om1,th1,dt1] = changeOrbitalPlane(af,ef,ii,OMi,omi,iF,OMf,0);
    kep3=[af; ef; iF; OMf; om1; th1];

    %4) cambio di om

    dom=omf-om1;
    [dv2,om2,th2,dt2] = changePeriapsisArg(af,ef,om1,dom,th1);
    kep4=[af; ef; iF; OMf; om2; th2];
   
    %
    hold on
    Thf=kep3(6):deg2rad(1):(kep4(6)+dom);
    for i=1:length(Thf)
        r=kep2car(kep3(1),kep3(2),kep3(3),kep3(4),kep3(5),Thf(i),mu);
        X12(i)=r(1);
        Y12(i)=r(2);
        Z12(i)=r(3);
    end
    plot3(X12,Y12,Z12,'-bo','LineWidth',1,'MarkerIndices',length(Thf));

    %5) arrivo a punto finale
    hold on
    Thf=kep4(6):deg2rad(1):(kepf(6)+2*pi);
    for i=1:length(Thf)
        r=kep2car(kep4(1),kep4(2),kep4(3),kep4(4),kep4(5),Thf(i),mu);
        X12(i)=r(1);
        Y12(i)=r(2);
        Z12(i)=r(3);
    end
    plot3(X12,Y12,Z12,'-go','LineWidth',1,'MarkerIndices',length(Thf));

%B) perigeo-apogeo
    %1)portare al perigeo
    
    Thf=kepi(6):deg2rad(1):2*pi;
    for i=1:length(Thf)
        r=kep2car(kepi(1),kepi(2),kepi(3),kepi(4),kepi(5),Thf(i),mu);
        Xt(i)=r(1);
        Yt(i)=r(2);
        Zt(i)=r(3);
    end
    plot3(Xt,Yt,Zt,'-ok','LineWidth',1,'MarkerIndices',length(Thf));
    

    %2)Manovra bitangente tra orbita iniziale e orbita finale nel piano
    %dell'orbita iniziale
    
    [dvi,dvf,null,tht,dt,at,et] = changeOrbitShape(ai,ei,omi,af,ef,omi,0);
    kept=[at;et;ii;OMi;omi;0];
    hold on
    Thf=0:deg2rad(1):pi;
    for i=1:length(Thf)
        r=kep2car(kept(1),kept(2),kept(3),kept(4),kept(5),Thf(i),mu);
        Xt(i)=r(1);
        Yt(i)=r(2);
        Zt(i)=r(3);
    end
    plot3(Xt,Yt,Zt,'-oc','LineWidth',1,'MarkerIndices',length(Thf));

    %orbita finale nel piano iniziale
    %kepfi=[af; ef; ii; OMi; omi; thf];
    %hold on
    %Thf=kepfi(6):deg2rad(1):kepfi(6)+2*pi;
    %for i=1:length(Thf)
    %    r=kep2car(kepfi(1),kepfi(2),kepfi(3),kepfi(4),kepfi(5),Thf(i),mu);
    %    Xfi(i)=r(1);
    %    Yfi(i)=r(2);
    %    Zfi(i)=r(3);
    %end
    %plot3(Xfi,Yfi,Zfi,':ok','LineWidth',1,'MarkerIndices',1);
    %[Xfi,Yfi,Zfi] = plotOrbit(kepfi,mu,2*pi,deg2rad(1));

    %2.b)da punto di arrivo precedente a punto di manovra 3 (devo fare
    %prima il comando successivo)

    hold on
    Thf=pi:deg2rad(1):kep3(6);
    for i=1:length(Thf)
        r=kep2car(kepfi(1),kepfi(2),kepfi(3),kepfi(4),kepfi(5),Thf(i),mu);
        Xi1(i)=r(1);
        Yi1(i)=r(2);
        Zi1(i)=r(3);
    end
    plot3(Xi1,Yi1,Zi1,'-go','LineWidth',1,'MarkerIndices',length(Thf));

    %3)cambio di piano
    [Dv1,om1,th1,dt1] = changeOrbitalPlane(af,ef,ii,OMi,omi,iF,OMf,pi);
    kep3=[af; ef; iF; OMf; om1; th1+pi];

    %4) cambio di om

    dom=omf-om1;
    [dv2,om2,th2,dt2] = changePeriapsisArg(af,ef,om1,dom,th1);
    kep4=[af; ef; iF; OMf; om2; th2];
   
    %
    hold on
    Thf=(2*pi-kep3(6)):deg2rad(1):(kep4(6)+dom);
    for i=1:length(Thf)
        r=kep2car(kep3(1),kep3(2),kep3(3),kep3(4),kep3(5),Thf(i),mu);
        X12(i)=r(1);
        Y12(i)=r(2);
        Z12(i)=r(3);
    end
    plot3(X12,Y12,Z12,'-bo','LineWidth',1,'MarkerIndices',length(Thf));

    %5) arrivo a punto finale
    hold on
    Thf=kep4(6):deg2rad(1):(kepf(6)+2*pi);
    for i=1:length(Thf)
        r=kep2car(kep4(1),kep4(2),kep4(3),kep4(4),kep4(5),Thf(i),mu);
        X12(i)=r(1);
        Y12(i)=r(2);
        Z12(i)=r(3);
    end
    plot3(X12,Y12,Z12,'-go','LineWidth',1,'MarkerIndices',length(Thf));

    
%%%%%

af=13490.0000;
ef=0.3593;
iF=0.7717;
OMf=0.8843;
omf=1.7230;
thf=2.0450;

orbitf=orbit(  af,ef,iF,OMf,omf,thf);
[rf, vf] = kep2cart(orbitf,thf)

h=cross(ri,rf);
h=h./norm(h)
pe=[0;0;1];
lu=[1;0;0];

is=acos(dot(h,pe)/(norm(h)*norm(pe))) %i del piano della secante

NA=cross(pe,h);
NA=NA./norm(NA);

OMs=acos(dot(NA,lu)/(norm(NA)*norm(lu))) %OM del piano della secante

plot3([0;ri(1)],[0;ri(2)],[0;ri(3)],'-ko','LineWidth',3,'MarkerIndices',2)
plot3([0;rf(1)],[0;rf(2)],[0;rf(3)],'-ro','LineWidth',3,'MarkerIndices',2)
plot3([0;h(1)],[0;h(2)],[0;h(3)],'-co','LineWidth',3,'MarkerIndices',2)
plot3([0;pe(1)],[0;pe(2)],[0;pe(3)],'-bo','LineWidth',3,'MarkerIndices',2)
plot3([0;NA(1)],[0;NA(2)],[0;NA(3)],'-mo','LineWidth',3,'MarkerIndices',2)
plot3([0;1],[0;0],[0;0],'-o','LineWidth',3,'MarkerIndices',2)
plot3([0;NAC],[0;0],[0;0],'-o','LineWidth',3,'MarkerIndices',2)


thi=acos(dot(NA,ri)/(norm(NA)*norm(ri)));
thf=2*pi-acos(dot(NA,rf)/(norm(NA)*norm(rf)));

dvtot=[];
es=[];
as=[];
for om=0:0.1:2*pi
    thprovvi=thi-om;
    thprovvf=thf-om;

    A=[ 1 -norm(ri)*cos(thprovvi); 1 -norm(rf)*cos(thprovvf)];
    b=[norm(ri);norm(rf)];

    x=A\b;

    p=x(1);
    es=[es x(2)];

    as=[as p/(1-es(end)^2)];

    orbits=orbit(as(end),es(end),is,OMs,om);
    [n,vs1]=kep2cart(orbits,thprovvi);
    [n,vs2]=kep2cart(orbits,thprovvf);
    dv1=norm(vs1-vi);
    dv2=norm(vf-vs2);
    
    dvtot=[dvtot dv1+dv2];
end

dvtot=[dvtot(1,1:1:30)]
plot([0:0.1:2.9],dvtot);
figure
plot([0:0.1:2*pi],as);
figure
plot([0:0.1:2*pi],es);
hold on
plot([0 2*pi],[0 0]);
plot([0 2*pi],[1 1])

dvtot=[dvtot(1,1:1:30)]
[dvs,g]=min(dvtot)


%orbita buona: om=5

thprovvi=thi-5;
    thprovvf=thf-5;

    A=[ 1 -norm(ri)*cos(thprovvi); 1 -norm(rf)*cos(thprovvf)];
    b=[norm(ri);norm(rf)];

    x=A\b;

    p=x(1);
    es=x(2);

    as=p/(1-es^2);

orbits5=orbit(as,es,is,OMs,5)
thprovv5=thi-5;


[X5 Y5 Z5] = plotOrbit(orbits5, 0, 2*pi, deg2rad(0.1))
hold on

%orbita di merda: om=3











