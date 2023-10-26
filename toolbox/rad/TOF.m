function [ dt ] = TOF( orbit, thi , thf , mu ) 
% TOF.m - Flight time to move between two positions on the same
% orbit
%
% PROTOTYPE:
% [ dt ] = TOF ( a , e , thi , thf )
%
% DESCRIPTION:
% Calculates flight time to move between two positions on the same orbit
% give the angles thi and thf in radiants. Only first 2 inputs needed to get revolution
% period.
% 
%
% INPUT:
% a [1x1] Semi-major axis [km]
% e [1x1] Eccentricity [-]
% thi [1x1] True initial anomaly [rad]
% thf [1x1] True final anomaly [rad]
%
% OUTPUT:
%
% dt [1x1] Flight time [s]
%
%
if nargin == 3
    mu = 398600.433 ;
end 

a=orbit.a;
e=orbit.e;

n = sqrt ( mu / a ^ 3 ) ;

% Calculate period when given only a and e 
if nargin == 1 
    dt = 2 * pi / n ;
    return
end

% Eccentric anomaly sine
sinEi = ( sqrt( 1 - e ^ 2 ) * sin ( thi ) ) / ( 1 + e * cos ( thi )) ;
sinEf = ( sqrt( 1 - e ^ 2 ) * sin ( thf ) ) / ( 1 + e * cos ( thf )) ;
cosEi = ( e + cos(thi)) / (1 + e * cos(thi));
cosEf = ( e + cos(thf)) / (1 + e * cos(thf));

% Eccentric anomaly
Ei = atan2 ( sinEi, cosEi) ;
Ef = atan2 ( sinEf, cosEf) ;

% Kepler equation
dM = Ef - Ei - e * ( sinEf - sinEi ) ;

if thf >= thi
    dt = dM / n ; 

    % condition to compensate for atan range -90 90
    
    if thf > pi 
        dt = dt + floor ( ( ( thf - pi ) / ( 2 * pi ) ) + 1 ) * 2 * pi / n ;
    end
else 
    dt = - dM / n   + 2 * pi / n ;

    % condition to compensate for atan range -90 90

    if thi > pi 
        dt = dt  + floor ( ( ( thi - pi ) / ( 2 * pi ) ) + 1 ) * 2 * pi / n ;
    end
end

end
