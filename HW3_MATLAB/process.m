data = readtable('meas2.xlsx', Sheet='record');
U = data.Voltage_V__V_;
I = data.Current_A__A_;
Q = data.Capacity_Ah__Ah_;
E = data.Energy_Wh__Wh_;
P = data.Power_W__W_;
dQdV = data.dQ_dV_mAh_V_;
CycleID = data.CycleID;
StepID = data.StepID;
TimeHuman = duration(data.TotalTime, Inputformat="hh:mm:ss.SSS");
Time = seconds(TimeHuman);
StepTime = seconds(duration(data.StepTime));
StepType = data.StepType;

%% Processing
% Identify cycles

locs = find(diff(Q) < -1); % Detect clears of Q
%[~, locs] = findpeaks(Q, MinPeakProminence = 1);

num_cycles = length(locs) / 2;

cycles = zeros(num_cycles, 3);
cycles(1, :) = [1 locs(1) locs(2)];
for i = 2:num_cycles
    cycles(i, :) = [locs(2*i-2)+1 locs(2*i-1) locs(2*i)];
end
mask_chg = @(i) cycles(i, 1):cycles(i, 2);
mask_dchg = @(i) cycles(i, 2)+1:cycles(i, 3);
mask = @(i) [mask_chg(i) mask_dchg(i)];

% 1a
Q_discharging = zeros(1, num_cycles);
Q_charging = zeros(1, num_cycles);
for i=1:num_cycles
    Q_discharging(i) = max(Q(mask_dchg(i)));
    Q_charging(i) = max(Q(mask_chg(i)));
    
end

% 1c
figure(1);
clf;
grid on;
xlabel('Discharged capacity [Ah]');
ylabel('Voltage [V]');
hold on;
for i = 1:num_cycles
    Q_dchg = Q(mask_dchg(i));
    Q_chg = Q(mask_chg(i));
    voltage = U(mask(i));
    plot([Q_chg - max(Q_chg);Q_dchg], voltage, LineWidth=2, DisplayName=sprintf("Cycle %d", i));
   end
legend(Location='best')
exportgraphics(gcf, 'figures/voltages.eps')
%% 1d
cycle_to_plot = 2;
m = mask(cycle_to_plot);
T = Time(m) - min(Time(m));
figure(2)
clf;
tiledlayout(3, 1);
nexttile;
plot(T, U(m), LineWidth=2);
ylim([2.5 4.25])
grid on;
ylabel('Voltage [V]');
nexttile;
plot(T, I(m), LineWidth=2);
grid on;
ylabel('Current [A]');
nexttile;
plot(T, data.T1___(m), LineWidth=2);

xlabel('Time [s]');
ylabel('Temperature [°C]');
grid on
exportgraphics(gcf, 'figures/tiledlayout.eps')

%%
eta = Q_discharging ./ Q_charging;
eta_vector = zeros(size(I));
for i =1:num_cycles
    eta_vector(mask_chg(i)) = eta(4);
    eta_vector(mask_dchg(i)) = 1;
end
% 1e
Q_nom = Q_charging(2) * 3600;
SOC1 = 0.19 + zeros(size(Time));
for i = 2:length(Time)
    SOC1(i) = SOC1(i-1) + I(i) * eta_vector(i) / Q_nom;
end
SOC2 = cumsum(I / Q_nom) + 0.19;
figure(15);
plot(Time, [SOC1, SOC2], LineWidth=2);
xlabel('Time [s]');
ylabel('SOC [%]');
grid on;
legend('For loop approach (including \eta)', 'cumsum (excluding \eta)', Location='best')
exportgraphics(gcf, 'figures/soc.eps')

figure(20);
histogram(eta(2:end),100);
grid on;
xlabel('Coulombic efficiency \eta');
ylabel('Number of occurences')
exportgraphics(gcf, 'figures/etas.eps')
%eta_vector = []; % TODO
%SOC2 = cumsum(I .* eta_vector) / Q_nom;



