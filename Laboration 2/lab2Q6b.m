function lab2Q6b()
    % Punkter genom vilka cirkeln går
    points = [10, 10; 12, 2; 3, 8];
    x1 = points(1,1);
    y1 = points(1,2);
    x2 = points(2,1);
    y2 = points(2,2);
    x3 = points(3,1);
    y3 = points(3,2);
    
    % Initial gissning för (X, Y, R)
    initial_guess = [9, 9, 5];
    
    % Använda fsolve för att lösa systemet med Newtons metod
    options = optimoptions('fsolve', 'Display', 'iter', 'Algorithm', 'levenberg-marquardt');
    [solution, ~, exitflag, output] = fsolve(@circle_system, initial_guess, options);
    
    % Tar fram lösningen
    X = solution(1);
    Y = solution(2);
    R = solution(3);
    
    % Skriv ut resultatet
    fprintf('Centrum (X, Y) = (%.5f, %.5f)\n', X, Y);
    fprintf('Radie R = %.5f\n', R);
    
    % Plotta cirkeln och punkterna
    theta = linspace(0, 2*pi, 100);
    x_circle = R * cos(theta) + X;
    y_circle = R * sin(theta) + Y;

    figure;
    plot(x_circle, y_circle, 'b-', 'LineWidth', 1.5); hold on;
    plot([x1, x2, x3], [y1, y2, y3], 'ro', 'MarkerFaceColor', 'r');
    plot(X, Y, 'ko', 'MarkerFaceColor', 'k');
    axis equal;
    grid on;
    title('Cirkel genom tre punkter med markerat centrum');
    xlabel('X-koordinat');
    ylabel('Y-koordinat');
    legend('Cirkel', 'Punkter', 'Centrum', 'Location', 'Best');

    function F = circle_system(vars)
        % Variabler
        X = vars(1);
        Y = vars(2);
        R = vars(3);
        
        % Systemet av ekvationer
        F(1) = (x1 - X)^2 + (y1 - Y)^2 - R^2;
        F(2) = (x2 - X)^2 + (y2 - Y)^2 - R^2;
        F(3) = (x3 - X)^2 + (y3 - Y)^2 - R^2;
    end
end
