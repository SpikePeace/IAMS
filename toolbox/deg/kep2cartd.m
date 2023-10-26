function [r,v] = kep2cartd(orbit , th, mu)
% kep2car.m - Conversion from Keplerian elements to Cartesian coordinates
%
% PROTOTYPE:
% [r, v] = kep2car(a, e, i, OM, om, th, mu)
%
% DESCRIPTION:
% Conversion from Keplerian elements to Cartesian coordinates. Angles in
% degrees.
%
% INPUT:
% orbit [1x1] Orbit struct 
% 
% 
% 
% 
% th [1x1] True anomaly [deg]
% mu [1x1] Gravitational parameter [km^3/s^2]
%
% OUTPUT:
% r [3x1] Position vector [km]
% v [3x1] Velocity vector [km/s]

if nargin == 2
    mu = 398600.433;
end

% right semi
p=orbit.a*(1-orbit.e^2);
% radius
r=p/(1+orbit.e*cosd(th));
% radius in perifocal coordinates 
r_pf=r*[cosd(th);sind(th);0];
v_pf=sqrt(mu/p)*[-sind(th);orbit.e+cosd(th);0];
% R3 OM
R3_OM=[cosd(orbit.OM) sind(orbit.OM)   0;
      -sind(orbit.OM) cosd(orbit.OM)   0;
         0       0       1];
% R1 i
R1_i=[   1       0       0;
         0    cosd(orbit.inc)  sind(orbit.inc);
         0   -sind(orbit.inc)  cosd(orbit.inc)];
% R3 om
R3_om=[cosd(orbit.om) sind(orbit.om) 0;
      -sind(orbit.om) cosd(orbit.om) 0;
         0       0       1];

T_pf_eci=(R3_om*R1_i*R3_OM)';
r=T_pf_eci*r_pf;
v=T_pf_eci*v_pf;
end














