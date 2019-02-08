function ranks=ranks_by_random_walk(graph,N,initial_state)
J=min(size(graph)); % J : total number of states
nr_neighbors = sum(graph); % number of neighbours of each state

% Here we construct a matrix which contains the indices of the states
% that each state is linked to.
% This matrix called "Neighbors" will serve as a lookup-table
% in order to find out to which state exactly should the random walker
% go. Specifically Neighbors(m,n)=f, if f is not zero, means that
% state m is linked to state f

k=max(nr_neighbors);
Neighbors=zeros(J,k);
for i=1:J
  temp=find(graph(i,:));
  Neighbors(i,1:length(temp))=temp;
end

i=initial_state; % Starting State
nr_visits=zeros(J,1);
for n=1:N
  nr_visits(i)=nr_visits(i)+1;
  i=Neighbors(i,randi(nr_neighbors(i)));
end
ranks=nr_visits/N;
end

clc;close all;clear all;
collaboration_matrix % Loads the collaboration graph
J=min(size(graph));
figure
for j=1:3
  N=10ˆ(4+j);
  tic
  ranks=ranks_by_random_walk(graph,N,1);
  t=toc
  subplot(3,1,j)
  bar(1:J,ranks,’r’)
  title([’N=10ˆ’,num2str(j+4), ’ Computation time is ’,num2str(t),’sec’],’FontSize’,12)
end

clc;close all;clear all;
collaboration_matrix % Loads the collaboration graph
graph=[graph ones(J,1);ones(1,J) 0]; % Augmenting with the
% fully connected node (professor)
J=min(size(graph));

figure
for j=1:3
  N=10ˆ(4+j);
  tic
  ranks=ranks_by_random_walk(graph,N,1);
  t=toc
  subplot(3,1,j)
  bar(1:J,ranks,’r’)
  title([’N=10ˆ’,num2str(j+4), ’ Computation time is ’,num2str(t),’sec’],’FontSize’,12)
end

function ranks=ranks_by_probability_update(graph,N,initial_distribution)
J=min(size(graph)); % J : total number of states
pi_D=initial_distribution; % given initial distribution
nr_neighbors = sum(graph);
transition_probabilities = graph;
for k=1:J
  if nr_neighbors(k)>0
    transition_probabilities(k,:)=graph(k,:)/nr_neighbors(k);
  else
    transition_probabilities(k,k)=1;
  end
end
for n=1:N
  pi_D=transition_probabilities’*pi_D; % Probability updates
end
ranks=pi_D;
end

clc;close all;clear all;
collaboration_matrix % Loads the collaboration graph
graph=[graph ones(J,1);ones(1,J) 0]; % Augmenting with the% fully connected node (professor)
J=min(size(graph)); % J : total number of states
nr_neighbors = sum(graph);
transition_probabilities = graph;
for k=1:J
  if nr_neighbors(k)>0
    transition_probabilities(k,:)=graph(k,:)/nr_neighbors(k);
  else
    transition_probabilities(k,k)=1;
  end
end
figure
tic
[V,D]=eig(transition_probabilities’); % Perform eigendecomposition of P’ranks=V(:,1)/sum(V(:,1)); % Normalize dominant eigenvector
t=toc
% Plot results
bar(1:J,ranks,’r’)
title([’Recasting as Linear system problem,’, ’ Computation time is ’,num2str(t),’sec’],’FontSize’,12)
xlabel(’states’,’Fontsize’,12)
ylabel(’ranks’,’Fontsize’,12)
