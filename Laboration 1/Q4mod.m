clc;
disp("Interpolation och linjära minsta kvadratmetoden");

% Inledande Data
datum = [1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 365]; % Dag på året
tid = [6.25, 8.1, 10.55, 13.23, 15.9, 18.06, 18.4, 16.63, 14.08, 11.4, 8.78, 6.6, 6.23]; % Minuter av dagsljus

% Konvertera tid till negativa värden
negativ_tid = -tid;

% Datum och negativ tid för perioden 1 december till 1 februari
% Antag att dag 358 är 1 december och dag 32 är 1 februari i det nya året
dec_feb_datum = [358, datum(1), 32]; % Lägg till 1 januari i sekvensen
dec_feb_tid = [negativ_tid(end), negativ_tid(1), negativ_tid(2)]; % Lägg till tid för 1 januari

% Beräkna ett andragradspolynom baserat på de utvalda datumen
p_dec_feb = polyfit(dec_feb_datum, dec_feb_tid, 2);
x_dec_feb = linspace(min(dec_feb_datum), max(dec_feb_datum), 1000); % Skapa x-värden för plottningen
y_dec_feb = polyval(p_dec_feb, x_dec_feb); % Beräkna y-värden baserade på polynomet

% Plotta resultaten
figure;
plot(dec_feb_datum, dec_feb_tid, 'bx', 'MarkerFaceColor', 'k', 'DisplayName', 'Observerade negativa data'); hold on;
plot(x_dec_feb, y_dec_feb, 'r-', 'DisplayName', 'Andragradspolynom för Dec-Feb');
xlabel('Dagar');
ylabel('Negativa timmar av dagsljus');
title('Tid solen är uppe i Stockholm');
grid on;
legend('show');
hold off;
