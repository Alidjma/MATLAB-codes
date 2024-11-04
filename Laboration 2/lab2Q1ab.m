% Startvärden
y0 = 2.5;
x0 = 0;
xf = 4;
h = 0.0078125;

% för 0,5 ges Värdet av y(4) är: 0.026945
% för 0,25 ges Värdet av y(4) är: 0.202440
% för 0,125 ges Värdet av y(4) är: 0.601054
% för 0,0625 ges Värdet av y(4) är: 0.894788
% för 0,03125 ges Värdet av y(4) är: 1.074996
% för 0.015625 ges Värdet av y(4) är: 1.175363
% för 0,0078125 ges Värdet av y(4) är: 1.175363
% för 0.0078125 ges Värdet av y(4) är: 1.228425

% Antal steg
n = (xf - x0)/h;

% Initialisera värden
x = x0;
y = y0;

% Arrayer för att spara resultat för plotting
x_values = x;
y_values = y;

% Funktionen som definierar differentialekvationen
dy = @(x, y) -(1/6 + (pi*sin(pi*x))/(1.6 - cos(pi*x))) * y;

% Eulers metod
for i = 1:n
    y = y + h * dy(x, y);
    x = x + h;
    
    % Spara resultatet för varje steg
    x_values = [x_values, x];
    y_values = [y_values, y];
end

% Skriv ut värdet av y(4)
fprintf('Värdet av y(4) är: %f\n', y);

% Plotta resultatet
plot(x_values, y_values, '-o');
title('Lösning av differentialekvationen med Eulers metod');
xlabel('x');
ylabel('y');
grid on;
