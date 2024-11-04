disp("3a - Sekantmetoden");
f = @(x) 61.*x - ((x.^2 + x + 0.03)./(3.*x + 1)).^7 - 20.*x.*exp(-x);

% Tolerans och maximalt antal iterationer
tol = 1e-8;
max_iter = 100;

% Använd sekantmetoden för att hitta rötter
[rot1, iter1, errors1] = sekantMetod(f, 0, 0.1, tol, max_iter);
[rot2, iter2, errors2] = sekantMetod(f, 6.3, 6.5, tol, max_iter);

disp("3b) Svar");
disp(["Första roten: ", num2str(rot1)]);
disp(["Andra roten: ", num2str(rot2)]);

disp("3d) Bestämma konvergenskonstant igen");
f = @(x) 62*x - ((x.^2 + x + 0.03)./(3*x + 1)).^7 - 20*x.*exp(-x);

% Startvärden och tolerans
x0 = 5;
x1 = 7;
tol = 1e-8;
error = Inf;

% Lagra felvärden
errors = [];

% Sök efter rötter
while error > tol
    % Beräkna nästa gissning med sekantmetoden
    x2 = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0));
    % Beräkna felet mellan den nya och den gamla gissningen
    error = abs(x2 - x1);
    x0 = x1;
    x1 = x2;
    errors = [errors, error]; % Uppdatera lagrade felvärden
end

% Beräkna och visa den genomsnittliga konvergenskonstanten för sekantmetoden
n = length(errors);
C_sum = 0; % Summa av alla konvergenskonstanter
alfa = 1.618; % Gyldene snittets konvergensfaktor

for i = 2:(n-1)
    C_nuvarande = errors(i+1) / (errors(i)^alfa);
    C_sum = C_sum + C_nuvarande;
end

C_genomsnitt = C_sum / (n - 2);

disp("Konvergenskonstant:");
disp(C_genomsnitt);

% Lokal funktionsdefinition
function [rot, iter, errors] = sekantMetod(f, x0, x1, tol, max_iter)
    iter = 0;
    fel = Inf;
    errors = [];
    % Iterera tills felet är mindre än toleransen eller maximalt antal iterationer uppnås
    while fel > tol && iter < max_iter
        x2 = x1 - f(x1) * ((x1 - x0) / (f(x1) - f(x0)));
        fel = abs(x2 - x1);
        errors = [errors, fel]; % Lagrar fel för konvergensanalys
        iter = iter + 1;
        x0 = x1;
        x1 = x2;
    end
    if iter == max_iter && fel > tol
    % Kontrollera om maximalt antal iterationer har uppnåtts utan konvergens
        disp("Maximalt antal iterationer nått utan konvergens.");
        rot = NaN; % Returnera NaN om ingen konvergens uppnåddes
    else
        rot = x2; % Returnera den funna roten
    end
end
