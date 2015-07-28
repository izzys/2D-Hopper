function [ Sim ] = Init( Sim )
% Initialize simulation properties
    

    
    Sim.tspan=Sim.tstart:Sim.tstep:Sim.tend;
    
    % Set states
    Sim.stDim = Sim.Mod.stDim + Sim.Con.stDim; % state dimension
    Sim.ModCo = 1:Sim.Mod.stDim;% Model coord. indices
    Sim.ConCo = (Sim.Mod.stDim+1):Sim.stDim; % Contr. coord. indices

    % Set events
    Sim.nEvents = Sim.Mod.nEvents + Sim.Con.nEvents;
    Sim.ModEv = 1:Sim.Mod.nEvents; % Model events indices
    Sim.ConEv = Sim.Mod.nEvents+1:Sim.nEvents; % Contr. events indices
    
    Sim.StopSim = 0;
    Sim.PauseSim = 0;
        
    % Set render params
    if Sim.Graphics == 1
        
        % Init window size params
        scrsz = get(0, 'ScreenSize');
  
        Sim.FigWidth = scrsz(3)-250;
        Sim.FigHeight = scrsz(4)-250;
        Sim.AR = Sim.FigWidth/Sim.FigHeight;
        
        % Init world size params
        Sim.FlMin = -0.5*Sim.AR;
        Sim.FlMax = 0.5*Sim.AR;
        Sim.HeightMin = -1/Sim.AR;
        Sim.HeightMax = 4/Sim.AR;

        Sim.Once=1;
    end
    
    % Check hopper status:
    if  Sim.Mod.GetPos(Sim.IC,'m2') > 1e-8      
      Sim.Mod.OnGround=0;   
      Sim.Con.LiftOffOccured = 1;
    elseif Sim.Mod.GetPos(Sim.IC,'m2') <  1e-8   

        NormalForce = Sim.Mod.GetGRF(Sim.IC);
        
        if NormalForce>0
         Sim.Mod.OnGround=0;
         
        else       
         Sim.Mod.OnGround=1;               
        end

        Sim.Con.LiftOffOccured = 0;
    else
        Sim.StopSim = 1;
        Sim.Out.Type = Sim.EndFlag_ICpenetrateGround;
        Sim.Out.Text = 'Initial pose penetrates ground';
        return        
    end
    
    
    % Init Stats:
    Sim.StepsTaken = 0;
    Sim.nICsStored = Sim.stepsReq;
    Sim.ICstore = zeros(Sim.stDim, Sim.nICsStored);
    Sim.stepsSS = zeros(1,Sim.nICsStored-1);
    Sim.EventsCounter = 0;
    Sim.Tarray = [0];
    
    % wait bar:
    Sim.WaitbarFlag = 0;
    if ~Sim.Graphics
        if Sim.EndCond(1)~=1 
            Sim.WaitbarFlag = 1;
        elseif Sim.EndCond(2)>5
           Sim.WaitbarFlag = 1;       
        end
    end
    
    % Init Sim.End result
    Sim.Out.Type = Sim.EndFlag_EndOfTime;
    Sim.Out.Text = 'Reached end of tspan';
    Sim.Out.T = [];
    Sim.Out.EventsVec = {};



end

