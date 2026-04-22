
%Δω=2LR
R1 = 0.0001;
R2 = 0.001;

L1 = 0.01;
C1 = 0.001;
%theoretical_res_freq_1 = 1/(2*pi*sqrt(L1*C1));

L2 = 0.01;
C2 = 0.001*4;
%theoretical_res_freq_2 = 1/(2*pi*sqrt(L2*C2));

low_freq = 1;
high_freq = 100;
n=100;
stab_part = 0.1;

freq_range = linspace(low_freq,high_freq,n);
RLC_gain = zeros(n,1);

for k = 1:length(freq_range)
    disp(k)
    exc_freq = freq_range(k);  %voltage source definition
    %sim("LCR_parallel_filter_embedded_blocks.slx");
    sim("zadanie_5a_simulink_model.slx");
    %plot(ans.R_voltage)
    stab_signal = ans.R_voltage.Data(round((1-stab_part)*length(ans.R_voltage.Data)):end);
    stab_signal = stab_signal(:);
    Vpp = max(stab_signal) - min(stab_signal);
    RLC_gain(k) = Vpp;
end

plot(freq_range,RLC_gain)