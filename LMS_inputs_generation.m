clc;
clear;

N = 100;
t = 0:N-1;

% Clean signal
signal = sin(2*pi*0.05*t);

% Noise
noise = 0.5*randn(1,N);

% Noisy signal
noisy = signal + noise;

% Fixed point scaling (Q4.12)
scale = 2^12;
fixed = round(noisy * scale);

fid = fopen('LMS_inputs.txt','w');
for i = 1:N
    val = fixed(i);
    if val < 0
        val = 2^16 + val;
    end
    bin = dec2bin(val,16);
    fprintf(fid,'%s\n',bin);
end
fclose(fid);

disp('File LMS_inputs.txt generated successfully')

plot(noisy)
title('Noisy Signal')
grid on
