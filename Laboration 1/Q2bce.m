disp("2b) Skissa graf");
x2 = 0:0.01:7; % Mer finjusterat interval
f1 = @(x) -20.*x.*exp(-x);
f2 = @(x) 61.*x - ((x.^2 + x + 0.03)./(3.*x + 1)).^7;

figure;
plot(x2, f1(x2), x2, f2(x2)); % Plot both functions on the same graph
grid on; % Activate grid
title("Graf utan inzooming till rötterna");
xlabel("x");
ylabel("y");
legend('f1(x)', 'f2(x)');
hold on;

% Zooma in för bättre avläsning
f = @(x) 61.*x - ((x.^2 + x + 0.03)./(3.*x + 1)).^7 - 20.*x.*exp(-x);

% Första subplot för intervallet 0-0,2
subplot(1, 2, 1);
fplot(f, [0, 0.2]);
grid on;
title("Zooma in i rot nära 0");
xlabel("x");
ylabel("f(x)");

% Andra subplot för intervallet 6,3-6,5
subplot(1, 2, 2);
fplot(f, [6.3, 6.5]);
grid on;
title("Zooma in i rot nära 6.4");
xlabel("x");
ylabel("f(x)");

% 2c) Newtons metod
disp("2c) Newtons metod");
f_prim = @(x) 61 - 7.*((x.^2 + x + 0.03).^6).*(2.*x + 1)./((3.*x + 1).^7) ...
           - (140.*x.*(x.^2 + x + 0.03).^6)./((3.*x + 1).^8) - 20.*exp(-x) + 20.*x.*exp(-x);
       
% Initialgissningar och Newtons metod loop
x = 6.4; % Startar från 6,4 
x1 = 0; % Startar från 0
format long;
for i = 1:50 % Sätter en fixerad maximal iteration istället för en intervall-loop
   x_new = x - f(x)/f_prim(x);
   x1_new = x1 - f(x1)/f_prim(x1);
   % Kontrollerar om skillnaden mellan den nya och den gamla gissningen är mindre än en given tolerans
   if abs(x_new - x) < 1e-8 && abs(x1_new - x1) < 1e-8
       break; % Bryter om både x och x1 konvergerar
   end
  
   x = x_new;
   x1 = x1_new;
end

max_newton = x;
min_newton = x1;

disp(["Största rot funnen med Newtons metod: ", num2str(max_newton)]);
disp(["Minsta rot funnen med Newtons metod: ", num2str(min_newton)]);

% 2e) Bestämma konvergenskonstanten Newtons metod
disp("2e) Bestämma konvergenskonstanten Newtons metod");
syms x;
f_prim_sym = 61 - 7*((x^2 + x + 0.03)^6)*(2*x + 1)/((3*x + 1)^7) ...
          - (140*x*(x^2 + x + 0.03)^6)/((3*x + 1)^8) - 20*exp(-x) + 20*x*exp(-x);

% Integrera derivatan för att få den ursprungliga funktionen f(x)
F = int(f_prim_sym, x);

% Justera den integrerade funktionen så att f(0) = 0
f_sym = F - subs(F, x, 0);

% Andra derivatan av den ursprungliga funktionen f(x)
f_bis_sym = diff(f_prim_sym, x);

% Konvertera funktionerna till numeriska funktioner för beräkning
f_num = matlabFunction(f_sym);
f_prim_num = matlabFunction(f_prim_sym);
f_bis_num = matlabFunction(f_bis_sym);

% Använd de funna rötterna från Newtons metod
max_rot = max_newton;
min_rot = min_newton;

% Beräkna konvergenskonstanten för större och mindre roten
C_max = abs(f_bis_num(max_rot) / (2 * f_prim_num(max_rot)));
C_min = abs(f_bis_num(min_rot) / (2 * f_prim_num(min_rot)));

disp(["Konvergenskonstanten vid den större roten: ", num2str(C_max)]);
disp(["Konvergenskonstanten vid den mindre roten: ", num2str(C_min)]);