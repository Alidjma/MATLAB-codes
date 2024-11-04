clear;
clc;

% Konstanter och initialvärden
pendelLangd = 2.7;
gravitation = 9.81;
initialVinkel = 6 * pi / 7;
initialHastighet = 0.8;

% ODE-alternativ med hög precision för att säkerställa noggrannhet till 3 decimaler
installningar = odeset('RelTol', 1e-8, 'AbsTol', 1e-8);

% Lösning av differentialekvationen med ode45 över intervallet 0 till 50 sekunder
[tidsvarden, losning] = ode45(@(tid, y) [y(2); -(gravitation / pendelLangd) * sin(y(1))], [0, 50], [initialVinkel; initialHastighet], installningar);

% Identifierar tidpunkter då vinkeln passerar genom noll (från negativ till positiv)
nollpassager = find(diff(sign(losning(:, 1))) > 0);
nollpassageTider = tidsvarden(nollpassager);

% Filtrera nollpassager där vinkelhastigheten är positiv
validaTider = nollpassageTider(losning(nollpassager, 2) > 0);

% Linjär interpolation för att bestämma tidpunkterna för nollpassager
exaktaTiderLin = zeros(length(validaTider), 1);
for i = 1:length(validaTider)
    % Använd närliggande punkter för interpolation
    tidIntervall = tidsvarden(nollpassager(i)-1:nollpassager(i)+1);
    vinkelIntervall = losning(nollpassager(i)-1:nollpassager(i)+1, 1);
    
    % Linjär interpolation
    exaktaTiderLin(i) = interp1(vinkelIntervall, tidIntervall, 0);
end

% Beräkna svängningstiden baserat på de linjärt interpolerade tidpunkterna
perioderLin = diff(exaktaTiderLin);
medelPeriodLin = mean(perioderLin);

% Kvadratisk interpolation för att bestämma tidpunkterna för nollpassager
exaktaTiderKvadrat = zeros(length(validaTider), 1);
for i = 1:length(validaTider)
    % Använd närliggande punkter för interpolation
    tidIntervall = tidsvarden(nollpassager(i)-1:nollpassager(i)+1);
    vinkelIntervall = losning(nollpassager(i)-1:nollpassager(i)+1, 1);
    
    % Kvadratisk interpolation
    polyKoeff = polyfit(tidIntervall, vinkelIntervall, 2);
    rotter = roots(polyKoeff);
    
    % Välj den rot som ligger inom intervallet
    giltigaRotter = rotter(real(rotter) >= min(tidIntervall) & real(rotter) <= max(tidIntervall));
    [~, narmast] = min(abs(giltigaRotter - validaTider(i)));
    exaktaTiderKvadrat(i) = giltigaRotter(narmast);
end

% Beräkna svängningstiden baserat på de kvadratiskt interpolerade tidpunkterna
perioderKvadrat = diff(exaktaTiderKvadrat);
medelPeriodKvadrat = mean(perioderKvadrat);

% Beräkna skillnaden mellan svängningstiderna
skillnad = abs(medelPeriodLin - medelPeriodKvadrat);

% Visa svängningstider med 8 decimalers noggrannhet
fprintf('Svängningstid med linjär interpolation: %.10f sekunder\n', medelPeriodLin);
fprintf('Svängningstid med kvadratisk interpolation: %.10f sekunder\n', medelPeriodKvadrat);
fprintf('Skillnaden mellan linjär och kvadratisk interpolation: %.10f sekunder\n', skillnad);
