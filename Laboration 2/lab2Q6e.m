function lab2Q6e()
    % Definiera de fem punkterna
    points = [10, 10; 12, 2; 3, 8; 11, 11; 2, 9];
    
    % Initial gissning för cirkelns centrum (X, Y) och radie R
    initial_guess = [6, 6, 5];
    
    % Använd lsqnonlin för att minimera kvadraten av avstånden från punkterna till cirkeln
    options = optimoptions('lsqnonlin', 'Algorithm', 'trust-region-reflective', 'Display', 'off');
    [solution, resnorm, residual, exitflag, output] = lsqnonlin(@circle_objectiv_modified, initial_guess, [], [], options);
    
    % Lösningen ger centrum och radie
    X = solution(1);
    Y = solution(2);
    R = solution(3);
    
    % Skriver ut resultaten
    fprintf('Med modifierad tredje ekvation (multiplicerad med 3): (X, Y) = (%.4f, %.4f), R = %.4f\n', X, Y, R);
    
    % Ritar cirkeln och punkterna
    theta = linspace(0, 2*pi, 100);
    x_circle = R * cos(theta) + X;
    y_circle = R * sin(theta) + Y;
    
    figure;
    plot(x_circle, y_circle, 'b-', 'LineWidth', 1.5); hold on;
    plot(points(:,1), points(:,2), 'ro', 'MarkerFaceColor', 'r');
    plot(X, Y, 'ko', 'MarkerFaceColor', 'k');
    axis equal;
    grid on;
    title('Cirkel med fem punkter ');
    xlabel('X-koordinat');
    ylabel('Y-koordinat');
    legend('Anpassad cirkel', 'Givna punkter', 'Centrum', 'Location', 'best');
    
    function F = circle_objectiv_modified(vars)
        % Extrahera variablerna
        X = vars(1);
        Y = vars(2);
        R = vars(3);
        
        % Beräkna avstånden från varje punkt till cirkelns omkrets
        distances = sqrt((points(:,1) - X).^2 + (points(:,2) - Y).^2) - R;
        
        % Modifiera tredje punktens bidrag
        distances(3) = 3 * distances(3);  % Tredje punktens avstånd multipliceras med 3
        
        % Funktionen att minimera (kvadraten av avstånden)
        F = distances;
    end
end
