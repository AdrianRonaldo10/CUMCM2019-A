function rho = density(p)
%DENSITY compute density from pressure
    load 'EP_model.mat' EP_model;
    EP_recip = @(x)1./EP_model(x);
    rho = exp(log(0.85) + integral(EP_recip,100,p,'ArrayValued',true));
end

