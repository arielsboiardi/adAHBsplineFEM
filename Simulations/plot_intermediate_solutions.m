%% Plot intermediate solutions 
noiter=solver_out.NoIter;

for k=1:noiter
    [uh,Ah]=HBspline_solver(probdata, hspace);
    uhfn=@(t) hspace.HBspline_appr(uh,t);
    
    figure
    plot(t,uhfn(t),'LineWidth',1)
    ylim([-0.2,1.2]);
    pbaspect([20,14,1])
    set(gcf,'PaperPosition',[0,0,20,14]) 
    print(num2str(k),'-depsc','-noui')
    close all
    
    L=hspace.nlev;
    
    % Residuo
    if k==1
        etaR=hLocResFast(uh,probdata, hspace);
    else
        etaR=hLocResFast(uh,probdata, hspace, etaR);
    end
    eta=hGlobRes(etaR);     % residuo globale
    
    % Marcatura
    markersetting=marker_set(solver_set.Marker,solver_set.theta,...
        solver_set.PreMark,solver_set.PreMarkPerc,...
        true,solver_set.maxRelResLoc);
    marked_cells=Marker(etaR{L},markersetting);
   
    % Passo la marcatura sulle B-splines
    marked_Bsplines=HBspline_Marker(hspace, marked_cells);
    
    % Raffinamento
    hspace=hspace.refine(marked_Bsplines);
end

