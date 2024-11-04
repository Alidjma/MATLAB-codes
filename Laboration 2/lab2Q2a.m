clc;
clear;

% Definiera differentialekvationen
f = @(x, y) -((1/6) + (pi * sin(pi * x)) / (1.6 - cos(pi * x))) * y;

% Initialvärde och intervall
y0 = 2.5;
xspan = [0, 4];

% Definiera steglängd
h = 0.00001953125;
n = round((xspan(2) - xspan(1)) / h);

% Euler-metoden
x = linspace(xspan(1), xspan(2), n+1);
y = zeros(1, n+1);
y(1) = y0;
for i = 1:n
    y(i+1) = y(i) + h * f(x(i), y(i));
end

% Beräkna volymen med trapetsregeln
V = 0;
for i = 1:n
    V = V + pi * (y(i)^2 + y(i+1)^2) / 2 * h;
end

% Skriv ut resultatet
fprintf('Volymen med Euler-metoden är: %.5f\n', V);

% Richardson-extrapolation
h2 = h / 2;
n2 = 2 * n;

% Euler-metoden med halva steglängden
x2 = linspace(xspan(1), xspan(2), n2+1);
y2 = zeros(1, n2+1);
y2(1) = y0;
for i = 1:n2
    y2(i+1) = y2(i) + h2 * f(x2(i), y2(i));
end

% Beräkna volymen med trapetsregeln för halva steglängden
V2 = 0;
for i = 1:n2
    V2 = V2 + pi * (y2(i)^2 + y2(i+1)^2) / 2 * h2;
end

% Richardson-extrapolation för att förbättra noggrannheten
V_richardson = (4 * V2 - V) / 3;

% Skriv ut resultatet med Richardson-extrapolation
fprintf('Volymen med Richardson-extrapolation är: %.5f\n', V_richardson);

% Beräkna framdifferensen mellan Euler-metod med h och h/2
difference = V_richardson - V;

% Skriv ut framdifferensen
fprintf('Framdifferensen mellan Euler-metod med h och h/2 är: %.5f\n', difference);

% Andra Richardson-extrapolationen med h/4
h4 = h / 4;
n4 = 4 * n;

% Euler-metoden med h/4 steglängden
x4 = linspace(xspan(1), xspan(2), n4+1);
y4 = zeros(1, n4+1);
y4(1) = y0;
for i = 1:n4
    y4(i+1) = y4(i) + h4 * f(x4(i), y4(i));
end

% Beräkna volymen med trapetsregeln för h/4 steglängden
V4 = 0;
for i = 1:n4
    V4 = V4 + pi * (y4(i)^2 + y4(i+1)^2) / 2 * h4;
end

% Richardson-extrapolation med h/4
V_richardson2 = (4 * V4 - V2) / 3;

% Skriv ut resultatet med den andra Richardson-extrapolationen
fprintf('Volymen med den andra Richardson-extrapolationen är: %.5f\n', V_richardson2);

% Beräkna skillnaden mellan de två Richardson-extrapolationerna
richardson_difference = V_richardson2 - V_richardson;

% Skriv ut skillnaden mellan de två Richardson-extrapolationerna
fprintf('Skillnaden mellan de två Richardson-extrapolationerna är: %.5f\n', richardson_difference);

% Plotta resultatet
figure;
plot(x, y, '-o', x2, y2, '-x', x4, y4, '-*');
title('Lösning av differentialekvationen och konturen');
xlabel('x');
ylabel('y(x)');
legend('Euler h', 'Euler h/2', 'Euler h/4');
grid on;
