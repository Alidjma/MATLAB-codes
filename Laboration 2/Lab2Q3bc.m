% Parametrar
g = 9.81;   % Tyngdaccelerationen (m/s^2)
L = 2.5;    % Pendellängden (m)
phi0 = 6 * pi / 7;   % Initialvinkel (rad)
omega0 = 0.8;   % Initial vinkelhastighet (rad/s)

% Tidsintervall för simulering
T = 10;   % Total tid (s)
tspan = [0 T];   % Tidsintervall

% Initialvärden
y0 = [phi0; omega0];

% ODE-funktion
odefun = @(t, y) [y(2); -g/L * sin(y(1))];

% Lös systemet med ode45
[t, y] = ode45(odefun, tspan, y0);

% Plotta vinkel, respektive vinkelhastighet som funktion av tiden
figure(1);
subplot(2, 1, 1);
plot(t, y(:, 1), 'b-');
xlabel('Tid (s)');
ylabel('Vinkel \phi (rad)');
title('Vinkel som funktion av tiden');
grid on;

subplot(2, 1, 2);
plot(t, y(:, 2), 'r-');
xlabel('Tid (s)');
ylabel('Vinkelhastighet \omega (rad/s)');
title('Vinkelhastighet som funktion av tiden');
grid on;

% Animera pendelns gång
figure(2); % Nytt figure-fönster för animationen
anim(t, y(:, 1), L);

% Funktion för att animera pendeln
function anim(tut, fiut, L)
    for i = 1:length(tut)-1
        x0 = L * sin(fiut(i));
        y0 = -L * cos(fiut(i));
        plot([0, x0], [0, y0], '-o');
        axis('equal');
        axis([-1 1 -1 0] * 1.2 * L);
        drawnow;
        pause(tut(i+1) - tut(i));
    end
end
