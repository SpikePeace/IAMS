function [dx, g_neq] = LTOT_Dynamics_Internal(x,u,p,t,vdat)
%Low Thrust Orbit Transfer Problem - Dynamics - Internal
%
% Syntax:  
%          [dx] = Dynamics(x,u,p,t,vdat)	(Dynamics Only)
%          [dx,g_eq] = Dynamics(x,u,p,t,vdat)   (Dynamics and Eqaulity Path Constraints)
%          [dx,g_neq] = Dynamics(x,u,p,t,vdat)   (Dynamics and Inqaulity Path Constraints)
%          [dx,g_eq,g_neq] = Dynamics(x,u,p,t,vdat)   (Dynamics, Equality and Ineqaulity Path Constraints)
% 
% Inputs:
%    x  - state vector
%    u  - input
%    p  - parameter
%    t  - time
%    vdat - structured variable containing the values of additional vdat used inside
%          the function%      
% Output:
%    dx - time derivative of x
%    g_eq - constraint function for equality constraints
%    g_neq - constraint function for inequality constraints
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
%------------- BEGIN CODE --------------a

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

r_norm = sqrt(rx.^2+ry.^2+rz.^2);

% equations of motion 
drx = vx;
dry = vy;
drz = vz;
dvx = - mu ./ r_norm .^ 3 .* rx + u_x;
dvy = - mu ./ r_norm .^ 3 .* ry + u_y;
dvz = - mu ./ r_norm .^ 3 .* rz + u_z;

% Return variables
dx=[drx dry drz dvx dvy dvz];

g_neq=[] ;