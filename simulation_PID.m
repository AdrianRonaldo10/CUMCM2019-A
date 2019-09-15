clear ; close all; clc

C = 0.85;
A = pi * 0.7^2;
volume = 500 * pi * 5^2;
omega = 10 * 4 * pi;

t_interval = 1e-5;
p = 105;
rho = density(p);
m = volume * rho;
rho_high = density(160);
t_total = 0.2;
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
flag_lower = false;
t_delay = 0.02;

kp=0.024;ki=0.107;kd=1.35e-3; %PID
error = 0;
lasterror = 0;
integ = 0;
domega = 0;
theta = pi;

for i = 1:length
    t = time(i);
    theta = theta + (omega - domega) * t_interval;
    if theta >= 2*pi
        theta = theta - 2*pi;
    end
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
    
    [open2, Q2] = Q2_open(t, t_delay);
    
    if ~flag_lower && p > 102
        t1 = t - t_delay + 0.005;
        t0 = t1 * 20 - floor(t1 * 20);
        t0 = t0 * 50;
        if t0 > 7.4
            flag_lower = true;
        end
    end
    if flag_lower && p < 100.5
        flag_lower = false;
    end
    
    if open1 || open2 || flag_lower
        Q3 = 0;
        if flag_lower
            Q3 = pi * 0.7^2 * sqrt(10^3 * p / rho);
        end
        m = m - rho * (Q2 + Q3 - Q) * t_interval * 10^3;
        rho = m / volume;
        p = pressure(rho);
    end
    
    error = p - 100;
    derivative = error - lasterror;
    integ = integ + error;
    lasterror = error;
    domega=kp*error+kd*derivative+ki*integ;
    if domega >= 20
        domega = 20;
    end
    if domega <= -20
        domega = -20;
    end
    
    fprintf('t=%f p=%f rho=%f p_high=%f rho_high=%f delta_omega=%f\n', t, p, rho, p_high, rho_high, domega);
    R(i) = rho;
    P(i) = p;
end
plot(time, P);

function [open, q] = Q2_open(t, t_delay)
    load('ValveModel.mat');
    t = t - t_delay;
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