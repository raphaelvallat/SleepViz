function B = moving_average(A,n)
%   function B = moving_average(A,n);
%   calcul d'une moyenne mobile
%   A est la matrice des donnees en entree
%    les vecteurs a traiter sont en colonne dans A
%   n est le nombre de points dans la moyenne
%   B est le resultat, de meme dimension que A
%   remplissage des bords par 1ere et derniere valeurs correctes

N=numel(A);
if n<=1 disp('Incorrect value'), return, end
B=zeros(size(A));
p=fix(n./2);
if rem(n,2)==0    % n est pair, moyenne mobile disymetrique
    pav=p;
    pap=p-1;
else              % n est impair, moyenne mobile symetrique
    pav=p;
    pap=p;
end
for j=pav+1:N-pap
    B(j,:)=sum(A(j-pav:j+pap,:))./n;
end
for j=1:pav
    B(j,:)=B(pav+1,:);
end
for j=N-pap+1:N
    B(j,:)=B(N-pap,:);
end
