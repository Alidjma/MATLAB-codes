clear;
clc;

% Parameterdefinitioner
L = 3.60;    % Längden på staven i meter
T0 = 310;    % Temperatur vid x=0 i Kelvin
TL = 450;    % Temperatur vid x=L i Kelvin
x_target = 1.65;  % Punkten där vi vill undersöka temperaturen

% Värmeledningsförmåga k(x) och värmegenerering Q(x)
k = @(x) 3 + x / 7;
Q = @(x) 280 * exp(-(x - L / 2).^2);

% Diskretiseringsparametrar
n = 24;  % Antal delintervall
h = L / n;  % Diskretiseringssteg
x = linspace(0, L, n+1);  % Diskretiserade x-värden

% Initiera matris A och vektor b
A = zeros(n+1);
b = zeros(n+1, 1);

% Fyll matris A och vektor b med finita differenser
for i = 2:n
    xi = x(i);
    A(i, i-1) = k(xi - h/2) / h^2;
    A(i, i) = -(k(xi - h/2) + k(xi + h/2)) / h^2;
    A(i, i+1) = k(xi + h/2) / h^2;
    b(i) = -Q(xi);
end

% Tillämpa randvillkoren
A(1, 1) = 1;
b(1) = T0;
A(n+1, n+1) = 1;
b(n+1) = TL;

% Lös det linjära ekvationssystemet
T = A \ b;

% Beräkna temperaturen vid x_target med linjär och kvadratisk interpolation
T_target_lin = interp1(x, T, x_target, 'linear');
T_target_quad = interp1(x, T, x_target, 'spline'); % 'spline' är en annan kvadratisk interpolation

% Beräkna temperaturfördelningen längs staven
figure;
plot(x, T, '-o');
title('Temperaturfördelning längs staven');
xlabel('Längd x (m)');
ylabel('Temperatur T (K)');
grid on;

% Skriv ut temperaturen vid x_target
fprintf('Temperaturen vid x = %.2f är %.8f K (linjär interpolation)\n', x_target, T_target_lin);
fprintf('Temperaturen vid x = %.2f är %.8f K (kvadratisk interpolation)\n', x_target, T_target_quad);

% Kontrollera noggrannheten med konvergensanalys
n_values = [24, 48, 96, 192, 384, 768, 1536];
T_values_lin = zeros(length(n_values), 1);
T_values_quad = zeros(length(n_values), 1);

for j = 1:length(n_values)  % Loopar olika värden på antalet delintervall
    n = n_values(j);  % Sätter #delintervall till det aktuella värdet
    h = L / n;  % Beräknar diskretiseringssteget
    x = linspace(0, L, n+1);  % Skapar vektor av diskretiserade x-värden
    
    A = zeros(n+1);  % Initierar matris A 
    b = zeros(n+1, 1);  % Initierar vektor b 
    
    for i = 2:n  % Loopar över de inre punkterna (exkl. randpunkterna)
        xi = x(i);  % Aktuellt x-värde
        A(i, i-1) = k(xi - h/2) / h^2;  % lägger till elementet vänster om diagonalen
        A(i, i) = -(k(xi - h/2) + k(xi + h/2)) / h^2;  % Fyller diagonalelementet
        A(i, i+1) = k(xi + h/2) / h^2;  % Fyller elementet höger om diagonalen
        b(i) = -Q(xi);  % Fyller motsvarande element i vektor b med värmegenereringen
    end
    
    A(1, 1) = 1;  % Sätter första elementet i matris A för randvillkoret vid x = 0
    b(1) = T0;  % Sätter första elementet i vektor b till temperaturen vid x = 0
    A(n+1, n+1) = 1;  % Sätter sista elementet i matris A för randvillkoret vid x = L
    b(n+1) = TL;  % Sätter sista elementet i vektor b till temperaturen vid x = L
    
    T = A \ b;  % Löser det linjära ekvationssystemet för temperaturerna
    T_values_lin(j) = interp1(x, T, x_target, 'linear');  % Interpolerar för att hitta temperaturen vid x_target och sparar resultatet
    T_values_quad(j) = interp1(x, T, x_target, 'spline');  % Interpolerar för att hitta temperaturen vid x_target och sparar resultatet
end

% Beräkna skillnaden mellan linjär och kvadratisk interpolation
skillnader = abs(T_values_lin - T_values_quad);

% Visa konvergensanalys
fprintf('Konvergenskontroll:\n');
fprintf('%-15s %-20s %-20s\n', 'Antal Intervall', 'Temp vid x=1.65 (lin)', 'Temp vid x=1.65 (kvad)');
for j = 1:length(n_values)
    fprintf('%-15d %-20.5f %-20.16f\n', n_values(j), T_values_lin(j), T_values_quad(j));
end

fprintf('Skillnader mellan linjär och kvadratisk interpolation:\n');
for j = 1:length(n_values)
    fprintf('%-15d %-20.16f\n', n_values(j), skillnader(j));
end

% Beräkna och visa felgränsen för temperaturen vid x_target
T_error_lin = abs(diff(T_values_lin));
T_error_quad = abs(diff(T_values_quad));
fprintf('Felgräns (linjär interpolation): %.8e K\n', max(T_error_lin));
fprintf('Felgräns (kvadratisk interpolation): %.8e K\n', max(T_error_quad));
