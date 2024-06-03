function [systemLimit, I_E] = getSystemCurrentLimit(I_L, I, U, R)

U1 = U(1);
U2 = U(2);

I1 = I(1);
I2 = I(2);

R1 = R(1);
R2 = R(2);


U1_bar = U1 - R1*I1;
U2_bar = U2 - R2*I2;

I_E = (U1_bar - U2_bar) / (R1 + R2);

% According to subsystem 2:
lower_bound2 = (R1+R2)/R1 * (-I_L - I_E);
upper_bound2 = (R1+R2)/R1 * (I_L - I_E);

% According to subsystem 1:
lower_bound1 = (R1+R2)/R2 * (-I_L + I_E);
upper_bound1 = (R1+R2)/R2 * (I_L + I_E);

systemLimit = min([upper_bound1, upper_bound2, -lower_bound1, -lower_bound2]);
