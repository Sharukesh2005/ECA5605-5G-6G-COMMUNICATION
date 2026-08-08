clc;
clear;
close all;

%% ENERGY-EFFICIENT WIRELESS SENSOR NETWORK
% Design Task: Energy-efficient wireless communication strategy
% Application: Smart Agriculture

%% 1. Simulation Parameters

numNodes = 10;              % Number of sensor nodes
numRounds = 1000;           % Number of simulation rounds

initialEnergy = 100;        % Initial battery energy of each node (J)

packetSize = 4000;          % Packet size in bits

E_elec = 50e-9;             % Electronics energy (J/bit)
E_amp = 100e-12;            % Amplifier energy (J/bit/m^2)

E_sense = 0.001;            % Sensing energy per round (J)
E_process = 0.0005;         % Processing energy per round (J)
E_sleep = 0.00001;          % Sleep energy per round (J)

transmissionThreshold = 1.0; % Sensor data change threshold

%% 2. Generate Sensor Nodes

% Random node positions
nodeX = rand(1,numNodes) * 100;
nodeY = rand(1,numNodes) * 100;

% Gateway position
gatewayX = 50;
gatewayY = 50;

% Initial battery energy
batteryConventional = initialEnergy * ones(1,numNodes);
batteryProposed = initialEnergy * ones(1,numNodes);

% Previous sensor values
previousTemperature = 25 + rand(1,numNodes)*5;

%% 3. Storage Variables

energyConventional = zeros(1,numRounds);
energyProposed = zeros(1,numRounds);

packetsConventional = zeros(1,numRounds);
packetsProposed = zeros(1,numRounds);

averageBatteryConventional = zeros(1,numRounds);
averageBatteryProposed = zeros(1,numRounds);

%% 4. Simulation

for round = 1:numRounds

    totalEnergyC = 0;
    totalEnergyP = 0;

    totalPacketsC = 0;
    totalPacketsP = 0;

    for node = 1:numNodes

        %% Generate sensor reading
        temperature = 25 + 5*rand();

        %% Distance between node and gateway
        distance = sqrt((nodeX(node)-gatewayX)^2 + ...
                        (nodeY(node)-gatewayY)^2);

        %% Transmission energy
        E_tx = E_elec * packetSize + ...
               E_amp * packetSize * distance^2;

        %% ================================
        % Conventional Communication
        % ================================

        if batteryConventional(node) > 0

            % Sense + process + transmit
            energyUsedC = E_sense + E_process + E_tx;

            batteryConventional(node) = ...
                batteryConventional(node) - energyUsedC;

            if batteryConventional(node) < 0
                batteryConventional(node) = 0;
            end

            totalEnergyC = totalEnergyC + energyUsedC;
            totalPacketsC = totalPacketsC + 1;
        end

        %% ================================
        % Proposed Energy-Efficient Method
        % ================================

        if batteryProposed(node) > 0

            % Check whether the sensor value changed significantly
            dataChange = abs(temperature - previousTemperature(node));

            if dataChange >= transmissionThreshold

                % Significant change -> transmit
                energyUsedP = E_sense + E_process + E_tx;

                totalPacketsP = totalPacketsP + 1;

            else

                % No significant change -> sleep
                energyUsedP = E_sense + E_sleep;

            end

            batteryProposed(node) = ...
                batteryProposed(node) - energyUsedP;

            if batteryProposed(node) < 0
                batteryProposed(node) = 0;
            end

            totalEnergyP = totalEnergyP + energyUsedP;

            previousTemperature(node) = temperature;

        end

    end

    %% Store results

    energyConventional(round) = totalEnergyC;
    energyProposed(round) = totalEnergyP;

    packetsConventional(round) = totalPacketsC;
    packetsProposed(round) = totalPacketsP;

    averageBatteryConventional(round) = ...
        mean(batteryConventional);

    averageBatteryProposed(round) = ...
        mean(batteryProposed);

end

%% 5. Calculate Total Results

totalEnergyConventional = sum(energyConventional);
totalEnergyProposed = sum(energyProposed);

totalPacketsConventional = sum(packetsConventional);
totalPacketsProposed = sum(packetsProposed);

energySaving = ((totalEnergyConventional - ...
                 totalEnergyProposed) / ...
                 totalEnergyConventional) * 100;

packetReduction = ((totalPacketsConventional - ...
                    totalPacketsProposed) / ...
                    totalPacketsConventional) * 100;

%% 6. Display Results

fprintf('\n============================================\n');
fprintf(' ENERGY-EFFICIENT WIRELESS SENSOR NETWORK\n');
fprintf('============================================\n');

fprintf('\nNumber of Sensor Nodes      : %d', numNodes);
fprintf('\nSimulation Rounds           : %d', numRounds);

fprintf('\n\nConventional Method');
fprintf('\nTotal Energy Consumed       : %.4f J', ...
    totalEnergyConventional);

fprintf('\nTotal Packets Transmitted   : %d', ...
    totalPacketsConventional);

fprintf('\n\nProposed Energy-Efficient Method');
fprintf('\nTotal Energy Consumed       : %.4f J', ...
    totalEnergyProposed);

fprintf('\nTotal Packets Transmitted   : %d', ...
    totalPacketsProposed);

fprintf('\n\nEnergy Saving               : %.2f %%', ...
    energySaving);

fprintf('\nPacket Reduction            : %.2f %%', ...
    packetReduction);

fprintf('\n============================================\n');

%% 7. Plot Energy Consumption

figure;

plot(1:numRounds, cumsum(energyConventional), ...
    'LineWidth', 2);

hold on;

plot(1:numRounds, cumsum(energyProposed), ...
    'LineWidth', 2);

grid on;

xlabel('Simulation Round');
ylabel('Cumulative Energy Consumption (J)');

title('Energy Consumption Comparison');

legend('Conventional WSN', ...
       'Proposed Energy-Efficient WSN');

%% 8. Plot Battery Level

figure;

plot(1:numRounds, averageBatteryConventional, ...
    'LineWidth', 2);

hold on;

plot(1:numRounds, averageBatteryProposed, ...
    'LineWidth', 2);

grid on;

xlabel('Simulation Round');
ylabel('Average Remaining Battery (J)');

title('Battery Lifetime Comparison');

legend('Conventional WSN', ...
       'Proposed Energy-Efficient WSN');

%% 9. Plot Packet Transmission

figure;

plot(1:numRounds, cumsum(packetsConventional), ...
    'LineWidth', 2);

hold on;

plot(1:numRounds, cumsum(packetsProposed), ...
    'LineWidth', 2);

grid on;

xlabel('Simulation Round');
ylabel('Cumulative Packets Transmitted');

title('Packet Transmission Comparison');

legend('Conventional WSN', ...
       'Proposed Energy-Efficient WSN');

%% 10. Display Node Deployment

figure;

scatter(nodeX, nodeY, 80, 'filled');

hold on;

plot(gatewayX, gatewayY, 'p', ...
    'MarkerSize', 15, ...
    'MarkerFaceColor', 'k');

grid on;

xlabel('X Position (m)');
ylabel('Y Position (m)');

title('Wireless Sensor Network Deployment');

legend('Sensor Nodes', 'Gateway');
