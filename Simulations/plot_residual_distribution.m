% It is needed to have in workspace     
%   uhfn    approximated solutiona as fn_handle
%   probdata    data of the problem
%   space       Bspline space

uex=probdata.uex;

err_pt=@(x) abs(uhfn(x)-uex(x));
plot(t,err_pt(t))
hold on 

%% Residuals
etaR=LocalRes(uh,probdata,space);

Xi=space.knots;
h=diff(Xi);
mid_knots=Xi(1:end-1)+h/2;

plot(mid_knots,etaR, 'kdiamond');
set(gca,'YScale','log')

legend('Pointwise error','Local residual','interpreter','latex')
