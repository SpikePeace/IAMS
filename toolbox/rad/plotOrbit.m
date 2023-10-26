function [X Y Z] = plotOrbit(orbit, th_i, deltaTh, stepTh)
% plotOrbit.m - Plot the arc length deltaTh of the orbit described by
% kepEl.
%
% PROTOTYPE:
% plotOrbit(orbit , th_i, deltaTh, stepTh, mu)
%
% DESCRIPTION:
% Plot the arc length of the orbit described by a set of orbital
% elements for a specific arc length.
%
% INPUT:
% kepEl [1x6] orbital elements [km,rad]
% mu [1x1] gravitational parameter [km^3/s^2]
% deltaTh [1x1] arc length [rad]
% stepTh [1x1] arc length step [rad]
%
% OUTPUT:
% X [1xn] X position [km]
% Y [1xn] Y position [km]
% Z [1xn] Z position [km]

if nargin == 4
    mu = 398600.433;
end

Th=th_i:stepTh:th_i+deltaTh;
for i=1:length(Th)
    r=kep2cart(orbit,Th(i));
    X(i)=r(1);
    Y(i)=r(2);
    Z(i)=r(3);
end
plot3(X,Y,Z)
end
    





