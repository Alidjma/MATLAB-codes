disp("Uppgift 1: Linjära ekvationssystem:")
% beräkning av matrisen Ax=b

disp("1a)")
A = [1,2,3,0;0,4,5,6;1,1,-1,0;1,1,1,1];
b = [7,6,5,4]';
x = A\b
% beräkningarna stämmer och
% kontrollerades med matrixcalc
% och miniräknare


% beräkning av matris r = b - Ax
disp("1b)")
r = b - A*x


disp("1c) förklaring Varför blir inte residualvektorn r exakt")
disp(" lika med noll, given i kommentaren")
% Residualvekorn blir ej 0,
% då det linjära ekvationssystemet
% inte alltid har en unik lösning.
% Vi undersöker approximationer i
% residualvektorn och jämför faktiskt
% värde och approximativt värde. Om
% vi får 0 finns unik lösning, annars
% är det ej en unik lösning."

