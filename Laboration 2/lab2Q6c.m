function lab2Q6c()
    % De tre punkterna
    points = [10, 10; 12, 2; 3, 8];
    x1 = points(1,1);
    y1 = points(1,2);
    x2 = points(2,1);
    y2 = points(2,2);
    x3 = points(3,1);
    y3 = points(3,2);
    
    % Initial gissning för (X, Y, R)
    initial_guess = [9, 9, 5];
    
    % Använder fsolve 
    options = optimoptions('fsolve', 'Display', 'off', 'Algorithm', 'trust-region-dogleg');
    [solution, ~, exitflag, output] = fsolve(@modified_circle_system, initial_guess, options);
    
    % Resultat
    X = solution(1);
    Y = solution(2);
    R = solution(3);
    fprintf('Med modifierad tredje ekvation: (X, Y) = (%.5f, %.5f), R = %.5f\n', X, Y, R);
    
    function F = modified_circle_system(vars)
        X = vars(1);
        Y = vars(2);
        R = vars(3);
        F(1) = (x1 - X)^2 + (y1 - Y)^2 - R^2;
        F(2) = (x2 - X)^2 + (y2 - Y)^2 - R^2;
        F(3) = 3 * ((x3 - X)^2 + (y3 - Y)^2 - R^2);  % Vi ändrar ekvationen
    end
end
