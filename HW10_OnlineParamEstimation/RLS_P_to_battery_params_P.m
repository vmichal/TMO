function P_params = RLS_P_to_battery_params_P(P_theta, theta, Ts)
offset = theta(1);
a1 = theta(2);
b0 = theta(3);
b1 = theta(4);

% Jacobian of mapping RLS theta -> battery params
% Rewrite stuff such as jacobian(sol.R0, [offset a1 b0 b1])
dOCV_dtheta = [1/(a1 + 1), -offset/(a1 + 1)^2, 0, 0];
dR0_dtheta = [0, -(b0 - b1)/(a1 - 1)^2, 1/(a1 - 1), -1/(a1 - 1)];
dR1_dtheta = [0, - (2*b0)/(a1^2 - 1) - (4*a1*(b1 - a1*b0))/(a1^2 - 1)^2, -(2*a1)/(a1^2 - 1), 2/(a1^2 - 1)];
dC1_dtheta = [0, (2*Ts - 2*Ts*a1)/(4*(b1 - a1*b0)) - (b0*(Ts*a1^2 - 2*Ts*a1 + Ts))/(4*(b1 - a1*b0)^2), -(a1*(Ts*a1^2 - 2*Ts*a1 + Ts))/(4*(b1 - a1*b0)^2), (Ts*a1^2 - 2*Ts*a1 + Ts)/(4*(b1 - a1*b0)^2)];

J = [dOCV_dtheta; dR0_dtheta; dR1_dtheta; dC1_dtheta];

% Propagation of uncertainty
P_params = J * P_theta * J';
end