function [ dt ] = TOF( a , e , thi , thf , mu ) 
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
if nargin == 4
    mu = 398600.433 ;
end 

n = sqrt ( mu / a ^ 3 ) ;

% Calculate period when given only a and e 
if nargin == 1 
    dt = 2 * pi / n ;
end

% Eccentric anomaly sine
sinEi = ( sqrt( 1 - e ^ 2 ) * sin ( thi ) ) / ( 1 + e * cos ( thi )) ;
sinEf = ( sqrt( 1 - e ^ 2 ) * sin ( thf ) ) / ( 1 + e * cos ( thf )) ;
half_tanEi = sqrt ( ( 1 - e ) / ( 1 + e ) ) * tan ( thi / 2 ) ;
half_tanEf = sqrt ( ( 1 - e ) / ( 1 + e ) ) * tan ( thf / 2 ) ;

% Eccentric anomaly
Ei = 2 * atan ( half_tanEi ) ;
Ef = 2 * atan ( half_tanEf ) ;

% Kepler equation
dM = Ef - Ei - e * ( sinEf - sinEi ) ;

if thf >= thi
    dt = dM / n ; 

    % condition to compensate for atan range -90 90
    
    if thf - thi > pi 
        dt = dt + floor ( ( ( thf - thi - pi ) / ( 2 * pi ) ) + 1 ) * 2 * pi / n ;
    end
else 
    dt = - dM / n   + 2 * pi / n ;

    % condition to compensate for atan range -90 90

    if thi - thf > pi 
        dt = dt  + floor ( ( ( thi - thf - pi ) / ( 2 * pi ) ) + 1 ) * 2 * pi / n ;
    end
end

end
