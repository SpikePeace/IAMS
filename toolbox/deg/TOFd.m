function [ dt ] = TOFd( a , e , thi , thf , mu ) 
% TOF.m - Flight time to move between two positions on the same
% orbit
%
% PROTOTYPE:
% [ dt ] = TOF ( a , e , thi , thf )
%
% DESCRIPTION:
% Calculates flight time to move between two positions on the same orbit
% give the angles thi and thf in degrees.
% 
%
% INPUT:
% a [1x1] Semi-major axis [km]
% e [1x1] Eccentricity [-]
% thi [1x1] True initial anomaly [deg]
% thf [1x1] True final anomaly [deg]
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
sinEi = ( sqrt( 1 - e ^ 2 ) *  sind ( thi ) ) / ( 1 + e * cosd ( thi ) ) ;
sinEf = ( sqrt( 1 - e ^ 2 ) *  sind ( thf ) ) / ( 1 + e * cosd ( thf ) ) ;
half_tanEi = sqrt ( ( 1 - e ) / ( 1 + e ) ) * tand ( thi / 2 ) ;
half_tanEf = sqrt ( ( 1 - e ) / ( 1 + e ) ) * tand ( thf / 2 ) ;

% Eccentric anomaly
Ei = 2 * atan ( half_tanEi ) ;
Ef = 2 * atan ( half_tanEf ) ;


% Kepler equation
dM = Ef - Ei - e * ( sinEf - sinEi ) ;

if thf >= thi
    dt = dM / n ; 
    if thf - thi > 180 
        dt = dt + 2 * pi / n ;
    end
else 
    dt = dM / n + 2 * pi / n ;
end

end
