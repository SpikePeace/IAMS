function [ dt ] = TOF( a , e , thi , thf , mu ) 
% TOF.m - Flight time to move between two positions on the same
% orbit
%
% PROTOTYPE:
% [ dt ] = TOF ( a , e , thi , thf )
%
% DESCRIPTION:
% Calculates flight time to move between two positions on the same orbit
% give the angles thi and thf in radiants.
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

n = sqrt ( mu / a ^ 3 ) ;

% Eccentric anomaly sine
sinEi = ( sqrt( 1 - e ^ 2 ) * sin ( thi ) ) / ( 1 + e * cos ( thi )) ;
sinEf = ( sqrt( 1 - e ^ 2 ) * sin ( thf ) ) / ( 1 + e * cos ( thf )) ;
tanEi = sqrt ( ( 1 - e ) / ( 1 + e ) ) * tan ( thi / 2 ) ;
tanEf = sqrt ( ( 1 - e ) / ( 1 + e ) ) * tan ( thf / 2 ) ;

% Eccentric anomaly
Ei = atan ( tanEi ) ;
Ef = atan ( tanEf ) ;

% Kepler equation
dM = Ef - Ei - e * ( sinEf - sinEi ) ;

if thf >= thi
    dt = dM / n ; 
else 
    dt = dM / n + 2 * pi / n ;
end

end
