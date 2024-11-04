clc;
clear;

% Parametrar
L = 4.00;
h = 0.000625; 
N = round(L / h); % Beräkna antalet delintervall baserat på steglängden

% Definiera differentialekvationen
f = @(x, y) -((1/6) + (pi * sin(pi * x)) / (1.6 - cos(pi * x))) * y;

% Initialvärde
y0 = 2.5;

% Beräkna den ursprungliga volymen
V0 = berakna_volym(L, N, f, y0);
V_target = 0.72 * V0;

% Parametrar för sekantmetoden
tolerances = [1e-4, 1e-6, 1e-8];
max_iter = 100;
L_init = 4.00;  % Initialt gissat L
L1 = 3.80;  % Andra gissning

for tol = tolerances
    L0 = L_init;  % Initialt gissat L
    L1 = 3.80;  % Andra gissning
    prev_L = NaN; % För att lagra föregående L

    for iter = 1:max_iter
        V0_diff = berakna_volym(L0, round(L0 / h), f, y0) - V_target;
        V1_diff = berakna_volym(L1, round(L1 / h), f, y0) - V_target;
        L2 = L1 - V1_diff * (L1 - L0) / (V1_diff - V0_diff);

        if abs(L2 - L1) < tol
            L_new = L2;
            fprintf('Tolerans: %.0e, Iterationer: %d, Ny axellängd L: %.10f\n', tol, iter, L_new);
            if ~isnan(prev_L)
                mellanskillnad = abs(L_new - prev_L);
                fprintf('Mellanskillnad i de två sista axellängderna: %.10f\n', mellanskillnad);
            end
            break;
        end

        prev_L = L1; % Uppdatera föregående L
        L0 = L1;
        L1 = L2;
    end

    if iter == max_iter
        fprintf('Sekantmetoden konvergerade inte inom maximalt antal iterationer för tolerans %.0e\n', tol);
    end
end

% Funktion för att beräkna volymen
function V = berakna_volym(L, N, f, y0)
    xspan = [0, L];
    h = L / N;

    % Euler-metoden
    x = linspace(xspan(1), xspan(2), N+1);
    y = zeros(1, N+1);
    y(1) = y0;
    for i = 1:N
        y(i+1) = y(i) + h * f(x(i), y(i));
    end

    % Beräkna volymen med trapetsregeln
    V = 0;
    for i = 1:N
        V = V + pi * (y(i)^2 + y(i+1)^2) / 2 * h;
    end

    % Richardson-extrapolation
    N2 = 2 * N;
    h2 = L / N2;

    % Euler-metoden med halva steglängden
    x2 = linspace(xspan(1), xspan(2), N2+1);
    y2 = zeros(1, N2+1);
    y2(1) = y0;
    for i = 1:N2
        y2(i+1) = y2(i) + h2 * f(x2(i), y2(i));
    end

    % Beräkna volymen med trapetsregeln för halva steglängden
    V2 = 0;
    for i = 1:N2
        V2 = V2 + pi * (y2(i)^2 + y2(i+1)^2) / 2 * h2;
    end

    % Richardson-extrapolation för att förbättra noggrannheten
    V = (4 * V2 - V) / 3;
end
