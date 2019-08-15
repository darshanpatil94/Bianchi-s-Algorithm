% Calculations based on Bianchi's paper
clear; clc; close all;
% Set default parameters from the paper
SIFS = 28; 
DIFS = 128; 
slot_time = 50; 
prop_delay = 1; %in us (microseconds)
PayLoad = 8184; 
MAC_header = 272; 
PHY_header = 128; 
ack = 112; % in bits
H = MAC_header + PayLoad + PHY_header; % in bits
ACK = 112 + PHY_header;  % in bits
Ts = (H + SIFS + ACK + DIFS + 2 * prop_delay)/slot_time;
Tc = (H + DIFS + prop_delay)/slot_time;

% Set the window size and stage number
W=32;
m=3;
% Computation
throughput1=[];
itr=50;
for n=5:1:itr % Start from 5 stations condition
    fn = @(p)(p-1+(1-2*(1-2*p)/((1-2*p)*(W+1)+p*W*(1-(2*p)^m)))^(n-1));
    % P is the probability that transmitted packet collide
    P = fzero(fn,[0,1]); 
    % tau is probability that a station transmits in a generic slot time
    tau = 2*(1-2*P)/((1-2*P)*(W+1)+P*W*(1-(2*P)^m));
    % Ptr is that in a slot time there is at least one transmission
    Ptr = 1-(1 - tau)^n;
    % Ps is the probability that a transmission is successful
    Ps = n*tau*(1-tau)^(n-1)/Ptr;
    % ETX is the number of consecutive idle slots between two consecutive transmissions on the channel
    E_Idle=1/Ptr-1;
    % Throughput = Ps * E[P] / (ETX + Ps * Ts + (1 - Ps) * Tc)
    S=Ps*(PayLoad/slot_time)/(E_Idle+Ps*Ts+(1-Ps)*Tc);
    throughput1=[throughput1,S];
end
plot(5:1:itr,throughput1,'LineWidth',1.5);
hold on;
axis([0 itr 0.5 0.9]);
xlabel('Number of Stations');
ylabel('Saturation throughput');
title('Saturation throughput vs Number of different stations in basic case');
grid on;

%W=32 m=5
W=32;
m=5;
throughput2 = [];
for n = 5:1:itr
    fn = @(p)(p-1+(1-2*(1-2*p)/((1-2*p)*(W+1)+p*W*(1-(2*p)^m)))^(n-1));
    P = fzero(fn,[0,1]);
    tau = 2*(1-2*P)/((1-2*P)*(W+1)+P*W*(1-(2*P)^m));
    Ptr = 1-(1 - tau)^n;
    Ps = n*tau*(1-tau)^(n-1)/Ptr;
    E_Idle=1/Ptr-1;
    S=Ps*(PayLoad/slot_time)/(E_Idle+Ps*Ts+(1-Ps)*Tc);
    throughput2=[throughput2,S];
end
plot(5:1:itr,throughput2,'LineWidth',1.5);
hold on;

%W=128, m=3
W=128;
m=3;
throughput3 = [];
for n = 5:1:itr
    fn = @(p)(p-1+(1-2*(1-2*p)/((1-2*p)*(W+1)+p*W*(1-(2*p)^m)))^(n-1));
    P = fzero(fn,[0,1]);
    tau = 2*(1-2*P)/((1-2*P)*(W+1)+P*W*(1-(2*P)^m));
    Ptr = 1-(1 - tau)^n;
    Ps = n*tau*(1-tau)^(n-1)/Ptr;
    E_Idle=1/Ptr-1;
    S=Ps*(PayLoad/slot_time)/(E_Idle+Ps*Ts+(1-Ps)*Tc);
    throughput3=[throughput3,S];
end
plot(5:1:itr,throughput3,'LineWidth',1.5);
legend('W=32, m=3','W=32, m=5',' W=128, m=3');
hold off;