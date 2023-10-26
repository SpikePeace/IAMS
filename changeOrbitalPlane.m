function [DeltaV, om_f, theta] = changeOrbitalPlane(a, e, inc_i, OM_i, om_i, inc_f, OM_f, type, mi)
% 
% Change of Plane maneuver
% 
% [DeltaV, om_f, theta] = changeOrbitalPlane(a, e, inc_i, OM_i, om_i, inc_f, OM_f, mi)
% 
% Input arguments:
% a         semi-major axis             [km]
% e         eccentricity                [-]
% inc_i     initial inclination         [rad]
% OM_i      initial RAAN                [rad]
% om_i      initial pericenter anomaly  [rad]
% inc_f     final inclination           [rad]
% OM_f      final RAAN                  [rad]
% type      "n" per calcolo normale, "o" per minimizzare DeltaV
% (mi)      gravitational parameter     [km^3/s^2]

% Output arguments:
% DeltaV    maneuver impulse            [km/s]
% om_f      final pericenter anomaly    [rad]
% theta     true anomaly at maneuver    [rad]
%           (è già il theta in cui la manovra costa meno)

if nargin == 8
    mi = 398600;
end

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
