temps = [22 46 61]; % Temperature of balancer [°C]
I = [0.02:0.02:0.08 0.1:0.1:1]'; % Currents used for measurement [A]

% All voltages in Volts, samples A and B linear, C unmeasurable
% First measurement at 22 °C 
U1A = 3 + 1/1000 * [803 807 809 811 814 822 830 837 844 851 858 865 872 878]';
U1B = 3 + 1/1000 * [943 944 945 946 947 951 955 959 963 967 971 974 978 982]';

% Heating starts. Intermediate values:
% Sample A, I = 0.1 A, T = 30 °C, U = 3.801 V (-13 mV compared to 22°C)
% Sample A, I = 0.1 A, T = 40 °C, U = 3.780 V (-34 mV compared to 22°C)
% Sample B, I = 0.1 A, T = 40 °C, U = 3.944 V (-3 mV compared to 22°C)
% With growing temperature, voltages decrease (not great, but safer)
% Measurement 2 at 45 °C to 47 °C
U2A = 3 + 1/1000 * [757 760 762 764 766 774 781 789 796 803 810 817 824 831]';
U2A_down = 3 + 1/1000 * [741 745 748 751 753 762 771 779 791 798 807 815 822 829]';
% Sample B pretty much no hysteresis and pretty much no temperature dependence
U2B = 3 + 1/1000 * [939 940 940 941 942 946 950 954 958 962 966 970 974 978]';
U2B_down = 3 + 1/1000 * [939 940 940 941 942 946 950 954 958 962 966 970 974 978]';

% Measurement 3 at 61 °C
U3A = 3 + 1/1000 * [700 704 706 708 710 719 728 736 744 751 759 766 774 781]';
U3A_down = 3 + 1/1000 * [694 698 701 704 706 715 724 733 741 749 757 765 773 781]';
U3B = 3 + 1/1000 * [936 937 938 938 939 943 947 951 955 959 963 967 971 975]';

%% Find where the char crosses 0
mask = I >= 0.1;
[ut_1A, R_1A] = get_fit(I, U1A, mask)
[ut_2A, R_2A] = get_fit(I, U2A, mask)
[ut_3A, R_3A] = get_fit(I, U3A, mask)

[ut_1B, R_1B] = get_fit(I, U1B, mask)
[ut_2B, R_2B] = get_fit(I, U2B, mask)
[ut_3B, R_3B] = get_fit(I, U3B, mask)

%% Fit temp coeff
polyfit(temps, [ut_1A, ut_2A, ut_3A],1)
polyfit(temps, [ut_1B, ut_2B, ut_3B],1)

%% Plotting
figure(1);
clf;
hold on;
plot(U1A, I, 'r', LineWidth=2);
plot(U2A, I, 'g', LineWidth=2);
plot(U3A, I, 'b', LineWidth=2);
plot(U1A, eval_fit(U1A, ut_1A, R_1A), 'r--', LineWidth=2);
plot(U2A, eval_fit(U2A, ut_2A, R_2A), 'g--', LineWidth=2);
plot(U3A, eval_fit(U3A, ut_3A, R_3A), 'b--', LineWidth=2);

grid on;
legend('22 °C', '45 °C', '61 °C', Location='best');
xlabel('Voltage [V]');
ylabel('Current [A]');
ylim([-0.1 1])
%title('U-I characteristic of sample A');

figure(2);
clf;
hold on;
plot(U1B, I, 'r', LineWidth=2);
plot(U2B, I, 'g', LineWidth=2);
plot(U3B, I, 'b', LineWidth=2);
plot(U1B, eval_fit(U1B, ut_1B, R_1B), 'r--', LineWidth=2);
plot(U2B, eval_fit(U2B, ut_2B, R_2B), 'g--', LineWidth=2);
plot(U3B, eval_fit(U3B, ut_3B, R_3B), 'b--', LineWidth=2);

grid on;
legend('22 °C', '45 °C', '61 °C', Location='best');
xlabel('Voltage [V]');
ylabel('Current [A]');
ylim([-0.1 1])
%title('U-I characteristic of sample B');
return;
%% Some plotting
plot(U2A, I, U2A_down, I);
grid on;
legend('up', 'down')
xlabel('Voltage [V]');
ylabel('Current [A]');

plot(U2B, I, U2B_down, I);
grid on;
legend('up', 'down')
xlabel('Voltage [V]');
ylabel('Current [A]');

plot(U1B, I, U2B, I);
grid on;
legend('22°C', '45°C')
xlabel('Voltage [V]');
ylabel('Current [A]');

plot(U3A, I, U3A_down, I);
grid on;
legend('up', 'down')
xlabel('Voltage [V]');
ylabel('Current [A]');

function [u_t, R] = get_fit(I, U, mask)
    fit = polyfit(U(mask), I(mask), 1);
    u_t = -fit(2) / fit(1);
    R = 1/fit(1);
end

function values = eval_fit(U, u_t, R)
    values = (U - u_t) / R;
end