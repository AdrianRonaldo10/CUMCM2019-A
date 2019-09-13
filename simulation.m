clear ; close all; clc

C = 0.85;
A = pi * 0.7^2;
volume = 500 * pi * 5^2;

t_interval = 1e-5;
m = volume * 0.85;
rho = 0.85;
p = 100;
rho_high = density(160);
%open_time = 0.000279572;
open_time = 0.23;
t_total = 3;
time = linspace(0, t_total, t_total / t_interval);
length = length(time);
R = zeros(length, 1);
P = zeros(length, 1);
for i = 1:length
    t = time(i);
    Q = 0;
    open1 = Q_open(t, open_time);
    [open2, Q2] = Q2_open(t);
    if open1 || open2
        if open1
            Q = C*A*sqrt(2*(160 - p)*10^3/rho_high);
        end
        m = m - rho * (Q2 - Q) * t_interval * 10^3;
        rho = m / volume;
        p = pressure(rho);
    
    end
    fprintf('t=%f p=%f rho=%f\n', t, p, rho);
    R(i) = rho;
    P(i) = p;
end
plot(time, R);
plot(time, P);

function open = Q_open(t, open_time)
    period = 100;
    t = t * 1000;
    if period * (t / period - floor(t / period)) < open_time
        open = true;
    else
        open = false;
    end
end

function [open, q] = Q2_open(t)
    t0 = t * 10 - floor(t * 10);
    t0 = t0 * 100; % round to ms
    if t0 < 0.2
        q = 100 * t0;
        open = true;
    elseif t0 <= 2.2
        q = 20;
        open = true;
    elseif t0 <= 2.4
        q = 100 * (2.4 - t0);
        open = true;
    else
        q = 0;
        open = false;
    end
end