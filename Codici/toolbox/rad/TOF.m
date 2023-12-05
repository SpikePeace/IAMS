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
if nargin <= 3
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

% Eccentric anomaly 
Ei = 2 * atan ( sqrt ( ( 1 - e ^ 2 ) / ( 1 + e ^ 2) ) * tan ( thi / 2) ) ;
Ef = 2 * atan ( sqrt ( ( 1 - e ^ 2 ) / ( 1 + e ^ 2) ) * tan ( thf / 2) ) ;

% If eccentric anomaly is negative , add 2*pi

if Ef < Ei
    Ef = Ef + 2*pi;
end

% Kepler equation
dM = Ef - Ei - e * ( sin( Ef ) - sin ( Ei ) ) ;

if thf >= thi
    dt = dM / n ; 
else 
    dt = - dM / n   + 2 * pi / n ;
end

end
