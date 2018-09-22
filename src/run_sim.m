% This script will configure and run the simulation.

disp( '#######################' );

prepare_sim;

% constants for mtb
driver_mass=70;
bike_mass=20;
vehicle_mass=driver_mass+bike_mass;
gravity=9.8;
rolling_fric_coeff=0.006;
air_density=1.225;
air_drag_coeff=1.1;
frontal_area=0.5;


%% first simulation run
% update model parameters
disp( 'Updating model parameters for first simulation run.' );

simin = simin3; % realistic speed

simOut1 = sim('ebike_UB_2.mdl', 'SimulationMode', 'normal', ...
    'SignalLogging','on','SignalLoggingName','logsout');
power1 = simOut1.get('simout_power');
energy1 = simOut1.get('simout_energy');
movement1 = simOut1.get('simout_movement');


figure(1)
% Slope and acce vs downhill
subplot(3,1,1);
plot(movement1.time(:,1), movement1.data(:,1), 'b', 'LineWidth', 1); %speed
title('Velocity');
xlabel( 'Time (in h)' );
ylabel( 'Velocity (in m/s)');

subplot(3,1,2);
plot(movement1.time(:,1), movement1.data(:,2), 'r', 'LineWidth', 1); %slope
title('Slope');
xlabel( 'Time (in h)' );
ylabel( 'Slope (in percentange)');

subplot(3,1,3);
plot(power1.time(:,1), power1.data(:,4), 'r', 'LineWidth', 1) % downhill
title('Calculated Power of Uphill');
xlabel( 'Time (in h)' );
ylabel( 'Power (in Watts)');


figure(2)
% velocity and Slope vs downhill

subplot(3,1,1);
plot(movement1.time(:,1),movement1.data(:,1), 'b', 'LineWidth', 1); %speed
title('Velocity');
xlabel( 'Time (in h)' );
ylabel( 'Velocity (in m/s)');

subplot(3,1,2);
plot(movement1.time(:,1),movement1.data(:,2), 'r', 'LineWidth', 1); %slope
title('Slope');
xlabel( 'Time (in h)' );
ylabel( 'Slope (in percentange)');

subplot(3,1,3);
plot(power1.time(:,1), power1.data(:,5), 'blue', 'LineWidth', 1) % fric
title('Calculated Power of Rolling Friction');
xlabel( 'Time (in h)' );
ylabel( 'Power (in Watts)');

figure(3)
% velocity vs airdrag

subplot(2,1,1);
plot(movement1.time(:,1),movement1.data(:,1), 'b', 'LineWidth', 1); %speed
title('Velocity');
xlabel( 'Time (in h)' );
ylabel( 'Velocity (in m/s)');

subplot(2,1,2);
plot(power1.time(:,1), power1.data(:,6), 'g', 'LineWidth', 1) % airdrag
title('Calculated Power of Airdrag');
xlabel( 'Time (in h)' );
ylabel( 'Power (in Watts)');

figure(4)
% acce and velocity vs acce power

subplot(3,1,1);
plot(movement1.time(:,1),movement1.data(:,1), 'b', 'LineWidth', 1); %speed
title('Velocity');
xlabel( 'Time (in h)' );
ylabel( 'Velocity (in m/s)');

subplot(3,1,2);
plot(movement1.time(:,1),movement1.data(:,3), 'm', 'LineWidth', 1); %acce
title('Acceleration');
xlabel( 'Time (in h)' );
ylabel( 'Acceleration (in m/s^2)');

subplot(3,1,3);
plot(power1.time(:,1), power1.data(:,7), 'm', 'LineWidth', 1) % acce
title('Calculated Power of Acceleration');
xlabel( 'Time (in h)' );
ylabel( 'Power (in Watts)');


figure(5)
% total power

plot(power1.time(:,1), power1.data(:,4), 'r', ... % downhill
    power1.time(:,1), power1.data(:,5), 'blue', ... % fric
    power1.time(:,1), power1.data(:,6), 'g', ... % airdrag
    power1.time(:,1), power1.data(:,7), 'm', ... % acce
    power1.time(:,1), power1.data(:,3), 'black', 'LineWidth', 1); % total
legend({'Hill', 'Rolling Friction', 'Air Drag', 'Acceleration', 'Total'}, 'FontSize', 13);
title('Total Power', 'FontSize', 14);
xlabel( 'Time (in h)', 'FontSize', 12 );
ylabel( 'Power (in Watts)', 'FontSize', 12);


figure(6)
% speed vs power support with percentange distr.
subplot(2,1,1)
plot(movement1.time(:,1),movement1.data(:,1), 'b', 'LineWidth', 1); % speed
title('Velocity', 'FontSize', 13);
xlabel( 'Time (in h)' , 'FontSize', 12);
ylabel( 'Velocity (in m/s)', 'FontSize', 12);
subplot(2,1,2)
plot(power1.time(:,1), power1.data(:,8), 'r', 'LineWidth', 1); %  
title('Power Support Capacity Based on Velocity', 'FontSize', 13);
xlabel( 'Time (in h)' , 'FontSize', 12);
ylabel( 'Power (in Watts)', 'FontSize', 12);

figure(7)
% power calculation of support and driver
plot(power1.time(:,1), power1.data(:,1), 'b', ...
    power1.time(:,1), power1.data(:,2), 'r', ...
    power1.time(:,1), power1.data(:,3), 'g', 'LineWidth', 1);
xlabel( 'time (in h)', 'FontSize', 12);
ylabel( 'power (in Watts)', 'FontSize', 12);
title('Power Calculation ', 'FontSize', 14);
legend ({'Driver Support', 'Motor Support','Total'}, 'FontSize', 14);

mtb_power = [ power1.time(:,1), power1.data(:,1) , power1.data(:,2), power1.data(:,3) ];


figure(8)
% energy consumption
subplot(2,1,1);
plot(energy1.time(:,1), energy1.data(:,1), 'k',  ...
    energy1.time(:,1), energy1.data(:,2), 'b', ...
    energy1.time(:,1), energy1.data(:,3), 'r', 'LineWidth', 1);
legend({'Total', 'Driver', 'Motor'}, 'FontSize', 13);
title('Energy Consumption', 'FontSize', 14);
xlabel( 'time (in h)' , 'FontSize', 12);
ylabel( 'energy (in Wh)' , 'FontSize', 12);

subplot(2,1,2);
plot(energy1.time(:,1), energy1.data(:,4), 'black');
title('Remaining Battery', 'FontSize', 14);
xlabel( 'time (in h)' , 'FontSize', 12);
ylabel( 'energy (in Ah)' , 'FontSize', 12);

mtb_energy = [ energy1.time(:,1), energy1.data(:,1) , energy1.data(:,2), energy1.data(:,3), energy1.data(:,4) ];


%% second simulation run
% update model parameters
disp( 'Updating model parameters for second simulation run.' );

% constants for racing bike
driver_mass=70;
bike_mass=12;
vehicle_mass=driver_mass+bike_mass;
gravity=9.8;
rolling_fric_coeff=0.003;
air_density=1.225;
air_drag_coeff=0.4;
frontal_area=0.38;


simin = simin3; % realistic speed

simOut1 = sim('ebike_UB_2.mdl', 'SimulationMode', 'normal', ...
    'SignalLogging','on','SignalLoggingName','logsout');
power1 = simOut1.get('simout_power');
energy1 = simOut1.get('simout_energy');
movement1 = simOut1.get('simout_movement');



% figure(9)
% % Slope and acce vs downhill
% subplot(3,1,1);
% plot(movement1.time(:,1), movement1.data(:,1), 'b', 'LineWidth', 1); %speed
% title('Velocity');
% xlabel( 'Time (in h)' );
% ylabel( 'Velocity (in m/s)');
% 
% subplot(3,1,2);
% plot(movement1.time(:,1), movement1.data(:,2), 'r', 'LineWidth', 1); %slope
% title('Slope');
% xlabel( 'Time (in h)' );
% ylabel( 'Slope (in percentange)');
% 
% subplot(3,1,3);
% plot(power1.time(:,1), power1.data(:,4), 'r', 'LineWidth', 1) % downhill
% title('Calculated Power of Uphill');
% xlabel( 'Time (in h)' );
% ylabel( 'Power (in Watts)');
% 
% 
% figure(10)
% % velocity and Slope vs downhill
% 
% subplot(3,1,1);
% plot(movement1.time(:,1),movement1.data(:,1), 'b', 'LineWidth', 1); %speed
% title('Velocity');
% xlabel( 'Time (in h)' );
% ylabel( 'Velocity (in m/s)');
% 
% subplot(3,1,2);
% plot(movement1.time(:,1),movement1.data(:,2), 'r', 'LineWidth', 1); %slope
% title('Slope');
% xlabel( 'Time (in h)' );
% ylabel( 'Slope (in percentange)');
% 
% subplot(3,1,3);
% plot(power1.time(:,1), power1.data(:,5), 'blue', 'LineWidth', 1) % fric
% title('Calculated Power of Rolling Friction');
% xlabel( 'Time (in h)' );
% ylabel( 'Power (in Watts)');
% 
% figure(11)
% % velocity vs airdrag
% 
% subplot(2,1,1);
% plot(movement1.time(:,1),movement1.data(:,1), 'b', 'LineWidth', 1); %speed
% title('Velocity');
% xlabel( 'Time (in h)' );
% ylabel( 'Velocity (in m/s)');
% 
% subplot(2,1,2);
% plot(power1.time(:,1), power1.data(:,6), 'g', 'LineWidth', 1) % airdrag
% title('Calculated Power of Airdrag');
% xlabel( 'Time (in h)' );
% ylabel( 'Power (in Watts)');
% 
% figure(12)
% % acce and velocity vs acce power
% 
% subplot(3,1,1);
% plot(movement1.time(:,1),movement1.data(:,1), 'b', 'LineWidth', 1); %speed
% title('Velocity');
% xlabel( 'Time (in h)' );
% ylabel( 'Velocity (in m/s)');
% 
% subplot(3,1,2);
% plot(movement1.time(:,1),movement1.data(:,3), 'm', 'LineWidth', 1); %acce
% title('Acceleration');
% xlabel( 'Time (in h)' );
% ylabel( 'Acceleration (in m/s^2)');
% 
% subplot(3,1,3);
% plot(power1.time(:,1), power1.data(:,7), 'm', 'LineWidth', 1) % acce
% title('Calculated Power of Acceleration');
% xlabel( 'Time (in h)' );
% ylabel( 'Power (in Watts)');
% 
% 
% figure(13)
% % total power
% 
% plot(power1.time(:,1), power1.data(:,4), 'r', ... % downhill
%     power1.time(:,1), power1.data(:,5), 'blue', ... % fric
%     power1.time(:,1), power1.data(:,6), 'g', ... % airdrag
%     power1.time(:,1), power1.data(:,7), 'm', ... % acce
%     power1.time(:,1), power1.data(:,3), 'black', 'LineWidth', 1); % total
% legend({'Hill', 'Rolling Friction', 'Air Drag', 'Acceleration', 'Total'}, 'FontSize', 13);
% title('Total Power', 'FontSize', 14);
% xlabel( 'Time (in h)', 'FontSize', 12 );
% ylabel( 'Power (in Watts)', 'FontSize', 12);
% 
% 
% figure(14)
% % speed vs power support with percentange distr.
% subplot(2,1,1)
% plot(movement1.time(:,1),movement1.data(:,1), 'b', 'LineWidth', 1); % speed
% title('Velocity', 'FontSize', 13);
% xlabel( 'Time (in h)' , 'FontSize', 12);
% ylabel( 'Velocity (in m/s)', 'FontSize', 12);
% subplot(2,1,2)
% plot(power1.time(:,1), power1.data(:,8), 'r', 'LineWidth', 1); %  
% title('Power Support Capacity Based on Velocity', 'FontSize', 13);
% xlabel( 'Time (in h)' , 'FontSize', 12);
% ylabel( 'Power (in Watts)', 'FontSize', 12);
% 
% figure(15)
% % power calculation of support and driver
% plot(power1.time(:,1), power1.data(:,1), 'b', ...
%     power1.time(:,1), power1.data(:,2), 'r', ...
%     power1.time(:,1), power1.data(:,3), 'g', 'LineWidth', 1);
% xlabel( 'time (in h)', 'FontSize', 12);
% ylabel( 'power (in Watts)', 'FontSize', 12);
% title('Power Calculation ', 'FontSize', 14);
% legend ({'Driver Support', 'Motor Support','Total'}, 'FontSize', 14);
% 
% 
% 
% figure(16)
% % energy consumption
% subplot(2,1,1);
% plot(energy1.time(:,1), energy1.data(:,1), 'k',  ...
%     energy1.time(:,1), energy1.data(:,2), 'b', ...
%     energy1.time(:,1), energy1.data(:,3), 'r', 'LineWidth', 1);
% legend({'Total', 'Driver', 'Motor'}, 'FontSize', 13);
% title('Energy Consumption', 'FontSize', 14);
% xlabel( 'time (in h)' , 'FontSize', 12);
% ylabel( 'energy (in Wh)' , 'FontSize', 12);
% 
% subplot(2,1,2);
% plot(energy1.time(:,1), energy1.data(:,4), 'black');
% title('Remaining Battery', 'FontSize', 14);
% xlabel( 'time (in h)' , 'FontSize', 12);
% ylabel( 'energy (in Ah)' , 'FontSize', 12);


figure(17)
% power calculation of support and driver
subplot(2,1,1);
plot(power1.time(:,1), power1.data(:,1), 'b', ...
    power1.time(:,1), power1.data(:,2), 'r', ...
    power1.time(:,1), power1.data(:,3), 'g', 'LineWidth', 1);
xlabel( 'time (in h)', 'FontSize', 12);
ylabel( 'power (in Watts)', 'FontSize', 12);
title('Power Calculation (Racing)', 'FontSize', 14);
legend ({'Driver Support', 'Motor Support','Total'}, 'FontSize', 14);

subplot(2,1,2);
plot(mtb_power(:,1), mtb_power(:,2), 'b', ...
    mtb_power(:,1), mtb_power(:,3), 'r', ...
    mtb_power(:,1), mtb_power(:,4), 'g', 'LineWidth', 1);
xlabel( 'time (in h)', 'FontSize', 12);
ylabel( 'power (in Watts)', 'FontSize', 12);
title('Power Calculation (MTB)', 'FontSize', 14);
legend ({'Driver Support', 'Motor Support','Total'}, 'FontSize', 14);


% mtb vs racing
figure(18)
% energy consumption
subplot(2,1,1);
plot(energy1.time(:,1), energy1.data(:,1), 'k',  ...
    energy1.time(:,1), energy1.data(:,2), 'b', ...
    energy1.time(:,1), energy1.data(:,3), 'r', ...
    mtb_energy(:,1), mtb_energy(:,2), 'k--',  ...
    mtb_energy(:,1), mtb_energy(:,3), 'b--', ...
    mtb_energy(:,1), mtb_energy(:,4), 'r--', 'LineWidth', 1);
legend({'Total (Racing)', 'Driver (Racing)', 'Motor (Racing)', 'Total (MTB)', 'Driver (MTB)', 'Motor (MTB)' }, 'FontSize', 13);
title('Energy Consumption', 'FontSize', 14);
xlabel( 'time (in h)' , 'FontSize', 12);
ylabel( 'energy (in Wh)' , 'FontSize', 12);

subplot(2,1,2);
plot(energy1.time(:,1), energy1.data(:,4), 'k', ...
    mtb_energy(:,1), mtb_energy(:,5), 'k--');
legend({'Racing', 'MTB'}, 'FontSize', 13);
title('Remaining Battery', 'FontSize', 14);
xlabel( 'time (in h)' , 'FontSize', 12);
ylabel( 'energy (in Ah)' , 'FontSize', 12);

%% clean up workspace
disp( 'Cleaning up Workspace.' );
% clear parameters

% clear simulation output


disp( 'Done.' );
disp( '#######################' );