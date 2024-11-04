clc;
f = @(x) 61.*x - ((x.^2 + x + 0.03)./(3.*x + 1)).^7 - 20.*x.*exp(-x);
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

% Öka konstanten 20 med 1%
konstant_upp = 20 * 1.01;
f_upp = @(x) 61.*x - ((x.^2 + x + 0.03)./(3.*x + 1)).^7 - konstant_upp.*x.*exp(-x);
f_prim_upp = @(x) 61 - 7.*((x.^2 + x + 0.03).^6).*(2.*x + 1)./((3.*x + 1).^7) ...
           - (140.*x.*(x.^2 + x + 0.03).^6)./((3.*x + 1).^8) - konstant_upp.*exp(-x) + konstant_upp.*x.*exp(-x);

% Newtons metod med ökad konstant
x = 6.4; % Startar från 6,4 
x1 = 0; % Startar från 0
format long;
for i = 1:50
   x_new = x - f_upp(x)/f_prim_upp(x);
   x1_new = x1 - f_upp(x1)/f_prim_upp(x1);
   if abs(x_new - x) < 1e-8 && abs(x1_new - x1) < 1e-8
       break;
   end
   x = x_new;
   x1 = x1_new;
end

max_newton_upp = x;
min_newton_upp = x1;

% Beräkna förändringen i rötterna
change_max_upp = ((max_newton_upp - max_newton) / max_newton) * 100;
change_min_upp = ((min_newton_upp - min_newton) / min_newton) * 100;

disp(["Förändring i största rot med ökad konstant: ", num2str(change_max_upp), "%"]);
disp(["Förändring i minsta rot med ökad konstant: ", num2str(change_min_upp), "%"]);

% Minska konstanten 20 med 1%
konstant_ned = 20 * 0.99;
f_ned = @(x) 61.*x - ((x.^2 + x + 0.03)./(3.*x + 1)).^7 - konstant_ned.*x.*exp(-x);
f_prim_ned = @(x) 61 - 7.*((x.^2 + x + 0.03).^6).*(2.*x + 1)./((3.*x + 1).^7) ...
           - (140.*x.*(x.^2 + x + 0.03).^6)./((3.*x + 1).^8) - konstant_ned.*exp(-x) + konstant_ned.*x.*exp(-x);

% Newtons metod med minskad konstant
x = 6.4; % Startar från 6,4 
x1 = 0; % Startar från 0
format long;
for i = 1:50
   x_new = x - f_ned(x)/f_prim_ned(x);
   x1_new = x1 - f_ned(x1)/f_prim_ned(x1);
   if abs(x_new - x) < 1e-8 && abs(x1_new - x1) < 1e-8
       break;
   end
   x = x_new;
   x1 = x1_new;
end

max_newton_ned = x;
min_newton_ned = x1;

% Beräkna förändringen i rötterna
change_max_ned = ((max_newton_ned - max_newton) / max_newton) * 100;
change_min_ned = ((min_newton_ned - min_newton) / min_newton) * 100;

disp(["Förändring i största rot med minskad konstant: ", num2str(change_max_ned), "%"]);
disp(["Förändring i minsta rot med minskad konstant: ", num2str(change_min_ned), "%"]);
