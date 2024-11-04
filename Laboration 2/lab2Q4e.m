function lab2Q4e()
    % Givna parametrar
    L = 3.60;  % Stavens längd
    T0 = 310;  % Temperatur vid x=0
    TL = 450;  % Temperatur vid x=L

    % Värden för k(x) och Q(x)
    k = @(x) 3 + x / 7;
    Q = @(x) 280 * exp(-(x - L/2).^2);

    % Anropa funktionen för att skatta maximala temperaturen
    [T_max_lin, x_max_lin, T_max_quad, x_max_quad] = estimate_max_temperature(L, T0, TL, k, Q);

    % Skriv ut resultatet
    fprintf('Den maximala temperaturen med linjär interpolation är %.8f K vid x = %.4f\n', T_max_lin, x_max_lin);
    fprintf('Den maximala temperaturen med kvadratisk interpolation är %.8f K vid x = %.4f\n', T_max_quad, x_max_quad);
    fprintf('Skillnaden mellan linjär och kvadratisk interpolation är %.8f K\n', abs(T_max_lin - T_max_quad));
end

function [T_max_lin, x_max_lin, T_max_quad, x_max_quad] = estimate_max_temperature(L, T0, TL, k, Q)
    % Grov diskretisering
    n_grov = 100;
    x_grov = linspace(0, L, n_grov+1);
    T_grov = solve_temperature_distribution(L, T0, TL, n_grov, k, Q);
    
    % Preliminär uppskattning av maximal temperatur
    [T_max_prelim, idx_max_prelim] = max(T_grov);
    x_max_prelim = x_grov(idx_max_prelim);
    
    % Lokalt intervall runt preliminär maximal temperatur
    delta_x = 0.1;  % Justera detta värde baserat på behov
    x_local = linspace(max(0, x_max_prelim - delta_x), min(L, x_max_prelim + delta_x), n_grov+1);
    T_local = solve_temperature_distribution_interval(L, T0, TL, x_local, k, Q);
    
    % Finare diskretisering inom det lokala intervallet
    n_fin = 200;  % Finare diskretisering
    x_fine = linspace(min(x_local), max(x_local), n_fin);
    
    % Linjär interpolation
    T_fine_lin = interp1(x_local, T_local, x_fine, 'linear');
    [T_max_lin, idx_max_lin] = max(T_fine_lin);
    x_max_lin = x_fine(idx_max_lin);
    
    % Kvadratisk interpolation
    T_fine_quad = interp1(x_local, T_local, x_fine, 'spline');
    [T_max_quad, idx_max_quad] = max(T_fine_quad);
    x_max_quad = x_fine(idx_max_quad);
end

function T = solve_temperature_distribution(L, T0, TL, n, k, Q)
    h = L / n;  % Diskretiseringssteg
    x = linspace(0, L, n+1);  % Diskretiserade x-värden från 0 till L
    A = zeros(n+1);  % Initierar matris A med nollor
    b = zeros(n+1, 1);  % Initierar vektor b med nollor
    
    for i = 2:n  % Loopar över de inre punkterna (exkluderar randpunkterna)
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
    
    T = A \ b;  % Löser det linjära ekvationssystemet för temperaturerna
end

function T = solve_temperature_distribution_interval(L, T0, TL, x_local, k, Q)
    % Löser temperaturfördelningen inom ett lokalt intervall runt
    n = length(x_local) - 1; % Antal delintervall i det lokala området
    h = (x_local(end) - x_local(1)) / n;
    A = zeros(n+1);
    b = zeros(n+1, 1);
    
    for i = 2:n % Loopar över de inre punkterna (exkluderar randpunkterna)
        xi = x_local(i);
        A(i, i-1) = k(xi-h/2) / h^2;
        A(i, i) = - (k(xi-h/2) + k(xi+h/2)) / h^2;
        A(i, i+1) = k(xi+h/2) / h^2;
        b(i) = -Q(xi);
    end
    
    % Randvillkor
    A(1, 1) = 1;
    b(1) = interp1(linspace(0, L, length(x_local)), solve_temperature_distribution(L, T0, TL, length(x_local)-1, k, Q), x_local(1));
    A(n+1, n+1) = 1;
    b(n+1) = interp1(linspace(0, L, length(x_local)), solve_temperature_distribution(L, T0, TL, length(x_local)-1, k, Q), x_local(end));
    
    T = A \ b;
end
