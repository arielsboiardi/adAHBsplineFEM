classdef marker_out
    properties
        ind     % vettore logico contente 1 per elemtni marcati 
        numel   % numero di elementi marcati
    end
    
    methods
        function marked = marker_out(ind, num)
            % Costruttore della classe
            marked.ind=ind;
            marked.numel=num;
        end
        
        function show(marked, space, lev)
            % Evidenzia gli elementi marcati nello spazio space
            %
            % INPUTS:
            %
            %   marked: desctizione degli elementi marcati marker_out
            %   space: Bspline_sapce in cui evidenziare gli elementi
            %   lev: livello a cui nel grafico vengono visualizzati, nel
            %   caso manchi vengono mostrati nella parte più bassa del
            %   grafico.
            %
            
            if nargin==2
                ylims=get(gca,'YLim');
                lev=ylims(1);
            end
            
            indc=find(marked.ind);
            Xi=space.knots;
            hold on
            for idx=1:marked.numel
                plot([Xi(indc(idx)), Xi(indc(idx)+1)],[lev, lev],...
                    'marker','square',...
                    'color','red',...
                    'linewidth',2.5)
            end
            
        end
            
    end
end
