function [DeltaV, orbit_out, theta] = changeOrbitalPlane(orbit_in_i,orbit_in_f, type, mi)
% 
% Change of Plane maneuver
% 
% [DeltaV, orbit_out, dt] = changeOrbitalPlane(a, e, inc_i, OM_i, om_i, inc_f, OM_f, mi)
% 
% Input arguments:
% 
% orbit_in_i [1x1] Initial orbit
% orbit_in_f [1x] Final orbit
%   
%   
% 
% 
% type      "n" per calcolo normale, "o" per minimizzare DeltaV
% (mi)      gravitational parameter     [km^3/s^2]

% Output arguments:
% DeltaV    maneuver impulse            [km/s]
% orbit_out      final orbit            [rad]
% theta     true anomaly at maneuver    [rad]
%           (è già il theta in cui la manovra costa meno)
% dt        

if nargin == 3
    mi = 398600;
end

a=orbit_in_i.a;
e=orbit_in_i.e;
inc_i=orbit_in_i.inc;
OM_i=orbit_in_i.OM;
om_i=orbit_in_i.om;
inc_f=orbit_in_f.inc;
OM_f=orbit_in_f.OM;




dOM = OM_f - OM_i;
dinc = inc_f - inc_i;



if ( (dOM > 0) && (dinc > 0) )
    % Caso 1)
    alpha = acos(cos(inc_i)*cos(inc_f) + sin(inc_i)*sin(inc_f)*cos(dOM));
    cos_u_i = (-cos(inc_f)+cos(alpha)*cos(inc_i)) / (sin(alpha)*sin(inc_i));
    cos_u_f = (cos(inc_i)-cos(alpha)*cos(inc_f)) / (sin(alpha)*sin(inc_f));
    sin_u_i = sin(dOM) / sin(alpha) * sin(inc_f);
    sin_u_f = sin(dOM) / sin(alpha) * sin(inc_i);
    u_i = atan2(sin_u_i, cos_u_i);
    u_f = atan2(sin_u_f, cos_u_f);
    theta = u_i - om_i;
    om_f = u_f - theta;
end


if ( (dOM > 0) && (dinc < 0) )
    % Caso 2)
    alpha = acos(cos(inc_i)*cos(inc_f) + sin(inc_i)*sin(inc_f)*cos(dOM));
    cos_u_i = (cos(inc_f)-cos(alpha)*cos(inc_i)) / (sin(alpha)*sin(inc_i));
    cos_u_f = (-cos(inc_i)+cos(alpha)*cos(inc_f)) / (sin(alpha)*sin(inc_f));
    sin_u_i = sin(dOM) / sin(alpha) * sin(inc_f);
    sin_u_f = sin(dOM) / sin(alpha) * sin(inc_i);
    u_i = atan2(sin_u_i, cos_u_i);
    u_f = atan2(sin_u_f, cos_u_f);
    theta = 2*pi - u_i - om_i;
    om_f = 2*pi - u_f - theta;
end


if ( (dOM < 0) && (dinc > 0) )
    % Caso 3)
    alpha = acos(cos(inc_i)*cos(inc_f) + sin(inc_i)*sin(inc_f)*cos(dOM));
    cos_u_i = (-cos(inc_f)+cos(alpha)*cos(inc_i)) / (sin(alpha)*sin(inc_i));
    cos_u_f = (cos(inc_i)-cos(alpha)*cos(inc_f)) / (sin(alpha)*sin(inc_f));
    sin_u_i = sin(-dOM) / sin(alpha) * sin(inc_f);
    sin_u_f = sin(-dOM) / sin(alpha) * sin(inc_i);
    u_i = atan2(sin_u_i, cos_u_i);
    u_f = atan2(sin_u_f, cos_u_f);
    theta = 2*pi - u_i - om_i;
    om_f = 2*pi - u_f - theta;
end


if ( (dOM < 0) && (dinc < 0) )
    % Caso 4)
    alpha = acos(cos(inc_i)*cos(inc_f) + sin(inc_i)*sin(inc_f)*cos(dOM));
    cos_u_i = (cos(inc_f)-cos(alpha)*cos(inc_i)) / (sin(alpha)*sin(inc_i));
    cos_u_f = (-cos(inc_i)+cos(alpha)*cos(inc_f)) / (sin(alpha)*sin(inc_f));
    sin_u_i = sin(-dOM) / sin(alpha) * sin(inc_f);
    sin_u_f = sin(-dOM) / sin(alpha) * sin(inc_i);
    u_i = atan2(sin_u_i, cos_u_i);
    u_f = atan2(sin_u_f, cos_u_f);
    theta = u_i - om_i;
    om_f = u_f - theta;
end



% Se type = "o", trovo quale dei due valori di theta minimizza DeltaV,
% altrimenti tengo il valore calcolato sopra:
if type == "o"
    if ( (theta >= 0) && (theta < pi/2) )
        theta = theta + pi;
    else
        if ( (theta >= 3*pi/2) && (theta <= 2*pi) )
            theta = theta - pi;
        end
    end
    % Adesso theta è compreso fra pi/2 e 3*pi/2 (velocità trasversa minore)
end


% Calcolo costo della manovra:
p = a * (1 - e^2);
v_theta = sqrt(mi/p) * (1 + e*cos(theta));
DeltaV = 2 * v_theta * sin(alpha/2);

orbit_out.a=a;
orbit_out.e=e;
orbit_out.om=om_f;
orbit_out.inc=inc_f;
orbit_out.OM=OM_f;


