clear ; close all; clc

C = 0.85;
A = pi*0.7^2;

load('RhoTheta_model.mat')
dMax = 7.239; % 0时极径
dMin = 2.413; % pi时极径
Theta = pi:pi/10000:3*pi; % 从最低开始周期
m = density(0.5) * vol(pi);
length = length(Theta);
R = zeros(length, 1);
P = zeros(length, 1);
Q_all = zeros(length, 1);
omega = 35.3;
t_interval = pi / (10000 * omega);
sum = 0;
for i = 1:length
    theta = Theta(i);
    t = theta;
    if t > 2 * pi
        t = t - 2 * pi;
    end
    rho = m / vol(t);
    if rho <= density(0)
        R(i) = 0;
        P(i) = 0;
        continue
    end
    R(i) = rho;
    p = pressure(rho);
    P(i) = p;
    fprintf('t=%f p=%f rho=%f\n', t, p, rho);
    if p <= 100
        Q_all(i) = 0;
        continue
    end
    Q = C*A*sqrt(2*10^3*(p - 100)/rho);
    Q_all(i) = Q;
    sum = sum + Q * t_interval;
    m = m - rho * Q * t_interval * 10^3;
end
sum = sum / (t_interval * length);
fprintf('Q_average: %f\n', sum);
figure(1);
plot(Theta, R);
figure(2);
plot(Theta, P);
figure(3);
plot(Theta, Q_all);
save('Q', 'Q_all');

function v = vol(theta)
%VOL compute volume from theta
    load('RhoTheta_model.mat');
    dMax = RhoTheta_model(0);
    v = pi * 2.5^2 * (dMax - RhoTheta_model(theta)) + 20;
end
