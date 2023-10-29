mu=398600.433;

%%%%%%%
PlotEarth
clear all
%% Punto iniziale
ri=[-7894.6436; -854.6173; 2641.2167];
vi=[-0.3252; -6.7530; -1.1450];

[orbit_i , th_i] = cart2kep(ri, vi);
plotOrbit(orbit_i,th_i,2*pi,deg2rad(1),'o--');
hold on

%% Punto finale
af=13490.0000;
ef=0.3593;
iF=0.7717;
OMf=0.8843;
omf=1.7230;
th_f=2.0450;

orbit_f = orbit(af,ef,iF,OMf,omf);

[rf vf] = kep2cart(orbit_f,th_f);


plotOrbit(orbit_f,th_f,2*pi,deg2rad(1),'o--');



%%
%%
%% manovra standard 

    %1) cambio piano

    [dv1,orbit_1, th_1] = changeOrbitalPlane(orbit_i,orbit_f,'o'); %ricontrollare   
    
    dt1 = TOF(orbit_i, th_i , th_1);

    plotOrbit(orbit_i,th_i,th_1-th_i,deg2rad(1));
    
    
    %2) omega piccolo

    [dv2, orbit_2, th_21, th_22] = changePericenterArg(orbit_1,orbit_f);
    
        % scelta theta
         th_21 = th_21(2);
         th_22 = th_22(2);
    
    dt2 = TOF(orbit_1,th_1,th_21);

    plotOrbit(orbit_1, th_1, th_21-th_1,deg2rad(0.5));

    %2.b) arrivo a apogeo sull'orbita 2
    
    plotOrbit(orbit_2, th_22, pi-th_22, deg2rad(0.5));

    dt2p = TOF(orbit_2, th_22, pi);
    
    %3)manovra bitangente apogeo (orbita 2) - perigeo (orbita finale)

    [dv3_1,dv3_2,dt3,orbit_t] = bitangentTransfer(orbit_2,orbit_f,'ap');

    plotOrbit(orbit_t,pi,pi,deg2rad(0.5));

    %3.b) arrivo a punto finale
    
    dt3p = TOF(orbit_f,0,th_f);

    plotOrbit(orbit_f,0,th_f,deg2rad(0.5));

    % Calcoli finali

    dv_tot = dv1 + dv2 + dv3_1 + dv3_2 ;
    dt_tot = dt1 + dt2 + dt2p + dt3 + dt3p;


    disp("DeltaV = " + dv_tot)
    disp("DeltaT = " + dt_tot)
%%
%% Ordine inverso
%%(valutare se è meglio apogeo-perigeo o perigeo-apogeo)



%A) apogeo-perigeo
    %1)portare all'apogeo
    
    dt1p = TOF(orbit_i, th_i, pi) ;
    plotOrbit(orbit_i, th_i, pi-th_i , deg2rad(0.5));
    

    %2) Manovra bitangente tra orbita iniziale e orbita finale nel piano
    %dell'orbita iniziale    
    
    orbit_1 = orbit_i;
    orbit_1.a = orbit_f.a;
    orbit_1.e = orbit_f.e;

    [dv1_1, dv1_2, dt1, orbit_t] = bitangentTransfer(orbit_i, orbit_1, 'ap');
    
    plotOrbit(orbit_t, pi, pi, deg2rad(0.5));


    %3) Cambio piano
   
    
    [dv2, orbit_2, th_2] = changeOrbitalPlane(orbit_1, orbit_f,'o');
    
    dt2 = TOF (orbit_1,0,th_2);
    
    plotOrbit(orbit_1, 0, th_2, deg2rad(0.5));
  


    %4) cambio di om

    [dv3, orbit_f , th_31, th_32] = changePericenterArg(orbit_2 , orbit_f);
    
        % Seleziono theta
        th_31 = th_31(2);
        th_32 = th_32(2);

    dt3 = TOF (orbit_2, th_31, 2*pi) ;

    plotOrbit (orbit_2, th_2, th_31-th_2, deg2rad(0.5)) ;

    %5) arrivo a punto finale
    
    dt4 = TOF (orbit_f, th_32, 2*pi+th_f) ;
    
    plotOrbit (orbit_f, th_32, 2*pi+th_f-th_32, deg2rad(0.5));

    
    % Calcoli finali 

    dv_tot = dv1_1 + dv1_2 + dv1_2 + dv2 + dv3 ;
    dt_tot = dt1p + dt1 + dt2 + dt3 + dt4 ;
    
    
    disp("DeltaV = " + dv_tot)
    disp("DeltaT = " + dt_tot)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%B) perigeo-apogeo
    %1)portare al perigeo
    
    dt1p = TOF(orbit_i, th_i, 2*pi) ;
    plotOrbit(orbit_i, th_i, 2*pi-th_i , deg2rad(0.5));

    %2) Manovra bitangente tra orbita iniziale e orbita finale nel piano
    % dell'orbita iniziale    
    
    orbit_1 = orbit_i;
    orbit_1.a = orbit_f.a;
    orbit_1.e = orbit_f.e;

    [dv1_1, dv1_2, dt1, orbit_t] = bitangentTransfer(orbit_i, orbit_1, 'pa');
    
    plotOrbit(orbit_t, 0, pi, deg2rad(0.5));


    %3) Cambio piano
    
    [dv2, orbit_2, th_2] = changeOrbitalPlane(orbit_1, orbit_f,'n');
    
    dt2 = TOF (orbit_1,pi,th_2);
    
    plotOrbit(orbit_1, pi, th_2-pi, deg2rad(0.5));
  


    %4) cambio di om

    [dv3, orbit_f , th_31, th_32] = changePericenterArg(orbit_2 , orbit_f);
    
        % Seleziono theta
        th_31 = th_31(1);
        th_32 = th_32(1);

    dt3 = TOF (orbit_2, th_2, 2*pi+th_31);

    plotOrbit (orbit_2, th_2, 2*pi+th_31-th_2, deg2rad(0.5)) ;

    %5) arrivo a punto finale
    
    dt4 = TOF (orbit_f, th_32, 2*pi+th_f) ;
    
    plotOrbit (orbit_f, th_32, 2*pi+th_f-th_32, deg2rad(0.5));

    
    % Calcoli finali 

    dv_tot = dv1_2 + dv1_2 + dv2 + dv3 ;
    dt_tot = dt1p + dt1 + dt2 + dt3 + dt4 ;
    
    
    disp("DeltaV = " + dv_tot)
    disp("DeltaT = " + dt_tot)

%% Trasferimento diretto

% Trovo piano contenente r_i , r_f , centro terra

% Direzione piano

orbit_plane_norm = cross (ri , rf) / norm ( cross( ri , rf ) );

NA = cross ( [0 0 1] , orbit_plane_norm ) / norm (cross ( [0 0 1] , orbit_plane_norm )) ;
 
OM = acos ( NA(1) ) ;

inc = acos ( orbit_plane_norm(3) ) ;

% Trovo th orbita iniziale e finale nel piano orbitale, rispetto all'asse
% dei nodi

th_i_AN = acos ( dot ( NA , ri ) / ( norm ( NA ) * norm ( ri ) ) ) ;
th_f_AN = 2*pi - acos ( dot ( NA , rf ) / ( norm ( NA ) * norm ( rf ) ) ) ;

% Valuto orbite di trasferimento al variare di om

om_vec = 0 : 0.1 : 2 * pi ;

orbit_t=struct();

for i = 1 : length( om_vec )
    
    % Calcolo th_i e th_f con l'om scelto
    om = om_vec ( i ) ;

    th_i = th_i_AN - om ;
    th_f = th_f_AN - om ;
    
    % Ricavo p ed e dell'orbita 

    A = [ 1 , -norm( ri )*cos( th_i ); 1 , -norm( rf )*cos( th_f ) ];
    b = [ norm( ri ) ; norm( rf )];

    x = A \ b;

    p = x( 1 ) ;
    e = x( 2 ) ;
    
    % Se e è accettabile procedo a valutare il trasferimento

    if (e > 0) && ( e < 1 )
        
        % Costruisco l'orbita

        orbit_t(end+1).e = e;
        orbit_t(end).om = om;
        orbit_t(end).th_i = th_i;
        orbit_t(end).th_f = th_f;
        orbit_t(end).a = p / (1 - e ^ 2);
        orbit_t(end).inc = inc;
        orbit_t(end).OM = OM;
        orbit_t(end).a = p / ( 1 - orbit_t( end ).e ^ 2 );
   
        % Calcolo le velocità nei punti iniziali e finali sull'orbita di
        % trasferimento
   
        [ ~ , v_t_1 ] = kep2cart( orbit_t(end) , orbit_t( end ).th_i ) ;
        [ ~ , v_t_2 ] = kep2cart( orbit_t(end) , orbit_t( end ).th_f ) ;

        % Trovo il deltaV come differenza vettoriale dei vettori velocità

        orbit_t(end).dv1 = norm( v_t_1 - vi ) ;
        orbit_t(end).dv2 = norm( vf - v_t_2 ) ;
        
        orbit_t( end ).dv_tot = orbit_t(end).dv1 + orbit_t(end).dv2 ;
        orbit_t( end ).dt_tot = TOF ( orbit_t(end), orbit_t(end).th_i, orbit_t(end).th_f);
    end
end


% Plot di eccentricità, deltaV, deltaT delle varie orbite possiibli

figure
plot([orbit_t(:).om],[orbit_t(:).e],'o')

figure
plot([orbit_t(:).om],[orbit_t(:).dv_tot],'o')

figure
plot([orbit_t(:).om],[orbit_t(:).dt_tot],'o')

% Trovo l'orbita ottimale in termini di dV

[~, j] = min ([orbit_t(:).dv_tot]);

transfer_orbit_dv = orbit_t(j);

figure(1)
plotOrbit(transfer_orbit_dv,transfer_orbit_dv.th_i,transfer_orbit_dv.th_f-transfer_orbit_dv.th_i,deg2rad(1));

% Trovo l'orbita ottimale in termini di dT

[~, l] = min ([orbit_t(:).dt_tot]);

transfer_orbit_dt = orbit_t(l);


plotOrbit(transfer_orbit_dt,transfer_orbit_dt.th_i,transfer_orbit_dt.th_f-transfer_orbit_dt.th_i,deg2rad(1));









