clc;
format long
% Definiera funktioner
f = @(x) 61.*x - ((x.^2 + x + 0.03)./(3.*x + 1)).^7 - 20.*x.*exp(-x);
f_prim = @(x) 61 - 7.*((x.^2 + x + 0.03).^6).*(2.*x + 1)./((3.*x + 1).^7) ...
           - (140.*x.*(x.^2 + x + 0.03).^6)./((3.*x + 1).^8) - 20.*exp(-x) + 20.*x.*exp(-x);

% Initialgissningar och Newtons metod loop
x = 6.4; % Startar från 6,4 
format long;
for i = 1:50 % Sätter en fixerad maximal iteration istället för en intervall-loop
   x_new = x - f(x)/f_prim(x);
   if abs(x_new - x) < 1e-8 % Kontrollerar om skillnaden mellan den nya och den gamla gissningen är mindre än en given tolerans
       break; % Bryter om x konvergerar
   end
   x = x_new;
end

max_newton = x;

fprintf("Största rot funnen med Newtons metod: %.6f\n", max_newton);

% Öka konstanten 61 med 1%
konstant_a_upp = 61 * 1.01;
f_a_upp = @(x) konstant_a_upp.*x - ((x.^2 + x + 0.03)./(3.*x + 1)).^7 - 20.*x.*exp(-x);
f_prim_a_upp = @(x) konstant_a_upp - 7.*((x.^2 + x + 0.03).^6).*(2.*x + 1)./((3.*x + 1).^7) ...
              - (140.*x.*(x.^2 + x + 0.03).^6)./((3.*x + 1).^8) - 20.*exp(-x) + 20.*x.*exp(-x);

% Newtons metod med ökad konstant 61
x = 6.4; % Startar från 6,4 
for i = 1:50
   x_new = x - f_a_upp(x)/f_prim_a_upp(x);
   if abs(x_new - x) < 1e-8
       break;
   end
   x = x_new;
end

max_newton_a_upp = x;
change_max_a = ((max_newton_a_upp - max_newton) / max_newton) * 100;

fprintf("Största rot med ökad konstant 61: %.6f\n", max_newton_a_upp);
fprintf("Förändring i största rot med ökad konstant 61: %.6f%%\n", change_max_a);

% Öka konstanten 3 med 1%
konstant_b_upp = 3 * 1.01;
f_b_upp = @(x) 61.*x - ((x.^2 + x + 0.03)./(konstant_b_upp.*x + 1)).^7 - 20.*x.*exp(-x);
f_prim_b_upp = @(x) 61 - 7.*((x.^2 + x + 0.03).^6).*(2.*x + 1)./((konstant_b_upp.*x + 1).^7) ...
              - (140.*x.*(x.^2 + x + 0.03).^6)./((konstant_b_upp.*x + 1).^8) - 20.*exp(-x) + 20.*x.*exp(-x);

% Newtons metod med ökad konstant 3
x = 6.4; % Startar från 6,4 
for i = 1:50
   x_new = x - f_b_upp(x)/f_prim_b_upp(x);
   if abs(x_new - x) < 1e-8
       break;
   end
   x = x_new;
end

max_newton_b_upp = x;
change_max_b = ((max_newton_b_upp - max_newton) / max_newton) * 100;

fprintf("Största rot med ökad konstant 3: %.6f\n", max_newton_b_upp);
fprintf("Förändring i största rot med ökad konstant 3: %.6f%%\n", change_max_b);
