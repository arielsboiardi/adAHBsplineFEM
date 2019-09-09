function F=HBspline_load(hspace, probdata)
% HBspline_load costruisce il vettore di carico per la discretizzazione del
% problema debole descritto da probdata nello spazio gerarchico hspace.
%
%   F=HBspline_load(hspace, probdata)
%
% INPUTS:
%
%   hsapce:     HBspline_space che descrive lo spazio gerarchico in cui il
%               problema viene discretizzato
%   probdata:   problem_data_set che desctrive il problema (vedere la
%               rispettiva classe)
%
% OUTPUTS:
%
%   F:          vettore di carico per il sistema lineare ottenuto dalla
%               discretizzazione del problema probdata nello spazio
%               gerarchico dato