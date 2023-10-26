function [deltaV, th_1, th_2] = changePericenterArg(a, e, om_i, om_f, mu)

if nargin == 4
    mu = 398600;
end

p = a*(1 - e^2);

delta_om = om_f - om_i;

th_1 (1) = delta_om/2; th_1 (2) = th_1 (1) + pi;
th_2 (1) = 2*pi - delta_om/2; th_2 (2) = pi - delta_om/2;

deltaV = 2 * sqrt(mu/p).*e.*sin(delta_om/2);



