    clc;
    disp("Interpolation och linjära minsta kvadratmetoden");

    % Inledande Data
    datum = [1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 365];
    tid = [6.25, 8.1, 10.55, 13.23, 15.9, 18.06, 18.4, 16.63, 14.08, 11.4, 8.78, 6.6, 6.23];
    x_plot = linspace(min(datum), max(datum), 1000);

    % Samla alla data och plotta i en enda figur
    figure;

    % 1. Polynom av grad 12
    subplot(4, 2, 1);
    warning('off', 'all'); % Stäng av varningar
    p12 = polyfit(datum, tid, 12);
    warning('on', 'all'); % Slå på varningar igen
    y12 = polyval(p12, x_plot);
    plot(datum, tid, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Data'); hold on;
    plot(x_plot, y12, 'b-', 'DisplayName', 'Polynom av grad 12');
    xlabel('Dag på året');
    ylabel('Minuter av dagsljus');
    title('Anpassning med polynom av grad 12');
    grid on;
    hold off;

    % 2. Styckvis linjär interpolation
    subplot(4, 2, 2);
    y_linear = interp1(datum, tid, x_plot, 'linear');
    plot(datum, tid, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Data'); hold on;
    plot(x_plot, y_linear, 'b-', 'DisplayName', 'Styckvis linjär interpolation');
    xlabel('Dag på året');
    ylabel('Minuter av dagsljus');
    title('Styckvis linjär interpolation');
    grid on;
    hold off;

    % 3. Kubiska splines
    subplot(4, 2, 3);
    y_spline = spline(datum, tid, x_plot);
    plot(datum, tid, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Data'); hold on;
    plot(x_plot, y_spline, 'b-', 'DisplayName', 'Kubisk spline');
    xlabel('Dag på året');
    ylabel('Minuter av dagsljus');
    title('Anpassning med kubisk spline');
    grid on;
    hold off;

    % 4. Andragrads polynom (specifika datum)
    subplot(4, 2, 4);
    datum_subset = [152, 182, 213];
    tid_subset = [18.06, 18.4, 16.63];
    p2_subset = polyfit(datum_subset, tid_subset, 2);
    y2_subset = polyval(p2_subset, x_plot);
    plot(datum_subset, tid_subset, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Observerade data'); hold on;
    plot(x_plot, y2_subset, 'b-', 'DisplayName', 'Andragradspolynom');
    xlabel('Dag på året');
    ylabel('Timmar av dagsljus');
    title('Andragradspolynom för specifika datum');
    grid on;
    hold off;

    % 5. Andragrads polynom (flera datum)
    subplot(4, 2, 5);
    datum_multiple = [91, 121, 152, 182, 213, 244];
    tid_multiple = [13.23, 15.91, 18.06, 18.4, 16.63, 14.08];
    p2_multiple = polyfit(datum_multiple, tid_multiple, 2);
    y2_multiple = polyval(p2_multiple, x_plot);
    plot(datum_multiple, tid_multiple, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Observerade data'); hold on;
    plot(x_plot, y2_multiple, 'b-', 'DisplayName', 'Andragradspolynom');
    xlabel('Dag på året');
    ylabel('Timmar av dagsljus');
    title('Andragradspolynom för flera datum');
    grid on;
    hold off;

    % 6. Trigonometrisk anpassning
    subplot(4, 2, 6);
    w = 2*pi / 365;
    f = @(c,x) c(1) + c(2) * cos(w*x) + c(3) * sin(w*x);
    start_values = [0, 0, 0];
    options = optimset('Display', 'off'); % Stäng av optimeringsutskrifter
    constants = lsqcurvefit(f, start_values, datum, tid, [], [], options);
    y_trig = f(constants, x_plot);
    plot(datum, tid, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Data'); hold on;
    plot(x_plot, y_trig, 'b-', 'DisplayName', 'Trigonometrisk anpassning');
    xlabel('Dag på året');
    ylabel('Minuter av dagsljus');
    title('Trigonometrisk anpassning');
    grid on;
    hold off;

    % 7. Andragrads polynom (årsdata)
    subplot(4, 2, 7);
    p2_year = polyfit(datum, tid, 2);
    y2_year = polyval(p2_year, x_plot);
    plot(datum, tid, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Observerade data'); hold on;
    plot(x_plot, y2_year, 'b-', 'DisplayName', 'Andragradspolynom');
    xlabel('Dag på året');
    ylabel('Timmar av dagsljus');
    title('Årlig andragradspolynomanpassning');
    grid on;
    hold off;

    % 8. Andragrads polynom för December till Februari
    subplot(4, 2, 8);
    modifierade_datum = [335, 365, 32];  % Dagnummer för 1 Dec, 31 Dec och 1 Feb
    modifierade_tid = [6.6, 6.23, 8.1];  % Använd negativa värden för demonstration
    p2_dec_feb = polyfit(modifierade_datum, modifierade_tid, 2);
    y2_dec_feb = polyval(p2_dec_feb, linspace(min(modifierade_datum), max(modifierade_datum), 1000));
    plot(modifierade_datum, modifierade_tid, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Observerade data'); hold on;
    plot(linspace(min(modifierade_datum), max(modifierade_datum), 1000), y2_dec_feb, 'b-', 'DisplayName', 'Andragradspolynom');
    xlabel('Dag på året');
    ylabel('Negativa timmar av dagsljus');
    title('Andragradspolynom för Dec till Feb');
    grid on;
    hold off;