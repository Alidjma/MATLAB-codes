% 6b) Bestäm en övre gräns B för svansen
tolerans = 1e-8; % Önskad noggrannhet
B = 1000; % Första gissning

% Bestäm svansen
svans_integrand = @(x) (1 - exp(-(x/5).^3)) ./ (5 .* x.^3);
svans_value = integral(svans_integrand, B, Inf, 'RelTol', tolerans, 'AbsTol', tolerans);

% Justera B tills svansvärdet är mindre än epsilon
while svans_value > tolerans
    B = B + 1;
    svans_value = integral(svans_integrand, B, Inf, 'RelTol', tolerans, 'AbsTol', tolerans);
end

fprintf('Bestämd övre gräns B: %.4f\n', B);
fprintf('Svansens bidrag: %.4e\n', svans_value);
