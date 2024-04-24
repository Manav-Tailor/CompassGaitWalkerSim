% gamma 0.03 results in negative solution
% gamma 0.3 results in positive solution

clear

global walkerDim
walkerDim.M = 1.0;          
walkerDim.m = 0.5;
walkerDim.I = 0.02;
walkerDim.l = 1.0;
walkerDim.c = 0.5;
walkerDim.g = 1.0;
walkerDim.gamma = 0.000;
walkerDim.movieFPS = 60;

NumOfStates = 4;
NumOfOutputs = 5;
NumOfInputs = 2;

nlobj = nlmpc(NumOfStates, NumOfOutputs, NumOfInputs);
nlobj.Model.StateFcn = @(x, u) myStateFcn(x, u);
nlobj.Model.OutputFcn = @(x, u) [x; myTerminalCostFcn(x)];
nlobj.PredictionHorizon = 30;
nlobj.ControlHorizon = 3;

% nlobj.States(2).Min = 0.1;
% nlobj.States(4).Min = 0.1;

nlobj.Weights.ManipulatedVariables = [0 0]; % weights for control inputs
nlobj.Weights.OutputVariables = [100 0 100 0 1000]; % weights for system outputs

% Set Initial State
% theta_1 = 0.19;
% theta_2 = -2*theta_1;
theta_1 = 0.19;
theta_2 = -2*theta_1;
% omega_1 = -0.25;
% omega_2 = 0.1;
omega_1 = -0.25;
omega_2 = 0.2;

q0 = [theta_1, omega_1, theta_2, omega_2];
u0 = [0,0];

validateFcns(nlobj, q0, u0, []);

% Initialize state and input
x = q0;
u = u0;

% Number of control steps
N = 100;

options = odeset('AbsTol',1e-8, 'RelTol',1e-8, 'Events', @contact);

% Preallocate arrays for storing states and inputs
Ts = 0.1;
X = zeros(N+1, NumOfStates);
U = zeros(N, NumOfInputs);

X(1,:) = x;

% Control loop
for k = 1:N
    yref = [-0.001995392	-0.268866419	-0.015379581	0.864482626	-0.1
            -0.006289726	-0.270610461	-0.00160118	0.866288161	-0.09
            -0.010613117	-0.272516474	0.012203191	0.867745239	-0.08
            -0.014968144	-0.27458474	0.026027995	0.868855108	-0.07
            -0.019321184	-0.276796352	0.039753967	0.869614787	-0.06
            -0.023710407	-0.279167527	0.053489268	0.870037286	-0.05
            -0.028138329	-0.281697963	0.067228596	0.870125711	-0.04
            -0.032607462	-0.284387173	0.080966708	0.869883791	-0.03
            -0.037127867	-0.287239365	0.0947213	0.86931465	-0.02
            -0.041694633	-0.290249339	0.108464334	0.868423389	-0.01
            -0.046310249	-0.293416083	0.122190759	0.86721557	0
            -0.050977184	-0.296738428	0.135895618	0.865697338	0.01
            -0.055751807	-0.300255408	0.149729193	0.863852998	0.02
            -0.060583941	-0.303928681	0.163530828	0.86170553	0.03
            -0.065476073	-0.307756611	0.17729574	0.859262987	0.04
            -0.070430662	-0.311737446	0.191019277	0.856533946	0.05
            -0.075556285	-0.31595772	0.204983697	0.853461437	0.06
            -0.080752106	-0.320333374	0.218895643	0.850109926	0.07
            -0.086020646	-0.324862255	0.232750643	0.84649008	0.08
            -0.091364388	-0.329542148	0.246544408	0.842613022	0.09
            -0.096953403	-0.334521288	0.260693042	0.838360047	0.1
            -0.102627545	-0.339655916	0.274767977	0.833859231	0.11
            -0.108389412	-0.344943497	0.288765156	0.829124097	0.1
            -0.114241557	-0.350381495	0.302680752	0.824168553	0.09
            -0.120427986	-0.356195499	0.317066557	0.818794801	0.08
            -0.126717609	-0.362166745	0.331356424	0.813214418	0.07
            -0.133113154	-0.368292486	0.345546881	0.807444189	0.06
            -0.139617304	-0.374570048	0.359634755	0.801501211	0.05
            -0.14656147	-0.381317213	0.374303133	0.795098786	0.04
            -0.153631096	-0.388225796	0.388852454	0.78854572	0.03
            -0.160829124	-0.395293063	0.403280141	0.781862677	0.02
            -0.168158445	-0.402516433	0.417583998	0.775070573	0.01
            -0.176043932	-0.410311143	0.432552544	0.767803065	0
            -0.184082303	-0.418274583	0.447379328	0.760462678	0
            -0.192276807	-0.42640433	0.46206318	0.753074794	0
            -0.200630651	-0.434698187	0.47660343	0.745665007	0
            -0.209411753	-0.443417022	0.491440763	0.738031499	0
            -0.218368943	-0.452306237	0.506125699	0.730430603	0
            -0.227505611	-0.461364189	0.520659176	0.722891	0
            -0.236825119	-0.470589491	0.535042712	0.715441581	0
            -0.245882878	-0.479538912	0.548617119	0.708450553	0
            -0.255112708	-0.488638595	0.562059464	0.701593339	0
            -0.264517467	-0.497887933	0.575372541	0.69489554	0
            -0.274100007	-0.507286494	0.588559637	0.688382959	0
            -0.283456801	-0.516437206	0.60108793	0.682337045	0
            -0.292982125	-0.525724735	0.613507652	0.676508423	0
            -0.302678477	-0.535149089	0.625822989	0.670920437	0
            -0.312548361	-0.544710379	0.638038554	0.665596656	0
            -0.316537744	-0.548565825	0.642888621	0.663550346	0
            -0.320555345	-0.552443145	0.647723927	0.661551464	0
            -0.324601322	-0.55634236	0.652544823	0.659601543	0
            -0.328675835	-0.560263488	0.657351671	0.657702123	0
            ];

    [u,nlmpcInfo] = nlmpcmove(nlobj, x, u, yref);
    U(k,:) = u;
    myStateFcn_u = @(t, x) myStateFcn(x, u);
    [~,x] = ode45(myStateFcn_u,[0, Ts], x, options); % Assuming a fixed time step of 0.1 for integration
    x = x(end,:); % Update the state x with the last value of q
    X(k+1,:) = x;

    gstop = x(end,3) + 2*x(end,1)
    if(gstop < 0.05 && gstop > -0.05 && x(1) < -0.1)
        disp("FOOTSTRIKE!!!!!")
        x = foot_strike(x, walkerDim);
    end
    disp(k)
end

xh = -1*walkerDim.l*sin(X(:,1));
yh = walkerDim.l*cos(X(:,1));
X = [X, xh, yh];

t = 1:N+1;
t = t*Ts;
%%
figure;
animation(t, X, walkerDim)

function xdot = myStateFcn(x, u)
    global walkerDim
    M = walkerDim.M;          
    m = walkerDim.m; 
    I = walkerDim.I; 
    l = walkerDim.l; 
    c = walkerDim.c; 
    g = walkerDim.g; 
    gamma = walkerDim.gamma; 

    A = [2*I + M*l^2 + 2*c^2*m + 2*l^2*m - 2*c*l*m - 2*c*l*m*cos(x(3)), m*c^2 - l*m*cos(x(3))*c + I;
        m*c^2 - l*m*cos(x(3))*c + I, m*c^2 + I];

    b = [- c*l*m*sin(x(3))*x(4)^2 - 2*c*l*m*x(2)*sin(x(3))*x(4) - c*g*m*sin(x(1) - gamma + x(3)) - M*g*l*sin(gamma - x(1)) + c*g*m*sin(gamma - x(1)) - 2*g*l*m*sin(gamma - x(1));
        -c*m*(g*sin(x(1) - gamma + x(3)) - l*x(2)^2*sin(x(3)))];

    B = [1,0;
        0,1];

    alpha = A \ (b + B*u);

    xdot = [x(2); double(alpha(1)); x(4); double(alpha(2))];
end

function cost = myTerminalCostFcn(x)
    cost = x(3) + 2*x(1);
end