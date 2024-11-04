function Q7a()
    % Definiera integranden
    integrand = @(x) 153 * exp(-((11*x - pi)/0.004).^2);

    % Bild på integrand
    figure;
    fplot(integrand, [0, 2*pi/11]);
    title('Integrandens beteende');
    xlabel('x');
    ylabel('153 * exp(-((11*x - pi)/0.004)^2)');
    grid on;

    % Välj ett lämpligt intervall baserat på visualiseringen
    % Här används ett intervall nära pi/11
    interval_start = (pi/11) - 0.01;
    interval_end = (pi/11) + 0.01;

    % Använd quad-funktionen för att beräkna integralen
    [integral_value_quad, quad_error] = quad(integrand, interval_start, interval_end, 1e-12);

    % Använd Integral-funktionen för att beräkna integralen med uppskattad felgräns
    [integral_value, int_error] = quadgk(integrand, interval_start, interval_end, 'RelTol', 1e-12, 'AbsTol', 1e-12);

    % Visa resultaten
    fprintf('Integralens värde beräknat med quad: %.8f\n', integral_value_quad);
    fprintf('Felgräns med quad: %.8e\n', quad_error);
    fprintf('Integralens värde beräknat med integral: %.8f\n', integral_value);
    fprintf('Felgräns med integral: %.8e\n', int_error);

    % Kontrollera om resultaten är lika inom felgränserna
    if abs(integral_value_quad - integral_value) < max(quad_error, int_error)
        fprintf('Resultaten från quad och integral överensstämmer inom felgränserna.\n');
    else
        fprintf('Resultaten från quad och integral överensstämmer inte inom felgränserna.\n');
    end
end
