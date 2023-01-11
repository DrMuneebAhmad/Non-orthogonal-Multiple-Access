%%A simulation for Wavelet based NOMA (W-NOMA)
%This code is to simulate the SNR equations of W-NOMA
%for considered received signal to noise ratio
close all;clear all;clc;
M = 10^3; 
p=1; %total power
a1=0.6;a2=0.25;a3=0.15; %fractions of power to NOMA users

%%The power given to the users determines the received SNR; generally, 
% for NOMA users, the transmit SNR is assumed in the literature; 
% however, in this case, the received SNR is according to the initial 
% transmit power, which explains why the nearby user would experience more
% interference because its power is lowest.
SNR1=0.001:-9.0000e-05:0.0001; %rcvd snr of user 1 near user
SNR2=0.00025:-2.2500e-05:0.000025; %rcvd snr of user 2 Intermediate user
SNR3=0.000075:-6.7500e-06:0.0000075; %rcvd snr of user 3 far user

E_b=p/M;
Eb_No=E_b./SNR1;Eb_NodB=10.*log(Eb_No);
Eb_No2=E_b./SNR2;Eb_No2dB=10.*log(Eb_No2);
Eb_No3=E_b./SNR3;Eb_No3dB=10.*log(Eb_No3);

SER_1=erfc(sqrt(2*a1.*(Eb_No)))+erfc(sqrt(2*a2.*(Eb_No)));
SER_2=erfc(sqrt(2*a2.*(Eb_No2)));
SER_3=erfc(sqrt(2*a3.*(Eb_No3)));

%%Plotting results
figure(1)
semilogy(Eb_NodB,SER_1,'-.bo')
axis([0 30 10^-6 1])
title('SER vs Eb/No')
xlabel('Eb/No')
ylabel('SER')
hold on;semilogy(Eb_NodB,SER_2,'-.rd')
title('SER vs Eb/No')
xlabel('Eb/No')
ylabel('SER')
hold on;semilogy(Eb_NodB,SER_3,'-.mh')
title('SER vs Eb/No')
xlabel('Eb/No')
ylabel('SER');grid on;
legend('user 1','user 2','user 3')
%%For your simulation you can replace the rcvd snr values with yours.
% However, for trnasmit snr you must equate the equations again