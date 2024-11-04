function lab2Q6fg()
    % Definiera de tre punkterna
    points = [10, 10; 12, 2; 3, 8];
    x = points(:, 1);
    y = points(:, 2);

    % Högerleden i linjära systemet
    b = x.^2 + y.^2;

    % Koefficientmatrisen för det linjära systemet
    A = [ones(3, 1), x, y];

    % Lösa det linjära systemet
    c = A \ b;

    % Beräknar medelpunkt (X, Y) och radie R
    X = c(2)/2;
    Y = c(3)/2;
    R = sqrt(c(1) + X^2 + Y^2);  % Vi använder att R^2 = c_1 - X^2 - Y^2

    % Skriver ut resultaten
    fprintf('Medelpunkt: (X, Y) = (%.5f, %.5f)\n', X, Y);
    fprintf('Radie: R = %.5f\n', R);
end
