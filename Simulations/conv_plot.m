%% Covnergence plot
max_iter=solver_set.maxIter;
for repeat=1:max_iter
    %% Risolutore ADATTIVO
    [uh,Ah]=HBspline_solver(probdata, hspace);
    uhfn=@(t) hspace.HBspline_appr(uh,t);
    dim=hspace.dim;
    L=hspace.nlev;
    
    % Residuo
    if repeat==1
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
    
    % Errore
    AdaptErr(repeat)=L2error(uhfn, probdata.uex, probdata.Omega);
    
    %% Risolutore UNIFORME con stesi DoF
    Xi=linspace(probdata.Omega(1), probdata.Omega(2), dim-deg+1); % nodi uniformi
    space=Bspline_space(deg,Xi); % spazio di approssimazione
    [uhfn_unif,uh_unif,A]=Bspline_solver(probdata,space);
    UnifErr(repeat)=L2error(uhfn_unif,probdata.uex,probdata.Omega);
    
    DOFS(repeat)=dim-2;
end

figure
plot(DOFS, AdaptErr, 'k-o')
hold on 
plot(DOFS, UnifErr, 'k-diamond')
set(gca,'YScale','log')
ylabel('$L^2$-norm error','interpreter','latex','FontSize',11)
xlabel('degrees of freedom', 'interpreter','latex','FontSize',11)
legend('Adaptive','Uniform','interpreter','latex','FontSize',11,'Location','SouthWest')
