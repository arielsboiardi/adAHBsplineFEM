function dB=dbspline(i,p,Xi,z)
% Valuta in z la derivata della i-esima B-spline di grado p sui nodi Xi 
% costruita con la ricorsione di Cox-De Boor

dB=0*z;
if p>0
    d=Xi(i+p)-Xi(i);
    if d>0
        dB = dB + p/d * bspline(i,p-1,Xi,z);
    end
    d = Xi(i+p+1)-Xi(i+1);
    if d > 0
        dB = dB - p/d * bspline(i+1,p-1,Xi,z);
    end
end
end