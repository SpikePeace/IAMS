function dx = LTOT_Dynamics_Sim(x,u,p,t,vdat)
% Low Thrust Orbit Transfer Problem - Dynamics - simulation
%
% Syntax:  
%          [dx] = Dynamics(x,u,p,t,vdat)
% 
% Inputs:
%    x  - state vector
%    u  - input
%    p  - parameter
%    t  - time
%    vdat - structured variable containing the values of additional data used inside
%          the function%      
% Output:
%    dx - time derivative of x
%
% Copyright (C) 2019 Yuanbo Nie, Omar Faqir, and Eric Kerrigan. All Rights Reserved.
% The contribution of Paola Falugi, Eric Kerrigan and Eugene van Wyk for the work on ICLOCS Version 1 (2010) is kindly acknowledged.
% This code is published under the MIT License.
% Department of Aeronautics and Department of Electrical and Electronic Engineering,
% Imperial College London London  England, UK 
% ICLOCS (Imperial College London Optimal Control) Version 2.5 
% 1 Aug 2019
% iclocs@imperial.ac.uk
%
%------------- BEGIN CODE --------------

% obtain parameters
% obtain parameters

mu = vdat.mu; 

rx = x(:,1);
ry = x(:,2);
rz = x(:,3);
vx = x(:,4);
vy = x(:,5);
vz = x(:,6);

u_x = u(:,1);
u_y = u(:,2);
u_z = u(:,3);

r_norm = norm([rx ry rz]);

% equations of motion 
drx = vx;
dry = vy;
drz = vz;
dvx = - mu / r_norm ^ 3 * rx +u_x;
dvy = - mu / r_norm ^ 3 * ry +u_y;
dvz = - mu / r_norm ^ 3 * rz +u_z;

% Return variables
dx=[drx dry drz dvx dvy dvz];