function lab2Q6d()
    % Definiera de fem punkterna
    points = [10, 10; 12, 2; 3, 8; 11, 11; 2, 9];
    
    % Initial gissning för cirkelns centrum (X, Y) och radie R
    initial_guess = [6, 6, 5];
    
    % Använd lsqnonlin för att minimera kvadraten av avstånden från punkterna till cirkeln
    options = optimoptions('lsqnonlin', 'Algorithm', 'trust-region-reflective', 'Display', 'off');
    [solution, resnorm, residual, exitflag, output] = lsqnonlin(@circle_objective, initial_guess, [], [], options);
    
    % Lösningen ger centrum och radie
    X = solution(1);
    Y = solution(2);
    R = solution(3);
    
    % Skriver ut resultaten
    fprintf('Cirkel centrum: (X, Y) = (%.4f, %.4f)\n', X, Y);
    fprintf('Cirkel radie: R = %.4f\n', R);
    
    % Ritar cirkeln och punkterna
    theta = linspace(0, 2*pi, 100);
    x_circle = R * cos(theta) + X;
    y_circle = R * sin(theta) + Y;
    
    figure;
    h_circle = plot(x_circle, y_circle, 'b-', 'LineWidth', 1.5); hold on;
    h_points = plot(points(:,1), points(:,2), 'ro', 'MarkerFaceColor', 'r');
    h_center = plot(X, Y, 'ko', 'MarkerFaceColor', 'k');
    axis equal;
    grid on;
    title('Optimal Cirkel fem punkter');
    xlabel('X-koordinat');
    ylabel('Y-koordinat');
    legend([h_circle, h_points, h_center], {'Anpassad cirkel', 'Givna punkter', 'Centrum'}, 'Location', 'best');
    
    function F = circle_objective(vars)
        % Extrahera variablerna
        X = vars(1);
        Y = vars(2);
        R = vars(3);
        
        % Beräknar avstånden från varje punkt till cirkelns omkrets
        distances = sqrt((points(:,1) - X).^2 + (points(:,2) - Y).^2) - R;
        
        % Funktionen att minimera (kvadraten av avstånden)
        F = distances;
    end
end
