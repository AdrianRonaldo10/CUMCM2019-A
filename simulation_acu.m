clear ; close all; clc

C = 0.85;
A = pi * 0.7^2;
volume = 500 * pi * 5^2;
omega = 70.6;

t_interval = 1e-5;
m = volume * 0.85;
rho = 0.85;
p = 100;
rho_high = density(160);
t_total = 0.35;
time = linspace(0, t_total, t_total / t_interval);
length = length(time);
R = zeros(length, 1);
P = zeros(length, 1);

load('RhoTheta_model.mat')
dMax = 7.239; % 0时极径
dMin = 2.413; % pi时极径
m_high = density(0.5) * vol(pi);
R_high = zeros(length, 1);
P_high = zeros(length, 1);
Q_all = zeros(length, 1);

flag = false;

for i = 1:length
    t = time(i);
    theta = pi + omega * t;
    theta = theta - 2 * pi * floor(theta / (2 * pi));
    if ~flag && theta > pi
        m_high = density(0.5) * vol(pi);
        flag = true;
    end
    if flag && theta < pi
        flag = false;
    end
    rho_high = m_high / vol(theta);
    if rho_high <= density(0)
        rho_high = 0;
        p_high = 0;
    else
        p_high = pressure(rho_high);
    end
    R_high(i) = rho_high;
    P_high(i) = p_high;
    if p_high <= p
        Q = 0;
        open1 = false;
    else 
        Q = C*A*sqrt(2*10^3*(p_high - p)/rho_high);
        open1 = true;
    end
    Q_all(i) = Q;
    m_high = m_high - rho_high * Q * t_interval * 10^3;
    
    [open2, Q2] = Q2_open(t);
    if open1 || open2
        m = m - rho * (Q2 - Q) * t_interval * 10^3;
        rho = m / volume;
        p = pressure(rho);
    end
    fprintf('t=%f p=%f rho=%f p_high=%f rho_high=%f\n', t, p, rho, p_high, rho_high);
    R(i) = rho;
    P(i) = p;
end
plot(time, P);

function [open, q] = Q2_open(t)
    load('ValveModel.mat');
    t0 = t * 20 - floor(t * 20);
    t0 = t0 * 50; % round to ms
    if t0 <= 2.4
        q = Valve(t0);
        open = true;
    else
        q = 0;
        open = false;
    end
end

function v = vol(theta)
%VOL compute volume from theta
    load('RhoTheta_model.mat');
    dMax = RhoTheta_model(0);
    v = pi * 2.5^2 * (dMax - RhoTheta_model(theta)) + 20;
end