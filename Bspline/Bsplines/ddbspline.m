function ddB=ddbspline(i,p,Xi,z)
% Valuta in z la derivata seconda della i-esima B-spline di grado p sul
% vettore di nodi Xi.

ddB=0*z;

if p>1
    d=Xi(i+p)-Xi(i);
    if d>0
        ddB = ddB + p/d * dbspline(i,p-1,Xi,z);
    end
    d = Xi(i+p+1)-Xi(i+1);
    if d>0 
        ddB = ddB - p/d * dbspline(i+1,p-1,Xi,z);
    end
end
end