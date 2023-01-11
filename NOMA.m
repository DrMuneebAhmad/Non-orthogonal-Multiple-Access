% n0.0f bits for transmit signal: 100 bits only - Multiply '/25' for 4 bits
close all; clear all;clc;
        TxBits_n = 100;
        t_s=0.001:0.001:0.1;
% distance from Base Station (BS) to Primary User, to User1, to User2
% Assuming d_max=10, attenuation calculation
        DstBStoPUser_dp = 3;
        DstBStoUser1_ds1 = 2;
        DstBStoUser2_ds2 = 4;
        MaxDsttoUser_00 = 10;
      SumSquareDst_00=DstBStoPUser_dp^2+DstBStoUser1_ds1^2+DstBStoUser2_ds2^2;
      
% power allocation for Primary User, User1 and User 2 - TNY:
%       pp=0.5;
%       p1=0.3; inverse from SMT: p1<->p2
%       p2=0.2; inverse from SMT: p1<->p2
%
% NOMA corrected: farther away from Base Station (BS), more allocated power;
% Assuming the Base Station (BS) has total power of 1 and will allocate
% power for each User as proportional to squared distance: Pwr ~ Dst^2
        TotPwrBS_00 = 1.0;
          % previously suggested: 0.3
          PwrPUser_pp = TotPwrBS_00*(DstBStoPUser_dp^2)/SumSquareDst_00;
          % previously suggested: 0.2
          PwrUser1_p1 = TotPwrBS_00*(DstBStoUser1_ds1^2)/SumSquareDst_00;
          % previously suggested: 0.5
          PwrUser2_p2 = TotPwrBS_00*(DstBStoUser2_ds2^2)/SumSquareDst_00;

% Correct (actual) binary messages of 'TxBits_n' bits length:
% equal probability of 0 and 1 in every bit;
%   'rand'  generates numbers in [0 to 1], uniformally distributed;
%   Mean is 0.5
        SgnPUser_xp = rand(1,TxBits_n) > 0.5;
        SgnUser1_xs1 = rand(1,TxBits_n) > 0.5;
        SgnUser2_xs2 = rand(1,TxBits_n) > 0.5;

%%% Superposition Encoding
% Direct sum of signals: incorrect  - SMT: X=xp+xs1+xs2;
% NOMA: Power-domain Multiplexing, sum of products signal*sqrt(power) - TNY:
        Enc_X = sqrt(PwrPUser_pp)*SgnPUser_xp;
        Enc_X = sqrt(PwrUser1_p1)*SgnUser1_xs1 + Enc_X;
        Enc_X = sqrt(PwrUser2_p2)*SgnUser2_xs2 + Enc_X;
        
%%% Received signals for all Users
% Adding Gaussian Noise: use 'randn' instead of 'rand':
%   'randn' generates numbers in [-Inf,+Inf], normally distributed (Gaussian);
%   Mean is zero, but with strong concetration in [-1 to +1];
%   'rand'  generates numbers in [0 to 1], uniformally distributed;
%   Mean is 0.5
%
% NOMA: Additive White Gaussian Noise (AWGN) with ZERO MEAN and double-side
%  power spectral density, N0/2.
% Noise variation on time N(t) (addition): different for every bit;
%
% Since 'randn' concetrates in [-1 to +1] or even larger and a bit is only
% [0 or 1], and Power<=1 the Signal-to-Noise Ratio (SNR) could be too low.
% So a constant to reduce Noise level is necessary.
%
        NoiseReduc_0 = 10; 
        NoisePUser_N = randn(1,TxBits_n)/NoiseReduc_0;
        NoiseUser1_N = randn(1,TxBits_n)/NoiseReduc_0;
        NoiseUser2_N = randn(1,TxBits_n)/NoiseReduc_0;
% Channel Attenuation Gain (multiplier): different for every User/channel,
% no variation on time. Attenuation is inversely proportional to the power
% and directly proportional to squared distance.
% As the allocated power is proportional to squared distance: Pwr ~ Dst^2,
% it makes all Attenuations become a "boring" constant (0.71 in this case).
% So a random System Loss inversely proportional to power was included to
% increase the unpredictability of simulation.
%
  SyLosPUser_00 = 1 + rand/(10*PwrPUser_pp);
  AtnGnPUser_00 = TotPwrBS_00/PwrPUser_pp * 1/SyLosPUser_00;
  AtnGnPUser_00 = AtnGnPUser_00*(DstBStoPUser_dp^2)/(MaxDsttoUser_00^2);
  AtnGnPUser_00 = 1 - AtnGnPUser_00;
  SyLosUser1_00 = 1 + rand/(10*PwrUser1_p1);
  AtnGnUser1_00 = TotPwrBS_00/PwrUser1_p1 * 1/SyLosUser1_00;
  AtnGnUser1_00 = AtnGnUser1_00*(DstBStoUser1_ds1^2)/(MaxDsttoUser_00^2);
  AtnGnUser1_00 = 1 - AtnGnUser1_00;
  SyLosUser2_00 = 1 + rand/(10*PwrUser2_p2);
  AtnGnUser2_00 = TotPwrBS_00/PwrUser2_p2 * 1/SyLosUser2_00;
  AtnGnUser2_00 = AtnGnUser2_00*(DstBStoUser2_ds2^2)/(MaxDsttoUser_00^2);
  AtnGnUser2_00 = 1 - AtnGnUser2_00;

        RxSgnPUser_ysp = Enc_X*AtnGnPUser_00 + NoisePUser_N;
        RxSgnUser1_ys1 = Enc_X*AtnGnUser1_00 + NoiseUser1_N;
        RxSgnUser2_ys2 = Enc_X*AtnGnUser2_00 + NoiseUser2_N;
        
       figure(1)
       subplot(2,1,1);plot(t_s,RxSgnUser1_ys1);
       title('User 1');xlabel('Time (s)');ylabel('Amplitude');grid on
       subplot(2,1,2);plot(t_s,RxSgnUser2_ys2);
       title('User 2');xlabel('Time (s)');ylabel('Amplitude');grid on
