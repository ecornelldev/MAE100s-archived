function plot_measurements(measurements, measurement, alpha,  plot_title, external_figure)
figure
N = size(measurements,2);
h = subplot(1,1,1);


plot(measurements','.-')
hold on
h.ColorOrderIndex = 1;
plot(measurement','-','linewidth',2)
xlabel('measurements')
ylabel('distance measured')
axis([1 N -2 5]);
title(plot_title); 

numAlpha = length(alpha); 
labels = {};  
for i=1:numAlpha
    labels =[labels, "sensor's location: " + num2str(alpha(i)*180/pi)]; 
end
legend(labels); 
if external_figure
    set(gcf,'Visible','on')
end
end

