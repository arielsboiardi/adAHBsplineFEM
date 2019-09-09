function B=bspline(i,p,Xi,z)
% Valuta in z la i-esima B-spline di grado p sui nodi Xi costruita con la
% ricorsione di Cox-De Boor

% Inizializzo
B=0*z;

% Costruzione ricorsiva
if p==0
    % Caso base
    if Xi(i+1)<Xi(end)
        % Sui nodi interni
        B((Xi(i)<= z) & (z<Xi(i+1)))=1;
    else
        % Sul nodo finale
        B(Xi(i)<= z)=1;
    end
else
    % Non considero i termini con denominatore nullo
    d = Xi(i+p)-Xi(i);      % lato sx
    if d > 0
        B = B + (z-Xi(i)).*bspline(i,p-1,Xi,z)/d;
    end
    d = Xi(i+p+1)-Xi(i+1);  % lato dx
    if d > 0
        B = B + (Xi(i+p+1)-z).*bspline(i+1,p-1,Xi,z)/d;
    end
end
end
