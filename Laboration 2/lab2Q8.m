function lab2Q8()
    % Givna parametrar
    s0 = 2.2;   % Begynnelsenivå för substratet
    e0 = 2.8;   % Begynnelsenivå för enzymet
    k1 = 11;    % Reaktionshastighetskonstant k1
    k2 = 1.6;   % Reaktionshastighetskonstant k2
    target_p = 1.75;  % Målkonsentration av p vid tid 1.5
    t_target = 1.5;   % Målpunkt

    % Initial gissning för k3
    k3_initial_guess = 0.5;

    % Toleransvärden att testa
    tolerances = [1e-4, 1e-8, 1e-12];
    k3_values = zeros(size(tolerances));
    k3_errors = zeros(size(tolerances));

    % Beräkna k3 för varje toleransvärde
    for i = 1:length(tolerances)
        options = optimset('TolX', tolerances(i));  % Sätt toleransnivå
        k3_values(i) = fzero(@(k3) objectiveFunction(k3, s0, e0, k1, k2, t_target, target_p), k3_initial_guess, options);
        fprintf('Uppskattat värde av k3 för tolerans %.0e: %.10f\n', tolerances(i), k3_values(i));
    end

    % Beräkna skillnaden mellan resultaten för olika toleranser
    for i = 2:length(tolerances)
        k3_errors(i) = abs(k3_values(i) - k3_values(i-1));
        fprintf('Skillnad i k3 mellan tolerans %.0e och %.0e: %.10f\n', tolerances(i), tolerances(i-1), k3_errors(i));
    end

    % Lös systemet med det beräknade k3 för den finaste toleransen och plotta resultaten
    [t, y] = solveSystem(s0, e0, k1, k2, k3_values(end));
    figure;
    plot(t, y);
    xlabel('Tid');
    ylabel('Koncentration');
    legend('s (substrat)', 'e (enzym)', 'c (komplex)', 'p (produkt)', 'Location', 'Best');
    title(sprintf('Reaktionsdynamik med k3 = %.10f', k3_values(end)));

    % Intern funktion för att lösa med ODE
    function [t, y] = solveSystem(s0, e0, k1, k2, k3)
        initial_conditions = [s0, e0, 0, 0];  % Initiala villkor för s, e, c, p
        % Använd ode45 för att lösa differentialekvationerna för reaktionen över tiden
        [t, y] = ode45(@(t, y) reaction_ode(t, y, k1, k2, k3), [0 t_target], initial_conditions);
    end

    % Intern funktion för ODE
    function dydt = reaction_ode(t, y, k1, k2, k3)
        s = y(1);
        e = y(2);
        c = y(3);
        p = y(4);
        dsdt = -k1 * s * e + k2 * c;
        dedt = -k1 * s * e + k2 * c + k3 * c;
        dcdt = k1 * s * e - k2 * c - k3 * c;
        dpdt = k3 * c;
        % Samlar derivatorna i en vektor för att returnera till ODE-solver
        dydt = [dsdt; dedt; dcdt; dpdt];
    end

    % Målfunktion för att hitta rätt k3
    function error = objectiveFunction(k3, s0, e0, k1, k2, t_target, target_p)
        % Löser ODE-systemet med aktuella parametervärden
        [t, y] = solveSystem(s0, e0, k1, k2, k3);
        % Interpolera datan för att få produktens koncentration vid t_target
        p_at_t_target = interp1(t, y(:,4), t_target);  % Linjär interpolation
        % Beräkna skillnaden mellan beräknad produktkoncentration och målvärdet
        error = p_at_t_target - target_p;  % Beräknar fel
    end
end
