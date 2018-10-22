% ************************************************************************%   Description:%   FUNCTION SPINLIBV (rjd)%   This subroutine provides, in time domain, the semi-diurnal variations%   of UT1 (s) and LOD (s) due to the action of the lunisolar tidal%   potential on the (2,2) terms of geopotential, in an elastic Earth%   with rotationonally symmetrical liquid core. Listed are all terms%   with amplitudes larger than 0.033 us. (Brzezinski and Capitaine,%   2002, Journees 2001)%    %    N.B.:  The fundamental lunisolar arguments are those of Simon et al.  %%    These corrections should be added to "average"%    EOP values to get estimates of the instantaneous values.%%   Input:%     rjd           epoch of interest given in mjd (n,1) - dynamical%                   time or TT%                %   Output:%     cor_ut1       tidal correction in UT1-UTC (sec. of time)%     (cor_lod       tidal correction in length of day (sec. of time))%    % %   External calls: 	%     fund_arg.m, as2rad.m%%   Coded for VieVS:%   02 Feb 2009 by Sigrid Englich%%   Revision: %   26 May 2010 by Lucia Plank: external function for fundamental arguments%% *************************************************************************function [cor_ut1]=spinlibV(rjd)% [cor_ut1,cor_lod]=spinlibV(rjd)dim=size(rjd);if dim(2)>dim(1); rjd=rjd'; end;         halfpi = 1.5707963267948966;%  Oceanic tidal terms present in x (microas),y(microas),ut1(microseconds)       %  NARG(j,6) : Multipliers of GMST+pi and Delaunay arguments. NARG=[...2,-2, 0,-2, 0,-22, 0, 0,-2,-2,-22,-1, 0,-2, 0,-22, 1, 0,-2,-2,-22, 0, 0,-2, 0,-12, 0, 0,-2, 0,-22, 1, 0,-2, 0,-22, 0,-1,-2, 2,-22, 0, 0,-2, 2,-22, 0, 0, 0, 0, 02, 0, 0, 0, 0,-1];coeff= [...              % units are 0.1 us  -0.275,   0.479  -0.330,   0.575  -1.999,   3.482  -0.378,   0.658   0.375,  -0.653 -10.051,  17.508   0.274,  -0.477  -0.255,   0.445  -4.364,   7.603  -1.179,   2.054  -0.351,   0.612];UTSIN=coeff(:,2);UTCOS=coeff(:,1);%   Convert to julian centuries          T = (rjd - 51544.5)/36525.0;  % julian century% Arguments in the following order : chi=GMST+pi,l,lp,F,D,Omega% et leur derivee temporelle       ARG = fund_arg(T,3); % [rad]      %       DARG1 = (876600*3600 + 8640184.812866+... %                  2 * 0.093104 * T - 3 * 6.2e-6*T.^2)*15;%       DARG1 = DARG1* secrad / 36525.0;   %! rad/day% %       %       DARG2 = -4*0.00024470*T.^3 + 3*0.051635*T.^2+ ... %                  2*31.8792*T + 1717915923.2178; %       DARG2 = DARG2* secrad / 36525.0;   %! rad/day% %       %       DARG3 = -4*0.00001149*T.^3 - 3*0.000136*T.^2-...%                  2*0.5532*T + 129596581.0481;%       DARG3 = DARG3* secrad / 36525.0;   %! rad/day%       % %       DARG4 = 4*0.00000417*T.^3 - 3*0.001037*T.^2-... %                 2 * 12.7512*T + 1739527262.8478; %       DARG4 = DARG4* secrad / 36525.0;   %! rad/day%    % %       DARG5 = -4*0.00003169*T.^3 + 3*0.006593*T.^2-...%                  2 * 6.3706*T + 1602961601.2090;%       DARG5 = DARG5* secrad / 36525.0;   %! rad/day% % %       DARG6 = -4*0.00005939*T.^3 + 3 * 0.007702*T.^2+...%                  2 * 7.4722*T - 6962890.2665;%       DARG6 = DARG6* secrad / 36525.0;   %! rad/day% CORRECTIONS% DARG=[DARG1 DARG2 DARG3 DARG4 DARG5 DARG6];    agt=NARG*ARG';%     dagt=NARG*DARG';    agt=mod(agt,4.*halfpi);    cor_ut1= cos(agt')*UTCOS   + sin(agt')*UTSIN;%     cor_lod= dagt'.*sin(agt')*UTCOS   - dagt'.*cos(agt')*UTSIN;   	       cor_ut1 = cor_ut1 * 1e-7;   % ! second (s)%     cor_lod = cor_lod * 1e-7;   % ! second (s)                   