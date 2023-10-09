function [a, e_norm, i, OM, om, th] = cart2kep(r, v, mu)
% cart2kep.m - Conversion from Cartesian coordinates to Keplerian elements
%
% PROTOTYPE:
% [a, e, i, OM, om, th] = car2kep(r, v, mu)
%
% DESCRIPTION:
% Conversion from Cartesian coordinates to Keplerian elements. Angles in
% degrees.
%
% INPUT:
% r [3x1] Position vector [km]
% v [3x1] Velocity vector [km/s]
% mu [1x1] Gravitational parameter [km^3/s^2]
%
% OUTPUT:
% a [1x1] Semi-major axis [km]
% e [1x1] Eccentricity [-]
% i [1x1] Inclination [deg]
% RAAN [1x1] RAAN [deg]
% om [1x1] Pericentre anomaly [deg]
% th [1x1] True anomaly [deg]

% r and v norm
r_norm=norm(r);
v_norm=norm(v);
% angular momentum
h=cross(r,v);
h_norm=norm(h);
% Inclination
i=acos(h(3)/h_norm);
% Eccentricity
e=1/mu*((v_norm^2-mu/r_norm)*r-dot(r,v)*v);
e_norm=norm(e);
% Mech energy and semi-major axis
eps=0.5*v_norm^2-mu/r_norm;
a=-mu/(2*eps);
% Ascending node
N=cross([0 0 1],h);
N_norm=norm(N);
% Right ascension ascending node
if N(2)>=0
    OM=acos(N(1)/N_norm);
else 
    OM=2*pi-acos(N(1)/N_norm);
end
% Pericenter anomaly
if e(3)>=0
    om=acos((dot(N,e)/(N_norm*e_norm)));
else
    om=2*pi-acos((dot(N,e)/(N_norm*e_norm)));
end
% Radial speed
V_r=dot(r,v)/r_norm;
% True anomaly
if V_r>=0
    th=acos(dot(e,r)/(e_norm*r_norm));
else
    th=2*pi-acos(dot(e,r)/(e_norm*r_norm));
end



