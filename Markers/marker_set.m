classdef marker_set
    properties
        type        % tipo di marcatore da usare: può essere Dorfler o Max
        theta       % soglia theta per il marcatore
        premark     % valore logico per attivare il premarcatore 
        eps         % soglia del premarking
        thres_mark  % attivazione del marcatore a soglia 
        thres       % soglia
    end
    
    methods
        function markerset=marker_set(type, theta, premark, eps, thres_mark, thres)
            % Costruttore delle classe marker_set. Specifica il tipo di
            % marker e la rispettiva soglia e le altre impostazioni
            % documentate dalle proprietà della classe.
            
            markerset.type=type;
            markerset.theta=theta;
            markerset.premark=premark;
            markerset.eps=eps;
            markerset.thres_mark=thres_mark;
            markerset.thres=thres;
            
        end
    end
end
    
