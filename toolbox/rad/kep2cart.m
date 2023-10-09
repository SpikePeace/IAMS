function [r,v] = kep2cart(a, e, i, OM, om, th, mu)
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
% a [1x1] Semi-major axis [km]
% e [1x1] Eccentricity [-]
% i [1x1] Inclination [deg]
% OM [1x1] RAAN [deg]
% om [1x1] Pericentre anomaly [deg]
% th [1x1] True anomaly [deg]
% mu [1x1] Gravitational parameter [km^3/s^2]
%
% OUTPUT:
% r [3x1] Position vector [km]
% v [3x1] Velocity vector [km/s]
% right semi
p=a*(1-e^2);
% radius
r=p/(1+e*cos(th));
% radius in perifocal coordinates 
r_pf=r*[cos(th);sin(th);0];
v_pf=sqrt(mu/p)*[-sin(th);e+cos(th);0];
% R3 OM
R3_OM=[cos(OM) sin(OM)   0;
      -sin(OM) cos(OM)   0;
         0       0       1];
% R1 i
R1_i=[   1       0       0;
         0    cos(i)  sin(i);
         0   -sin(i)  cos(i)];
% R3 om
R3_om=[cos(om) sin(om) 0;
      -sin(om) cos(om) 0;
         0       0       1];
T_pf_eci=(R3_om*R1_i*R3_OM)';
r=T_pf_eci*r_pf;
v=T_pf_eci*v_pf;
end














