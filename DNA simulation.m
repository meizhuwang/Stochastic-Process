close all; clear;clc;
X_o = 100;max_t = 50;max_types = 1000; % a safely large number (matlab reallocates size if this% is not enough)mu = 1.05;
q = 10ˆ-2;

X=zeros(max_types, max_t); % preallocate vector
for population sizenumber_of_types=zeros(1, max_t); % preallocate vector for number of types
X(1:X_o,1) = 1;
number_of_types(1)=X_o; %initialize first generation
number_of_extinct_types=zeros(1,max_t);

for n=2:max_t
  disp([’n=’,num2str(n)])
  number_of_types(n)=number_of_types(n-1);
  for type = 1:number_of_types(n-1);
    for i = 1:X(type,n-1)
      daughters = poissrnd(mu,1,1); % daw number of daughters
      mutation = binornd(1,q,1,1); % draw mutation indicator
      if mutation
        number_of_types(n) = number_of_types(n)+1;
        X(number_of_types(n),n) = daughters;
      else
        X(type,n) = X(type,n) + daughters;
      end % if-else
    end % i
    if X(type,n)== 0
      number_of_extinct_types(n)=number_of_extinct_types(n)+1;
    end % if
  end % type
end % n

figure
plot(1:max_t, X)
xlabel(’generation’,’FontSize’,14)
ylabel(’number of women of each type’,’FontSize’,14)
title(’$q=10ˆ{-2},$ $X_{0}=100,$ $n=50$’,’FontSize’,14,’Interpreter’,’latex’)

figure
stairs(1:max_t, X’)
xlabel(’generation’,’FontSize’,14)
ylabel(’number of women of each type’,’FontSize’,14)
title(’$q=10ˆ{-2},$ $X_{0}=100,$ $n=50$’,’FontSize’,14,’Interpreter’,’latex’)

figure
stairs(1:max_t, [number_of_types;number_of_extinct_types]’,’LineWidth’,2)
xlabel(’generation’,’FontSize’,14)
ylabel(’number of women of each type’,’FontSize’,14)
title(’$q=10ˆ{-2},$ $X_{0}=100,$ $n=50$’,’FontSize’,14,’Interpreter’,’latex’)
axis([0 50 0 number_of_types(end)])
legend(’number of types’,’number of extinct types’,’Location’,’Best’)

figure
bar(1:number_of_types(end), X(1:number_of_types(end),max_t),’r’)
xlabel(’types’,’FontSize’,14)
ylabel(’number of women of each type’,’FontSize’,14)
title(’Histogram of the final number of women of each type’,’FontSize’,14)
