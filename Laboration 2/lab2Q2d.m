% Parametrar
L = 4.00;
h = 0.000625;
n = round(L / h); % Beräkna antalet delintervall baserat på steglängden

% Definiera differentialekvationen
f = @(x, y) -((1/6) + (pi * sin(pi * x)) / (1.6 - cos(pi * x))) * y;

% Initialvärde
y0 = 2.5;

% Lös differentialekvationen med Euler-metoden
x = linspace(0, L, n+1);
y = zeros(size(x));
y(1) = y0;
for i = 1:n
    y(i+1) = y(i) + h * f(x(i), y(i));
end

% Interpolera konturkurvan för att få jämna värden för konturkurvan
x_vals = linspace(0, L, 40);
y_vals = interp1(x, y, x_vals);

% Skapa en radvektor för rotationsvinkeln 0 ≤ φ ≤ 2π med lagom steg
phi = linspace(0, 2*pi, 30);

% Bilda matriserna X, Y och Z
X = x_vals' * ones(size(phi));
Y = y_vals' * cos(phi);
Z = y_vals' * sin(phi);

% Skapa en 3D-figur av luren
figure;
mesh(X, Y, Z); 
title('3D-figur av luren');
xlabel('x');
ylabel('y');
zlabel('z');
grid on;
