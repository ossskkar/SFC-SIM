close all; clear; clc;

t = (0:0.1:10)';
x = sawtooth(t);

y = awgn(x,1,'measured');
y2 = awgn(x,0.01,'measured');
plot(t,[x y y2])
legend('Original signal','Signal with AWGN 10','Signal with AWGN 1')