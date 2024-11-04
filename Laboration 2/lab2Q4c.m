clear;
clc;

% Parametrar
L = 3.60;    % Längden på staven i meter
x_target = 2.96;  % Punkten där vi vill undersöka temperaturen
T0 = 310;   % Temperatur vid början av staven (vid x = 0)
TL = 450;   % Temperatur vid slutet av staven (vid x = L)

% Starta med ett litet antal delintervall och öka tills vi hittar en lämplig
found = false;
n = 1;
while ~found
    n = n + 1;
    h = L / n;  % Diskretiseringssteg
    x = linspace(0, L, n+1);  % Skapa x-värden jämnt fördelade över intervallet [0, L]
    % Kontrollera om x_target är en nodpunkt
    if any(abs(x - x_target) < 1e-10)
        found = true;
    end
end

fprintf('Det minsta antalet delintervall för att undersöka temperaturen vid x = %.2f är %.0f\n', x_target, n);

% Fortsätt med beräkningen för att undersöka temperaturen vid x = 2.96
% Skapa matris och högerled
A = zeros(n+1);
b = zeros(n+1, 1);

% Värden för k(x) och Q(x)
k = @(x) 3 + x / 7;
Q = @(x) 280 * exp(-(x - L/2).^2);

% Fyll matris A och vektor b
for i = 2:n
    xi = x(i);
    A(i, i-1) = k(xi-h/2) / h^2;
    A(i, i) = - (k(xi-h/2) + k(xi+h/2)) / h^2;
    A(i, i+1) = k(xi+h/2) / h^2;
    b(i) = -Q(xi);
end

% Randvillkor
A(1, 1) = 1;
b(1) = T0;
A(n+1, n+1) = 1;
b(n+1) = TL;

% Lös systemet
T = A \ b;

% Beräkna temperaturen vid x_target med linjär interpolation
T_target_lin = interp1(x, T, x_target, 'linear');

% Beräkna temperaturen vid x_target med kvadratisk interpolation
if x_target <= x(end-1)
    idx = find(x < x_target, 1, 'last');
    if idx <= length(x) - 2
        xi = x(idx:idx+2);
        Ti = T(idx:idx+2);
        polyCoeff = polyfit(xi, Ti, 2);
        T_target_quad = polyval(polyCoeff, x_target);
    else
        T_target_quad = NaN; % Kvadratisk interpolation är inte tillämplig
    end
else
    T_target_quad = NaN; % Kvadratisk interpolation är inte tillämplig
end

% Skriv ut temperaturen vid x_target
fprintf('Temperaturen vid x = %.2f med linjär interpolation är %.20f K\n', x_target, T_target_lin);
fprintf('Temperaturen vid x = %.2f med kvadratisk interpolation är %.20f K\n', x_target, T_target_quad);

% Beräkna skillnaden mellan linjär och kvadratisk interpolation
if ~isnan(T_target_quad)
    diff_interpolation = abs(T_target_lin - T_target_quad);
    fprintf('Skillnaden mellan linjär och kvadratisk interpolation vid x = %.2f är %.8f K\n', x_target, diff_interpolation);
else
    fprintf('Kvadratisk interpolation är inte tillämplig vid x = %.2f\n', x_target);
end

% Plotta temperaturfördelningen längs staven
figure;
plot(x, T, '-o', 'DisplayName', 'Temperaturfördelning');
hold on;
plot(x_target, T_target_lin, 'rx', 'MarkerSize', 10, 'DisplayName', 'Linjär Interpolation');
if ~isnan(T_target_quad)
    plot(x_target, T_target_quad, 'bx', 'MarkerSize', 10, 'DisplayName', 'Kvadratisk Interpolation');
end
title('Temperaturfördelning längs staven');
xlabel('Längd x (m)');
ylabel('Temperatur T (K)');
legend;
grid on;
