syms x
disp('Uppgift 6e')

% Definerar den modifierade integranden
mod_integrand = (1-exp(-(x/5).^4)) ./ (x.^4);

% Deklarerar funktionen för integranden och dess andraderivata
mod_integrand_f = matlabFunction(mod_integrand);
dff_mod_integrand = diff(mod_integrand, x, 2);
dff_mod_integrand_f = matlabFunction(dff_mod_integrand);

% Startvärde, slutvärde och antal steg givet
a = eps;
b = 3163;
n = 10e3;

% Beräknar steglängd
h = (b - a) / n;

% Initialisera summan för trapetsregeln
summa = 0;

% Loop för att beräkna summatermen som ingår i trapetsregeln
for k = 1:(n-1)
    summa = summa + mod_integrand_f(a + h * k);
end

% Beräkna trapetsregeln
Tn = h * ((mod_integrand_f(a) + 2 * summa + mod_integrand_f(b)) / 2);

disp(Tn)

disp('Uppgift 6f')

% Börja vid a+2, ty integralen uppträder sig oförutsägbart nära noll
x = linspace(a+2, b, n);

% Undersökver andraderivatans största värde
big_numbers = abs(dff_mod_integrand_f(x));

% Bestämmer andraderivatans största värde
maximum = max(big_numbers);

% Uppskattar felgräns
fel = abs(-(b-a)^3 / (12*n^2) * maximum);

disp(fel)
