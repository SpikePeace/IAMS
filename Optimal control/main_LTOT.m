clear all;close all;format compact;

[problem,guess]=LTOT;          % Fetch the problem definition
options= problem.settings(150);                  % h method
% options= problem.settings(100,4);                  % hp method
[solution,MRHistory]=solveMyProblem( problem,guess,options);
[ tv, xv, uv ] = simulateSolution( problem, solution, 'ode113', 0.01 );
mu=398600.433;

%%%%%%%
PlotEarth
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

title("Orbits characterization")
legend("Initial Orbit", "Final Orbit")
xlabel("X coordinate (Km)")
ylabel("Y coordinate (Km)")
zlabel("Z coordinate (Km)")

plot3(xv(:,1),xv(:,2),xv(:,3))
figure
plot(tv,uv)