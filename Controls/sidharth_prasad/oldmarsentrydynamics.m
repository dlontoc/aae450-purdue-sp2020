Vinf = 5*10^3; % m/s
mu_p = 4.282837*10^13; %m^3/s^2 grav param mars
re = 3389.5*10^3+135*10^3;
Vei = sqrt(Vinf^2+2*mu_p/re);
tspan = [0 1000];
y01 = [re,0,0,Vei,deg2rad(-25),0,0];
y02 = [re,0,0,Vei,deg2rad(-19),0,0];
y03 = [re,0,0,Vei,deg2rad(-14),0,0];
y04 = [re,0,0,Vei,deg2rad(-30),0,0];
[t1,y1] = ode45(@entrydynamics,tspan,y01);
[t2,y2] = ode45(@entrydynamics,tspan,y02);
[t3,y3] = ode45(@entrydynamics,tspan,y03);
[t4,y4] = ode45(@entrydynamics,tspan,y04);
%y(r,theta,phi,V,gamma,psi,s)
data = [t3, (y3(:,1)-3389.5*10^3)/1000, y3(:,4)/1000]


% figure()
% plot(y4(:,4)/1000,(y4(:,1)- 3389.5*10^3)/1000)
% hold on;
% plot(y1(:,4)/1000,(y1(:,1)- 3389.5*10^3)/1000)
% plot(y2(:,4)/1000,(y2(:,1)- 3389.5*10^3)/1000)
% plot(y3(:,4)/1000,(y3(:,1)- 3389.5*10^3)/1000)
% xlabel('Velocity (km/s)');
% ylabel('Altitude (km)');
% legend('Gamma = -30','Gamma = -25','Gamma = -19', 'Gamma = -14');
% grid on;
% title('Velocity vs. Altitude for Taxi (BC 150)');
 
% figure()
% plot(t,(y(:,1)- 3389.5*10^3)/1000);
% xlabel('Time (s)');
% ylabel('Altitude');
% grid on;
% title('Altitude vs. Time for Taxi (BC 300, Gamma -16)');

function rho = density(r)
r_mars =  3389.5*10^3; % in m
alt = r-r_mars; %altitude
rho = 0.013*exp(-alt/11000);  %(1/0.013)*e^alt; % density in kg/m^3
end
 
function dydt=entrydynamics(t,y)
%y(r,theta,phi,V,gamma,psi,s)
%dydt (rdot,thetadot,psidot,Vdot,gammadot,psidotsd0t)
 
sigma = 0;% bank angle
q = 1/2*density(y(1))*y(4)^2;%dynamic pressure
m = 22633.00; % vehicle mass
CD = 1.7;%coeff drag
A = 50;%Ref Area approx of space shuttle lander
LD = 0;%.24 is the MSL; % 0.8 % Lift/Drag approximated from space shuttle, now using from esa's ixv
Beta = 200; %m / (CD*A)%Ballistic Coefficient
mu_p = 4.282837*10^13; %m^3/s^2 grav param mars
gr = -mu_p/y(1)^2;%radial grav component
 
dydt(1)= y(4)*sin(y(5));
dydt(2)= y(4)*cos(y(5))*cos(y(6))/(y(1)*cos(y(3)));
dydt(3)= y(4)*cos(y(5))*cos(y(6))/(y(1));
dydt(4)= -q/Beta + gr*sin(y(5));
dydt(5)= (q*LD)/(y(4)*Beta)*cos(sigma) + 1/y(4)*(gr*cos(5)) + (y(4)*cos(y(5))/y(1));
dydt(6)= (q*LD)/(y(4)*Beta)*sin(sigma)/cos(y(4)) - y(4)/y(1)*cos(y(5))*cos(y(6))*tan(y(3));
dydt(7)= y(4)*cos(y(5));
dydt = dydt';
end

function dydt=entrydynamicsbankup(t,y)
%y(r,theta,phi,V,gamma,psi,s)
%dydt (rdot,thetadot,psidot,Vdot,gammadot,psidotsd0t)
 
sigma = 180;% bank angle
q = 1/2*density(y(1))*y(4)^2;%dynamic pressure
m = 22633.00; % vehicle mass
CD = 1.7;%coeff drag
A = 50;%Ref Area approx of space shuttle lander
LD = 0.24;%.4; % 0.8 % Lift/Drag approximated from space shuttle, now using from esa's ixv
Beta = 200; %m / (CD*A)%Ballistic Coefficient
mu_p = 4.282837*10^13; %m^3/s^2 grav param mars
gr = -mu_p/y(1)^2;%radial grav component
 
dydt(1)= y(4)*sin(y(5));
dydt(2)= y(4)*cos(y(5))*cos(y(6))/(y(1)*cos(y(3)));
dydt(3)= y(4)*cos(y(5))*cos(y(6))/(y(1));
dydt(4)= -q/Beta + gr*sin(y(5));
dydt(5)= (q*LD)/(y(4)*Beta)*cos(sigma) + 1/y(4)*(gr*cos(5)) + (y(4)*cos(y(5))/y(1));
dydt(6)= (q*LD)/(y(4)*Beta)*sin(sigma)/cos(y(4)) - y(4)/y(1)*cos(y(5))*cos(y(6))*tan(y(3));
dydt(7)= y(4)*cos(y(5));
dydt = dydt';
end
