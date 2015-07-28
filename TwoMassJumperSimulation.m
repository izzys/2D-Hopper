%clc;clear classes;close all;clear all

Sim = Simulation();
      
% ------------- Parameter definitions ---------- %

% Set EndCond to run the sim until:
Sim.EndCond = 2 ; % 0 - the end of time , [1 , #num ] - number of steps, 2 - system converges to LC

% Set simulation time:
Sim = Sim.SetTime(0,0.005,125);

% Set graphics parameters:
Sim = Sim.Set('Graphics',1,'WindowLeftLocation',0.1);

% set initial conditions:
Sim.IC = [0.05 , 0.82  , 0 , 0.1177  , 0 ]';

% ----------------- Simulation ----------------- %

Sim.Init();
Sim.Run();

%------------------ Post processing ------------ %
if Sim.Out.Type == Sim.EndFlag_Converged || Sim.Out.Type == Sim.EndFlag_TimeEndedBeforeConverge
[EigVal,EigVec] = Sim.Poincare();
EigVal
end

