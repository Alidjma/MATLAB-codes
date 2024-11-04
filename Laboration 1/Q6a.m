% 6a) Plotta integranden
clc;
clear;
f = @(x) (1 - exp(-(x/5).^3)) ./ (5 .* x.^3);

x_values = linspace(1e-10, 1e-4, 1000); % Undvik x = 0 för att inte få division med 0
y_values = f(x_values);

figure;
plot(x_values, y_values);
grid on;
title('Integrandens beteende nära x = 0');
xlabel('x');
ylabel('Integrandens värde');
