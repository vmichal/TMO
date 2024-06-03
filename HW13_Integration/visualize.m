list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end
set(0, 'DefaultAxesFontSize', 16);
set(0, 'DefaultTextFontSize', 16);
%% Tune stuff
Kp = 1;
Ki = 2;
Kd = 2;
N = 0.05;
LP = c2d(tf([N], [1 N]), 0.1);

%%

Time = out.tout;

% Subsystem currents
I1 = out.subsystemCurrents(:, 2);
I2 = out.subsystemCurrents(:, 3);
Isubsys_lim = out.subsystemCurrents(:, 4);


Isys = out.systemCurrents(:, 2);
Ireq = out.systemCurrents(:, 3);
Isys_lim = out.systemCurrents(:, 4);

R1 = out.Resistances(:, 2);
R2 = out.Resistances(:, 3);

SoC1 = out.SoCs(:, 2);
SoC2 = out.SoCs(:, 3);

U1 = out.Voltages(:, 2);
U2 = out.Voltages(:, 3);

IE = I2 - I1;

fig_subsystem = figure(1);
clf
hold on
plot(Time, [I1, I2, Isubsys_lim, -Isubsys_lim], linewidth=2)
legend('$I_1$', '$I_2$', 'upper bound', 'lower bound', location='best', numcolumns=2);
xlabel('Time [s]');
ylabel('Current [A]');
grid on


a1 = gca;
fig_subsystem_detail = figure(10);
clf
a2 = copyobj(a1, fig_subsystem_detail);
ylim([48 60])
legend('$I_1$', '$I_2$', 'upper bound', 'lower bound', location='best', numcolumns=2);

a1 = gca;
fig_subsystem_detail2 = figure(11);
clf
a2 = copyobj(a1, fig_subsystem_detail2);
ylim([48 60])
xlim([358 373])
legend('$I_1$', '$I_2$', 'upper bound', 'lower bound', location='best', numcolumns=2);


fig_system = figure(2);
clf
hold on
plot(Time, [Ireq, Isys, Isys_lim, -Isys_lim], linewidth=2)
legend('requested current', 'actual current', 'upper bound', 'lower bound', location='best', numcolumns=2);
xlabel('Time [s]');
ylabel('Current [A]');
grid on

a1 = gca;
fig_system_detail = figure(12);
clf
a2 = copyobj(a1, fig_system_detail);
xlim([355 375])
ylim([0 150])
legend('requested current', 'actual current', 'upper bound', 'lower bound', location='best', numcolumns=2);


fig_R = figure(3);
clf
hold on
plot(Time, [R1 R2], linewidth=2)
legend('$R_{0,1}$', '$R_{0,2}$', location='best', numcolumns=2);
xlabel('Time [s]');
ylabel('Resistance [$\Omega$]');
grid on

fig_SoC = figure(4);
clf
hold on
plot(Time, [SoC1 SoC2], linewidth=2)
legend('$SoC_1$', '$SoC_2$', location='best', numcolumns=2);
xlabel('Time [s]');
ylabel('SoC [\%]');
grid on


fig_U = figure(5);
clf
hold on
plot(Time, [U1 U2], linewidth=2)
legend('$U_1$', '$U_2$', location='best', numcolumns=2);
xlabel('Time [s]');
ylabel('Voltage [V]');
grid on

fig_IE = figure(6);
clf
hold on
plot(Time, [IE], linewidth=2)
legend('Equalizing current', location='best', numcolumns=2);
xlabel('Time [s]');
ylabel('Current [A]');
grid on



%% Analyze and debug
sample = 406;
U = out.Voltages(sample, [2 3])
I = out.subsystemCurrents(sample, [2 3])
R = out.Resistances(sample, [2 3])
[systemLimit, I_E] = getSystemCurrentLimit(50, I, U, R)

%% Save figures
name = 'fb';
exportgraphics(fig_subsystem, sprintf("figures/%s-subsystem.pdf", name));
exportgraphics(fig_subsystem_detail, sprintf("figures/%s-subsystem-detail.pdf", name));
exportgraphics(fig_subsystem_detail2, sprintf("figures/%s-subsystem-detail2.pdf", name));
exportgraphics(fig_system, sprintf("figures/%s-system.pdf", name));
exportgraphics(fig_system_detail, sprintf("figures/%s-system-detail.pdf", name));
exportgraphics(fig_U, sprintf("figures/%s-U.pdf", name));
exportgraphics(fig_R, sprintf("figures/%s-R.pdf", name));
exportgraphics(fig_SoC, sprintf("figures/%s-SoC.pdf", name));
exportgraphics(fig_IE, sprintf("figures/%s-IE.pdf", name));
