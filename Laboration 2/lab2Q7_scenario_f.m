%Kontrollerar graf för scenario F 
function lab2Q7_scenario_f()
    % Konstanter och startvärden för scenario f
    scenario_f = struct('s0', 1.1, 'e0', 2.1, 'k1', 1.8, 'k2', 1.0, 'k3', 0.02);

    % Tidsspann från 0 till 1.5 tidsenheter
    tspan = [0 1.5];

    % Ställ in toleranser för ode45
    options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8);

    % Initialvillkor för scenario f
    initial_conditions = [scenario_f.s0, scenario_f.e0, 0, 0];  % s, e, c, p initialt

    % Löser ODE-systemet med standard noggrannhet
    [t, y] = ode45(@(t, y) reaction_ode(t, y, scenario_f.k1, scenario_f.k2, scenario_f.k3), tspan, initial_conditions, options);

    % Plottar resultatet
    figure;
    plot(t, y(:,1), 'b-', t, y(:,2), 'r-', t, y(:,3), 'g-', t, y(:,4), 'k-');
    title(sprintf('Scenario f: k1=%.1f, k2=%.1f, k3=%.2f', scenario_f.k1, scenario_f.k2, scenario_f.k3));
    xlabel('Tid');
    ylabel('Koncentration');
    legend('s (substrate)', 'e (enzyme)', 'c (complex)', 'p (produkt)');
    grid on;

    % Skriver ut koncentrationerna vid sluttiden
    fprintf('Koncentrationer vid t=%.1f för scenario f:\n', t(end));
    fprintf('Substrat (s): %.4f\n', y(end, 1));
    fprintf('Enzym (e): %.4f\n', y(end, 2));
    fprintf('Komplex (c): %.4f\n', y(end, 3));
    fprintf('Produkt (p): %.4f\n\n', y(end, 4));

    % Beräkna och skriv ut felgränserna med högre noggrannhet för felgränsberäkning
    options_high_accuracy = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);
    [~, y_high_acc] = ode45(@(t, y) reaction_ode(t, y, scenario_f.k1, scenario_f.k2, scenario_f.k3), tspan, initial_conditions, options_high_accuracy);

    % Beräkna och skriv ut felgränserna
    s_error = abs(y(end, 1) - y_high_acc(end, 1));
    e_error = abs(y(end, 2) - y_high_acc(end, 2));
    c_error = abs(y(end, 3) - y_high_acc(end, 3));
    p_error = abs(y(end, 4) - y_high_acc(end, 4));

    fprintf('Felgränser vid t=%.1f för scenario f:\n', t(end));
    fprintf('Substrat (s) felgräns: %.4e\n', s_error);
    fprintf('Enzym (e) felgräns: %.4e\n', e_error);
    fprintf('Komplex (c) felgräns: %.4e\n', c_error);
    fprintf('Produkt (p) felgräns: %.4e\n\n', p_error);
end

function dydt = reaction_ode(t, y, k1, k2, k3)
    s = y(1);
    e = y(2);
    c = y(3);
    p = y(4);

    dsdt = -k1 * s * e + k2 * c;
    dedt = -k1 * s * e + k2 * c + k3 * c;
    dcdt = k1 * s * e - k2 * c - k3 * c;
    dpdt = k3 * c;

    dydt = [dsdt; dedt; dcdt; dpdt];
end
