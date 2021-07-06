function plotOdds(plot_title)
figure
p = .001:.001:.999;
subplot(1,2,1)

f1 = p./(1-p);
plot(p,f1,'k','linewidth',2)
axis([0 1 0 100])
title('Odds')
xlabel('p(m = 1)')
ylabel('Odds')
grid on
subplot(1,2,2)


f = -log(1./p -1);
plot(p,f,'k','linewidth',2)
axis([0 1 -6 6])
grid on
title('log Odds')
xlabel('p(m = 1)')
ylabel('log(Odds)')
title (plot_title); 
end