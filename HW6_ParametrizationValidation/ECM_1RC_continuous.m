function [dx, y] = ECM_1RC_continuous(~, x, u, R0, R1, C1, FileArgument)
% Complete here 1RC ECM.
% Inputs u = [I]
% States x = [Capacity; U1];
% Outputs y = [Ubat, Capacity];

Battery = FileArgument{1};
SOC_init = FileArgument{2};

% Battery parameters
Q = Battery.Q;

SOC = SOC_init - x(1) / Q;
U1 = x(2);
I = u(1);

%write discrete state equations
dQ_dt = I / 3600;
dU1_dt = -U1 / R1 / C1  + I / C1;

%compute actual OCV
Uocv = evaluate_Uocv(SOC, Battery);

%write output equation
Ubat = Uocv - I * R0 - U1;

%if necessary, format function outputs
y = [Ubat; x(1)];
dx = [dQ_dt; dU1_dt];
end