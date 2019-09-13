function D = TD_model(T)
%TD_model Appendix 2 curve fitting
    load 'TD_model_ori.mat' TD_model_ori;
    if T <= 0 || T >= 2.45
        D = 0;
    elseif T < 0.45
        D = TD_model_ori(T);
    elseif T > 2
        D = TD_model_ori(2.45 - T);
    else
        D = 2;
    end
end

