% Huvudprogram
L = 3.6;          % Längden på staven
T0 = 310;        % Temperatur vid x = 0
TL = 450;        % Temperatur vid x = L
target_x = 1.65; % Punkt där temperaturen ska beräknas

% Initial gissning för T'(0)
alpha_guess = 500;  % Använd en mer rimlig gissning

% Lös med olika toleranser
toleranser = [1e-8, 1e-9, 1e-10, 1e-11, 1e-12];
resultat_lin = zeros(length(toleranser), 1);
resultat_quad = zeros(length(toleranser), 1);

for i = 1:length(toleranser)
    % Options för ode45
    options = odeset('RelTol', toleranser(i), 'AbsTol', toleranser(i));
    
    % Använd fzero för att justera alpha så att T(L) = TL
    alpha = fzero(@(alpha) boundary_residual(alpha, L, T0, TL, options), alpha_guess);
    
    % Lös initialvärdesproblemet
    [x, T] = ode45(@(x, T) heat_eq(x, T, @k, @Q), [0 L], [T0; alpha], options);
    
    % Linjär interpolation för T(target_x)
    resultat_lin(i) = interp1(x, T(:, 1), target_x, 'linear');
    
    % Kvadratisk interpolation för T(target_x)
    if target_x <= x(end-1)
        idx = find(x < target_x, 1, 'last');
        xi = x(idx:idx+2);
        Ti = T(idx:idx+2, 1);
        polyCoeff = polyfit(xi, Ti, 2);
        resultat_quad(i) = polyval(polyCoeff, target_x);
    else
        resultat_quad(i) = NaN; % Kvadratisk interpolation är inte tillämplig
    end
    
    % Skriv ut resultatet för varje tolerans
    fprintf('Temperaturen vid x=%.2f med tolerans %.0e är %.8f (linjär) och %.8f (kvadratisk)\n', target_x, toleranser(i), resultat_lin(i), resultat_quad(i));
end

% Richardson-extrapolation för att förbättra lösningen (linjär)
T_at_target_extrapolated_lin = resultat_lin(2) + (resultat_lin(2) - resultat_lin(1)) / (2^2 - 1);
% Richardson-extrapolation för att förbättra lösningen (kvadratisk)
T_at_target_extrapolated_quad = resultat_quad(2) + (resultat_quad(2) - resultat_quad(1)) / (2^2 - 1);

% Beräkna felgränsen (linjär)
error_estimate_lin = abs(resultat_lin(2) - resultat_lin(1)) / (2^2 - 1);
% Beräkna felgränsen (kvadratisk)
error_estimate_quad = abs(resultat_quad(2) - resultat_quad(1)) / (2^2 - 1);

fprintf('Temperaturen vid x=%.2f efter Richardson-extrapolation är %.8f (linjär) med felgräns: %.4e\n', target_x, T_at_target_extrapolated_lin, error_estimate_lin);
fprintf('Temperaturen vid x=%.2f efter Richardson-extrapolation är %.8f (kvadratisk) med felgräns: %.4e\n', target_x, T_at_target_extrapolated_quad, error_estimate_quad);

% Funktion för att beräkna residualen vid randvärdet
function res = boundary_residual(alpha, L, T0, TL, options)
    [~, T] = ode45(@(x, T) heat_eq(x, T, @k, @Q), [0 L], [T0; alpha], options);
    res = T(end, 1) - TL;
end

% Differentialekvationen
function dTdx = heat_eq(x, T, k, Q)
    dTdx = [T(2); -Q(x) / k(x)];
end

% Funktion för värmeledningsförmågan k(x)
function val = k(x)
    val = 3 + x / 7;
end

% Funktion för värmegenerering Q(x)
function val = Q(x)
    L = 3.6;
    val = 280 * exp(-((x - L / 2)^2));
end
