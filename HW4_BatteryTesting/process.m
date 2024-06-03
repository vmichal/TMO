%% TODO videa na emailu
%% Discharge - video do 1:30
T1 = [0 10 10.1 12 15 20 25 30 30.1 32 35 40 45 50 60 70 80 90]';
U1 = [33067; 33067; 30836; 30769; 30656; 30570; 30519; 30491; 32661; 32705; 32783; 32849; 32898; 32931; 32976; 33007; 33028; 33042] / 1e4;
T2 = [3.25; 4; 4.5;5;5.5]*60;
U2 = [3.3104; 3.3115; 3.3123; 3.3126; 3.3132]; % V;
T = [T1; T2];
U = [U1; U2];
I = zeros(size(T));
I(T > 10 & T <= 30) = -2;

[R0, R1, C1] = rough_estimate(T, U, I, 10, 30, max(T));
[R0 R1 C1]
figure(3);
plot_stuff(T, U, I, [0 inf]);
exportgraphics(gcf, "figures/discharge.eps")

%% Charge - video do 1:30
T1 = [0 10 10.1 12 15 20 25 30 30.1 32 35 40 45 50 60 70 80 90]';
U1 = [3361 3361 3502 3515 3540 3563 3572 3576 3440 3426 3412 3401 3395 3390 3385 3381 3378 3376]';
T2 = (1.5:0.5:5.5)'*60; % seconds
U2 = 3300 + [76;72;69;67;66;64;63;63;62]; % mV

T = [T1; T2];
U = [U1; U2] / 1e3;
I = zeros(size(T));
I(T > 10 & T <= 30) = 1;

[R0, R1, C1] = rough_estimate(T, U, I, 10, 30, max(T));
[R0 R1 C1]

figure(4);
plot_stuff(T, U, I, [0 inf]);
exportgraphics(gcf, "figures/charge.eps")

%% Process automated data
data = readtable('data.xlsx', Sheet='record');
%%
U = data.Voltage_V_;
I = data.Current_A_;
T = (0:length(U)-1) / 10;
figure(1)
plot_stuff(T, U, I, [0 inf])
exportgraphics(gcf, "figures/automated.eps")
[R0, R1, C1] = rough_estimate(T, U, I, 30, 50.1, 350.2);
[R0 R1 C1]

[R0, R1, C1] = rough_estimate(T, U, I, 350.2, 370.3, 670.4);
[R0 R1 C1]

%figure(2)
%plot_stuff(T, U, I, [29 51])
%exportgraphics(gcf, "figures/automated_discharge.eps")


% Rough estimate of R0, R1, C1

function [R0, R1, C1] = rough_estimate(T, U, I, start, stop, end_of_rest)
    start = find(T == start);
    stop = find(T == stop);
    end_of_rest = find(T == end_of_rest);
    delta_I = (I(start) - I(start+1));
    R0 = (U(start) - U(start+1)) / delta_I;
    R1 = (U(stop+1) -  U(end_of_rest)) / I(stop);
    tau = (T(end_of_rest) - T(stop+1)) / 5;
    C1 = tau / R1;
end

function plot_stuff(T, U, I, from_to)
tiledlayout(2,1);
nexttile
plot(T, U, LineWidth=2);
ylabel('Voltage [V]');
grid on;
xlim(from_to)
nexttile;
plot(T, I, LineWidth=2);
grid on;
ylabel('Current [A]')
xlim(from_to)
ylim([-2.1 1.1])
xlabel('Time [s]')
end
