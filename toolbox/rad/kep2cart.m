function [r,v] = kep2cart(orbit , th, mu)
% kep2car.m - Conversion from Keplerian elements to Cartesian coordinates
%
% PROTOTYPE:
% [r, v] = kep2car(a, e, i, OM, om, th, mu)
%
% DESCRIPTION:
% Conversion from Keplerian elements to Cartesian coordinates. Angles in
% radians.
%
% INPUT:
% orbit [1x1] Orbit struct 
% 
% 
% 
% 
% th [1x1] True anomaly [rad]
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
r=p/(1+orbit.e*cos(th));
% radius in perifocal coordinates 
r_pf=r*[cos(th);sin(th);0];
v_pf=sqrt(mu/p)*[-sin(th);orbit.e+cos(th);0];
% R3 OM
R3_OM=[cos(orbit.OM) sin(orbit.OM)   0;
      -sin(orbit.OM) cos(orbit.OM)   0;
         0       0       1];
% R1 i
R1_i=[   1       0       0;
         0    cos(orbit.inc)  sin(orbit.inc);
         0   -sin(orbit.inc)  cos(orbit.inc)];
% R3 om
R3_om=[cos(orbit.om) sin(orbit.om) 0;
      -sin(orbit.om) cos(orbit.om) 0;
         0       0       1];

T_pf_eci=(R3_om*R1_i*R3_OM)';
r=T_pf_eci*r_pf;
v=T_pf_eci*v_pf;
end














