function [deltaV, orbit_f, th_1, th_2] = changePericenterArg(orbit_in_i, orbit_in_f, mu)

if nargin == 2
    mu = 398600;
end

a=orbit_in_i.a;
e=orbit_in_i.e;
om_i=orbit_in_i.om;
om_f=orbit_in_f.om;

p = a*(1 - e^2);

delta_om = om_f - om_i;

th_1 (1) = delta_om/2; th_1 (2) = th_1 (1) + pi;
th_2 (1) = 2*pi - delta_om/2; th_2 (2) = pi - delta_om/2;

deltaV = 2 * sqrt(mu/p).*e.*sin(delta_om/2);

orbit_f = orbit_in_i;
orbit_f.om = om_f;



