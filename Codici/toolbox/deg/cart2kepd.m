function [orbit , th] = cart2kepd(r, v, mu)
% cart2kep.m - Conversion from Cartesian coordinates to Keplerian elements
%
% PROTOTYPE:
% [orbit , th] = car2kep(r, v, mu)
%
% DESCRIPTION:
% Conversion from Cartesian coordinates to Keplerian elements. Angles in
% degrees.
%
% INPUT:
% orbit [1x1] orbit struct   
%   
% mu [1x1] Gravitational parameter [km^3/s^2]
%
% OUTPUT:
% a [1x1] Semi-major axis [km]
% e [1x1] Eccentricity [-]
% i [1x1] Inclination [deg]
% RAAN [1x1] RAAN [deg]
% om [1x1] Pericentre anomaly [deg]
% th [1x1] True anomaly [deg]

if nargin == 2
    mu = 398600.433;
end



% r and v norm
r_norm=norm(r);
v_norm=norm(v);
% angular momentum
h=cross(r,v);
h_norm=norm(h);
% Inclination
i=acosd(h(3)/h_norm);
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
    OM=acosd(N(1)/N_norm);
else 
    OM=2*pi-acosd(N(1)/N_norm);
end
% Pericenter anomaly
if e(3)>=0
    om=acosd((dot(N,e)/(N_norm*e_norm)));
else
    om=2*pi-acosd((dot(N,e)/(N_norm*e_norm)));
end
% Radial speed
V_r=dot(r,v)/r_norm;
% True anomaly
if V_r>=0
    th=acosd(dot(e,r)/(e_norm*r_norm));
else
    th=2*pi-acosd(dot(e,r)/(e_norm*r_norm));
end
orbit.e = e_norm;
orbit.a = a;
orbit.OM = OM;
orbit.om = om;
orbit.inc = i;
end



