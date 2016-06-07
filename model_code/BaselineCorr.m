function [Corrected,bsler] = BaselineCorr(Chromato,varargin)

%% Performs baseline-correction of a GCxGC chromatogram.
% Two implemented methods:
% - Eilers' 1-D (using codes provided by Paul Eilers
% as SI to his paper; distributed under LICENSE.txt with his agreement)
% - Basic linear: simplist baseline correction, where for each pixel of a
% modulation we remove the intensity of the lowest valued pixel in this
% modulation.
% 
% *Inputs:*
% 
% - Chromato: only required input, a GCxGC chromatogram of n x m (n for
% second dimension, m for first dimension).
% Chromato can either be a 2-D matrix, or a structure with compulsory field
% .data (the 2-D matrix), and optional fields .SR and .MP (sampling rate
% and modulation period, [Hz] and [s])
% 
% - MP: modulation period, seconds. (alternative name is 'Mod')
% 
% - SR: sampling rate, Hertz (= 1/seconds). (alternative name is 'Freq')
% 
% - lambda: Eilers' code lambda. Default is 1e4. (But just enter the power
% of ten to be used. E.g. for having lambda = 1e4, do just set 'lambda' to
% 4 when calling the function.)
% 
% - p : Eilers' p. Default is 0.001.
% 
% - d: Eilers' d. Default is 2.
% 
% - method: 'Eilers' or 'basic linear'
% 
% *Outputs:*
% 
% - Corrected: The baseline-corrected chromatogram
% 
% - bsler: baseline.
% 
% File written by J.G., last modified on 4th August 2015.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%%
% Authors : Jonas Gros and J. Samuel Arey.
% See license terms stated in file:
% LICENSE.txt
% 
% Please cite the following articles when publishing any results obtained
% by use of this software. 
% 
% Eilers, P. H. C., "Parametric time warping", Anal. Chem. 2004, vol 76, 
% p 404?411.
% 
% Gros, J.; Reddy, C. M.; Aeppli, C.; Nelson, R. K.; Carmichael, C. A.; 
% Arey J. S., "Resolving biodegradation patterns of persistent saturated 
% hydrocarbons in weathered oil samples from the Deepwater Horizon disaster", 
% Environ. Sci. Technol. 2014, vol 48, num 3, p 1628-1637.
%%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% First, if ever the user used some options, give their values to the
% corresponding variables:
cnt = 1;
for i=cnt:2:length(varargin)
    if or(strcmpi(varargin{i},'MP'),strcmpi(varargin{i},'Mod')) % modulation period [s]
        MP=varargin{i+1};
    elseif or(strcmpi(varargin{i},'SR'),strcmpi(varargin{i},'Freq')) % sampling rate, frequency [Hz]
        SR=varargin{i+1};
    elseif strcmpi(varargin{i},'lambda')
        lambda=varargin{i+1};
    elseif strcmpi(varargin{i},'p')
        p=varargin{i+1};
    elseif strcmpi(varargin{i},'d')
        d=varargin{i+1};
    elseif strcmpi(varargin{i},'method')
        method=varargin{i+1};
    else
        error(['The option ''' varargin{i} ''' is unknown'])
    end
end

%  Set Eilers' parameters default values:
if ~exist('lambda','var')
    lambda = 1e4;    % lambda: smoothing parameter (generally 1e5 to 1e8)
else
    lambda = 10^(lambda);
end

if ~exist('method','var')
    method= 'Eilers';  
end

if ~exist('p','var')
    p = 0.001;           % p:   asymmetry parameter (generally 0.001)
end

if ~exist('d','var')
    d = 2;               % d:   order of differences in penalty (generally 2)
end

if isstruct(Chromato)
    if isfield(Chromato,'MP')
        MP = Chromato.MP;
    end
    if isfield(Chromato,'SR')
        SR = Chromato.SR;
    end
    Chromato = Chromato.data;
end

if strcmpi(method,'Eilers')

    % Prepare variables needed:
    nb_2nd=size(Chromato,2);
    nb_1st=size(Chromato,1);
    % bsler=zeros(MP*SR,nb_2nd);
    bsler=zeros(nb_1st,nb_2nd);

    for JJ=1:nb_2nd
        % Treat column JJ (call it ZI)
    ZI=Chromato(:,JJ);
    % Do Eilers 1-D baseline correction on column "ZI"
    z = asysm(ZI, lambda, p, d);
    bsler(:,JJ)=z;
    end
    bsler(bsler<0)=0; % just a plausibility check
    Corrected=Chromato-bsler; % The corrected chromatogram
    Corrected(Corrected<0)=0; %just a plausibility check
    bsler = Chromato - Corrected; % Just to be coherrent.
   
elseif or(strcmpi(method,'basic linear'),strcmpi(method,'basic-linear'))
    % Basic baseline correction (remove to each modulation the lowest value
    % in that modulation):
    Corrected = zeros(size(Chromato));
    for k = 1:size(Chromato,2)
        Corrected(:,k) = Chromato(:,k) - min(Chromato(:,k));
        bsler = Chromato - Corrected; % Just to be coherrent.
    end
    
else
    error(['The method  ''',method,''' is unknown please chose either ''Eilers'' or ''basic linear'''])
end



