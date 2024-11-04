function lab2Q6h()
    % Definiera de tre punkterna
    points = [10, 10; 12, 2; 3, 8];
    x = points(:, 1);
    y = points(:, 2);

    % Högerleden i det linjära systemet, med modifiering för tredje punkten
    b = [x(1)^2 + y(1)^2; x(2)^2 + y(2)^2; 4 * (x(3)^2 + y(3)^2)];

    % Koefficientmatrisen för det linjära systemet, med modifiering för tredje raden
    A = [1, x(1), y(1);
         1, x(2), y(2);
         4, 4*x(3), 4*y(3)];  % Tredje raden multipliceras med 4

    % Löser det linjära systemet
    c = A \ b;

    % Beräknar medelpunkt (X, Y) och radie R
    X = c(2)/2;
    Y = c(3)/2;
    R = sqrt(c(1) + X^2 + Y^2);  % Vi använder att R^2 = c_1 - X^2 - Y^2

    % Skriver ut resultaten
    fprintf('Medelpunkt: (X, Y) = (%.4f, %.4f)\n', X, Y);
    fprintf('Radie: R = %.4f\n', R);
end
