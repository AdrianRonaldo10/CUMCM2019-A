function rho = density(p)
%DENSITY compute density from pressure
    %p
    % load 'EP_model.mat' EP_model;
    function y = EP_model(x)
        y = 1489 * exp(0.00284 * x) + 48.79 * exp(0.01376 * x); % for better performance
    end
    EP_recip = @(x)1./EP_model(x);
    rho = exp(log(0.85) + integral(EP_recip,100,p,'ArrayValued',true));
end

