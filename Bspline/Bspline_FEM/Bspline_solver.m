function [u, varargout]=Bspline_solver(probdata,Bspline_space)
% Risolutore complessivo del prolema probdata nello spazio di
% approssimazione Bspline_space.
%
% INPUTS:
%
%   probdata: problem_data, dati del problema (si veda la classe)
%   Bspline_space: Bspline_space, spazio di approssimazione (si veda la
%   classe)
%
% OUTPUTS:
%
%   u: function handle alla soluzione approssimata nello spazio scelto
%   uh: facoltativo, coordinate di u rispetto alla base di Bspline_space
%   A: facoltativo, matrice di rigidezza
%   F: facoltativo, vettore di carico
%

space=Bspline_space;

% Risoluzione
A=Bspline_Assembly(space,probdata);
F=Bspline_load(space,probdata);

uh=[probdata.u0; A\F; probdata.uL];
u=@(x) space.Bspline_appr(uh,x);

% Informzioni della risoluzione 
varargout{1}=uh;    
varargout{2}=A;
varargout{3}=F;
end