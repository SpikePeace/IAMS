function [problem,guess] = LTOT
%LowThrustOrbitTransfer - Low Thrust Orbit Transfer Problem
%
% The problem was adapted from Example 6.3 from
% J. Betts, "Practical Methods for Optimal Control and Estimation Using Nonlinear Programming: Second Edition," Advances in Design and Control, Society for Industrial and Applied Mathematics, 2010.
%
% Syntax:  [problem,guess] = LowThrustOrbitTransfer
%
% Outputs:
%    problem - Structure with information on the optimal control problem
%    guess   - Guess for state, control and multipliers.
%
% Other m-files required: none
% MAT-files required: none
%
% Copyright (C) 2019 Yuanbo Nie, Omar Faqir, and Eric Kerrigan. All Rights Reserved.
% The contribution of Paola Falugi, Eric Kerrigan and Eugene van Wyk for the work on ICLOCS Version 1 (2010) is kindly acknowledged.
% This code is published under the MIT License.
% Department of Aeronautics and Department of Electrical and Electronic Engineering,
% Imperial College London London  England, UK 
% ICLOCS (Imperial College London Optimal Control) Version 2.5 
% 1 Aug 2019
% iclocs@imperial.ac.uk

%------------- BEGIN CODE --------------

% initial conditions
ri=[-7894.6436; -854.6173; 2641.2167];
vi=[-0.3252; -6.7530; -1.1450];

rx_i=ri(1);
ry_i=ri(2);
rz_i=ri(3);
vx_i=vi(1);
vy_i=vi(2);
vz_i=vi(3);

% terminal conditions
af=13490.0000;
ef=0.3593;
iF=0.7717;
OMf=0.8843;
omf=1.7230;
th_f=2.0450;

orbit_f = orbit(af,ef,iF,OMf,omf);
[rf, vf] = kep2cart(orbit_f, th_f);

rx_f=rf(1);
ry_f=rf(2);
rz_f=rf(3);
vx_f=vf(1);
vy_f=vf(2);
vz_f=vf(3);






%%

% Plant model name, used for Adigator
InternalDynamics=@LTOT_Dynamics_Internal;
SimDynamics=@LTOT_Dynamics_Sim;

% Analytic derivative files (optional)
problem.analyticDeriv.gradCost=[];
problem.analyticDeriv.hessianLagrangian=[];
problem.analyticDeriv.jacConst=[];

% Settings file
problem.settings=@settings_LTOT;

%Initial Time. t0<tf
problem.time.t0_min=0;
problem.time.t0_max=0;
guess.t0=0;

% Final time. Let tf_min=tf_max if tf is fixed.
problem.time.tf_min=50000;     
problem.time.tf_max=100000; 
guess.tf=90000;

% Parameters bounds. pl=< p <=pu
problem.parameters.pl=[];
problem.parameters.pu=[];
guess.parameters=[];

% Initial conditions for system.
problem.states.x0=[rx_i ry_i rz_i vx_i vy_i vz_i];

% Initial conditions for system. Bounds if x0 is free s.t. x0l=< x0 <=x0u
problem.states.x0l=[rx_i ry_i rz_i vx_i vy_i vz_i];
problem.states.x0u=[rx_i ry_i rz_i vx_i vy_i vz_i];

% State bounds. xl=< x <=xu
problem.states.xl=[-inf -inf -inf -inf -inf -inf];
problem.states.xu=[inf inf inf inf inf inf];

% State error bounds
problem.states.xErrorTol_local=[10 10 10 1 1 1];
problem.states.xErrorTol_integral=[10 10 10 1 1 1];

% State constraint error bounds
problem.states.xConstraintTol=[1 1 1 1 1 1];

% Terminal state bounds. xfl=< xf <=xfu
problem.states.xfl=[rx_f ry_f rz_f vx_f vy_f vz_f];
problem.states.xfu=[rx_f ry_f rz_f vx_f vy_f vz_f];

% Number of control actions N 
% Set problem.inputs.N=0 if N is equal to the number of integration steps.  
% Note that the number of integration steps defined in settings.m has to be divisible 
% by the  number of control actions N whenever it is not zero.
problem.inputs.N=0;       
      
% Input bounds
problem.inputs.ul=[-5 -5 -5];
problem.inputs.uu=[5 5 5];

problem.inputs.u0l=[0 0 0];
problem.inputs.u0u=[0 0 0];

% Input constraint error bounds
problem.inputs.uConstraintTol=[0.1 0.1 0.1];

% Choose the set-points if required
problem.setpoints.states=[];
problem.setpoints.inputs=[];

% Bounds for path constraint function gl =< g(x,u,p,t) =< gu
problem.constraints.ng_eq=0;
problem.constraints.gTol_eq=[];

problem.constraints.gl=[];
problem.constraints.gu=[];
problem.constraints.gTol_neq=[];

% Bounds for boundary constraints bl =< b(x0,xf,u0,uf,p,t0,tf) =< bu
problem.constraints.bl=[];
problem.constraints.bu=[];
problem.constraints.bTol=[];


% store the necessary problem parameters used in the functions
problem.data.mu = 398600.433;

% Obtain guess of states and input sequences with ode solve
guess.time = [0 50000];
guess.states(:,1)=[ri(1) rf(1)];
guess.states(:,2)=[ri(2) rf(2)];
guess.states(:,3)=[ri(3) rf(3)];
guess.states(:,4)=[vi(1) vf(1)];
guess.states(:,5)=[vi(2) vf(2)];
guess.states(:,6)=[vi(3) vf(3)];
guess.inputs(:,1)=[0 0];
guess.inputs(:,2)=[0 0];
guess.inputs(:,3)=[0 0];

% Get function handles and return to Main.m
problem.data.InternalDynamics=InternalDynamics;
problem.data.functionfg=@fg;
problem.data.plantmodel = func2str(InternalDynamics);
problem.functions={@L,@E,@f,@g,@avrc,@b};
problem.sim.functions=SimDynamics;
problem.sim.inputX=[];
problem.sim.inputU=1:length(problem.inputs.ul);
problem.functions_unscaled={@L_unscaled,@E_unscaled,@f_unscaled,@g_unscaled,@avrc,@b_unscaled};
problem.data.functions_unscaled=problem.functions_unscaled;
problem.data.ng_eq=problem.constraints.ng_eq;
problem.constraintErrorTol=[problem.constraints.gTol_eq,problem.constraints.gTol_neq,problem.constraints.gTol_eq,problem.constraints.gTol_neq,problem.states.xConstraintTol,problem.states.xConstraintTol,problem.inputs.uConstraintTol,problem.inputs.uConstraintTol];

%------------- END OF CODE --------------

function stageCost=L_unscaled(x,xr,u,ur,p,t,vdat)

% L_unscaled - Returns the stage cost.
% The function must be vectorized and
% xi, ui are column vectors taken as x(:,i) and u(:,i) (i denotes the i-th
% variable)
% 
% Syntax:  stageCost = L(x,xr,u,ur,p,t,data)
%
% Inputs:
%    x  - state vector
%    xr - state reference
%    u  - input
%    ur - input reference
%    p  - parameter
%    t  - time
%    data- structured variable containing the values of additional data used inside
%          the function
%
% Output:
%    stageCost - Scalar or vectorized stage cost
%
%  Remark: If the stagecost does not depend on variables it is necessary to multiply
%          the assigned value by t in order to have right vector dimesion when called for the optimization. 
%          Example: stageCost = 0*t;

%------------- BEGIN CODE --------------


stageCost = u(:,1).^2+u(:,2).^2+u(:,3).^2;

%------------- END OF CODE --------------


function boundaryCost=E_unscaled(x0,xf,u0,uf,p,t0,tf,data) 

% E_unscaled - Returns the boundary value cost
%
% Syntax:  boundaryCost=E_unscaled(x0,xf,u0,uf,p,t0,tf,data) 
%
% Inputs:
%    x0  - state at t=0
%    xf  - state at t=tf
%    u0  - input at t=0
%    uf  - input at t=tf
%    p   - parameter
%    tf  - final time
%    data- structured variable containing the values of additional data used inside
%          the function
%
% Output:
%    boundaryCost - Scalar boundary cost
%
%------------- BEGIN CODE --------------

boundaryCost=0;

%------------- END OF CODE --------------


function bc=b_unscaled(x0,xf,u0,uf,p,t0,tf,vdat,varargin)

% b_unscaled - Returns a column vector containing the evaluation of the boundary constraints: bl =< bf(x0,xf,u0,uf,p,t0,tf) =< bu
%
% Syntax:  bc=b_unscaled(x0,xf,u0,uf,p,t0,tf,vdat,varargin)
%
% Inputs:
%    x0  - state at t=0
%    xf  - state at t=tf
%    u0  - input at t=0
%    uf  - input at t=tf
%    p   - parameter
%    tf  - final time
%    data- structured variable containing the values of additional data used inside
%          the function
%
%          
% Output:
%    bc - column vector containing the evaluation of the boundary function 
%
%------------- BEGIN CODE --------------
varargin=varargin{1};
bc=[];
%------------- END OF CODE --------------
% When adpative time interval add constraint on time
%------------- BEGIN CODE --------------
if length(varargin)==2
    options=varargin{1};
    t_segment=varargin{2};
    if ((strcmp(options.discretization,'hpLGR')) || (strcmp(options.discretization,'globalLGR')))  && options.adaptseg==1 
        if size(t_segment,1)>size(t_segment,2)
            bc=[bc;diff(t_segment)];
        else
            bc=[bc,diff(t_segment)];
        end
    end
end

%------------- END OF CODE --------------

